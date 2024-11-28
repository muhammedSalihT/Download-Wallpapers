import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:download_wallpapers/app/core/constants/app_text.dart';
import 'package:download_wallpapers/app/core/utils/enums.dart';
import 'package:download_wallpapers/app/core/utils/methods.dart';
import 'package:download_wallpapers/app/modules/model/home_data_model.dart';
import 'package:download_wallpapers/app/resources/home_resources.dart';
import 'package:download_wallpapers/app/services/api_service.dart';
import 'package:download_wallpapers/app/services/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoadingMoreItems = false;
  int currentLoadPageNumber = 0;
  ApiResponceType homeResponce = ApiResponceType.loading;
  List<HomeDataModel> photosList = [];
  ScrollController scrollController = ScrollController();

  Future<void> getHomePhotosData({bool isRetry = false}) async {
    try {
      if (isRetry) {
        _controlRetry();
      }
      final result = await HomeResources.getPhotosListApi(
          pageNumber: currentLoadPageNumber++);
      homeResponce = result.type;
      notifyListeners();
      if (homeResponce == ApiResponceType.data) {
        final dataList = homeDataModelFromJson(jsonEncode(result.data));
        if (dataList.isEmpty) {
          currentLoadPageNumber--;
          notifyListeners();
        } else {
          photosList.addAll(dataList);
        }
      }
    } catch (e) {
      homeResponce = ApiResponceType.internalException;
      notifyListeners();
    }
  }

  void setupScrollDownToLoadMoreItems() {
    try {
      scrollController.addListener(() async {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !isLoadingMoreItems) {
          _controlLoadingMoreValue(true);
          await getHomePhotosData();
          _controlLoadingMoreValue(false);
        }
      });
    } catch (e) {}
  }

  void _controlLoadingMoreValue(value) {
    isLoadingMoreItems = value;
    notifyListeners();
  }

  void _controlRetry() {
    photosList.clear();
    homeResponce = ApiResponceType.loading;
    currentLoadPageNumber = 0;
    notifyListeners();
  }

  List<HomeDataModel> getDataList() {
    final dummyData = List.filled(
      10,
      HomeDataModel(
        altDescription: 'Unknown',
        height: 1000,
        width: 1000,
        urls: Urls(regular: ''),
      ),
    );
    return homeResponce == ApiResponceType.loading ? dummyData : photosList;
  }

  downloadImage({required HomeDataModel photoData}) {
    try {
      PermissionService.checkPermission().then(
        (value) async {
          if (value == true) {
            UtilMethods.getSnackBar(AppText.downloading);
            var response = await ApiService.call(
              method: ApiMethod.get,
              url: photoData.urls!.regular!,
              options: Options(responseType: ResponseType.bytes),
            );
            // save high quality image to gallery
            if (response.type == ApiResponceType.data) {
              final result = await ImageGallerySaver.saveImage(
                  Uint8List.fromList(response.data),
                  quality: 90,
                  name: photoData.id);
              log(result.toString());
              if (result['isSuccess'] == true) {
                UtilMethods.getSnackBar(AppText.downloadingSucess);
              }
            }
          }
        },
      );
    } catch (e) {
      UtilMethods.getSnackBar(AppText.wentWrong);
    }
  }
}
