import 'package:download_wallpapers/app/core/constants/app_assets.dart';
import 'package:download_wallpapers/app/core/constants/app_colors.dart';
import 'package:download_wallpapers/app/core/constants/app_text.dart';
import 'package:download_wallpapers/app/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ResponceWidget extends StatefulWidget {
  const ResponceWidget({
    super.key,
    required this.type,
    required this.child,
    required this.reCallFunction,
  });

  final ApiResponceType? type;
  final Widget child;
  final Function() reCallFunction;

  @override
  State<ResponceWidget> createState() => _ResponceWidgetState();
}

class _ResponceWidgetState extends State<ResponceWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == ApiResponceType.serverException ||
        widget.type == ApiResponceType.internalException) {
      return ExceptionWidget(
        widget: widget,
        title: AppText.wentWrong,
      );
    } else if (widget.type == ApiResponceType.internetException) {
      return ExceptionWidget(
        widget: widget,
        title: AppText.noInternet,
      );
    } else {
      return SkeletonWidget(
          enabled: widget.type == ApiResponceType.loading, child: widget.child);
    }
  }
}

class ExceptionWidget extends StatelessWidget {
  const ExceptionWidget({
    super.key,
    required this.widget,
    this.title,
  });

  final ResponceWidget widget;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title ??
              'Somthing went wrong,Check your network connection and try again'),
          Lottie.asset(AppAssets.imagesBaseString + AppAssets.exceptionImage,
              height: 150, width: 150),
          TextButton(
            style: const ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(AppColors.appPrimeryColor)),
            child: const Text(
              'Try again',
              style: TextStyle(color: AppColors.appWhite),
            ),
            onPressed: () => widget.reCallFunction(),
          )
        ],
      ),
    );
  }
}

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget({super.key, required this.child, required this.enabled});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: const ShimmerEffect(baseColor: AppColors.greyLight),
      textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(5)),
      enabled: enabled,
      child: child,
    );
  }
}
