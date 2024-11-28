import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:download_wallpapers/app/core/constants/app_keys.dart';
import 'package:download_wallpapers/app/core/constants/app_text.dart';
import 'package:download_wallpapers/app/core/constants/app_urls.dart';
import 'package:download_wallpapers/app/core/utils/enums.dart';
import 'package:download_wallpapers/app/core/utils/methods.dart';

class ApiResponce {
  final ApiResponceType type;
  final dynamic data;

  ApiResponce(this.type, this.data);
}

class ApiService {
  static Map<String, dynamic> errorResponse = {};
  static Dio dio = Dio();

  ///api method set up

  static Future<ApiResponce> call(
      {required ApiMethod method,
      required String url,
      var data,
      var queryParameters,
      Function(int, int)? onSendProgress,
      Function(int, int)? onRecieveProgress,
      Options? options}) async {
    dio.options.baseUrl = AppUrls.baseUrl;
    dio.options.queryParameters = {'client_id': AppKeys.unsplashAuthKey};
    dio.options.connectTimeout = const Duration(minutes: 1);
    dio.options.receiveTimeout = const Duration(minutes: 1);
    try {
      Response? response;
      switch (method) {
        case ApiMethod.get:
          if (data != null) {
            response = await dio.get(
              url,
              queryParameters: data,
              options: options ?? Options(),
            );
          } else {
            response = await dio.get(url,
                options: options ?? Options(),
                onReceiveProgress: onRecieveProgress);
          }
          break;
        case ApiMethod.post:
          response = await dio.post(url,
              data: data,
              queryParameters: queryParameters,
              onSendProgress: onSendProgress,
              onReceiveProgress: onRecieveProgress);
          break;
        case ApiMethod.delete:
          response = await dio.delete(url,
              data: data, queryParameters: queryParameters);
          break;
        case ApiMethod.update:
          response = await dio.put(url,
              data: data,
              queryParameters: queryParameters,
              onSendProgress: onSendProgress,
              onReceiveProgress: onRecieveProgress);
          break;
      }
      return ApiResponce(ApiResponceType.data, response.data);
    } on DioException catch (e) {
      log(e.response.toString());
      if (e.response?.statusCode == 400) {
        errorResponse["status"] = e.response?.data['success'];
        errorResponse["message"] = e.response?.data['message'];

        UtilMethods.getSnackBar(errorResponse["message"]);
        return ApiResponce(ApiResponceType.serverException, e.response?.data);
      } else if (e.response?.statusCode == 401) {
        errorResponse["status"] = "401";
        errorResponse["message"] = "Authorization error";

        print(errorResponse);
      } else if (e.response?.statusCode == 404) {
        // SnackBarWidget.getSnackBar(
        //     showText: "Server Unreachable, try later");
      } else if (e.response?.statusCode == 500) {
        UtilMethods.getSnackBar(AppText.wentWrong);
        return ApiResponce(ApiResponceType.serverException, e.response?.data);
      } else if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        UtilMethods.getSnackBar(AppText.connectionSpeed);
        return ApiResponce(ApiResponceType.internetException, e.response?.data);
      } else if (e.type == DioExceptionType.connectionError) {
        UtilMethods.getSnackBar(AppText.noInternet);
        return ApiResponce(ApiResponceType.internetException, e.response?.data);
      } else if (e.error is SocketException) {
        errorResponse["status"] = "101";
        errorResponse["message"] = "internet error";
        if (errorResponse["status"] == "101") {
          UtilMethods.getSnackBar(AppText.noInternet);
          return ApiResponce(ApiResponceType.internetException, errorResponse);
        }
      }

      return ApiResponce(ApiResponceType.serverException, e.response?.data);
    } catch (e) {
      log(e.toString());
      return ApiResponce(ApiResponceType.serverException, errorResponse);
    }
  }
}
