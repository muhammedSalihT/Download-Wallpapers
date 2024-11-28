import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:download_wallpapers/app/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UtilMethods {
  static Container loadingWidget(
      {double? width, double? height, double? radius, Color? color}) {
    return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: CupertinoActivityIndicator(
          radius: radius?.r ?? 15.r,
          color: color ?? AppColors.appPrimeryColor,
        ));
  }

  static getSnackBar(String? showText) {
    BotToast.showText(
      backButtonBehavior: BackButtonBehavior.none,
      align: const Alignment(0, .75),
      clickClose: false,
      crossPage: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      contentColor: AppColors.appPrimeryColor,
      textStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: AppColors.appWhite),
      borderRadius: BorderRadius.circular(10),
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 2000),
      text: showText.toString(),
    );
  }

  static Widget showNetworkImage({
    required String image,
  }) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.fill,
      placeholder: (context, _) {
        return Center(
          child: UtilMethods.loadingWidget(),
        );
      },
      errorWidget: (context, url, error) => Center(
        child: Icon(
          Icons.image,
          size: 40.sp,
          color: AppColors.appPrimeryColor,
        ),
      ),
    );
  }
}
