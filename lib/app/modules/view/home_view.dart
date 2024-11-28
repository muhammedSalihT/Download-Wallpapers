import 'package:download_wallpapers/app/core/utils/methods.dart';
import 'package:download_wallpapers/app/core/widgets/custom_text_widget.dart';
import 'package:download_wallpapers/app/core/widgets/responce_widget.dart';
import 'package:download_wallpapers/app/modules/view_model/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    final homePro = Provider.of<HomeProvider>(context, listen: false);
    homePro.getHomePhotosData();
    homePro.setupScrollDownToLoadMoreItems();
    super.initState();
  }

  // dispose the controller when not required
  @override
  void dispose() {
    final homePro = Provider.of<HomeProvider>(context, listen: false);
    homePro.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(builder: (context, homePro, _) {
        return ResponceWidget(
          reCallFunction: () {
            homePro.getHomePhotosData(isRetry: true);
          },
          type: homePro.homeResponce,
          child: SafeArea(
            child: SingleChildScrollView(
              controller: homePro.scrollController,
              child: Column(
                children: [
                  MasonryGridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    itemCount: homePro.getDataList().length,
                    itemBuilder: (context, index) {
                      final photoData = homePro.getDataList()[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () =>
                                homePro.downloadImage(photoData: photoData),
                            child: Card(
                              elevation: 5,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: AspectRatio(
                                aspectRatio:
                                    photoData.width! / photoData.height!,
                                child: UtilMethods.showNetworkImage(
                                    image: photoData.urls?.regular ?? ''),
                              ),
                            ),
                          ),
                          CustomTextWidget(
                              fontSize: 20,
                              text: photoData.altDescription ?? 'Unknown')
                        ],
                      );
                    },
                  ),
                  homePro.isLoadingMoreItems
                      ? Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: UtilMethods.loadingWidget(radius: 15))
                      : const SizedBox()
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
