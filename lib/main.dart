import 'package:bot_toast/bot_toast.dart';
import 'package:download_wallpapers/app/core/constants/app_colors.dart';
import 'package:download_wallpapers/app/modules/view/home_view.dart';
import 'package:download_wallpapers/app/modules/view_model/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        )
      ],
      child: ScreenUtilInit(
        child: MaterialApp(
          builder: BotToastInit(),
          debugShowCheckedModeBanner: false,
          title: 'Download Wallpaper',
          theme: ThemeData(
            fontFamily: 'Poppins',
            appBarTheme:
                const AppBarTheme(backgroundColor: AppColors.appPrimeryColor),
            colorScheme:
                ColorScheme.fromSeed(seedColor: AppColors.appPrimeryColor),
            useMaterial3: true,
          ),
          home: const HomeView(),
        ),
      ),
    );
  }
}
