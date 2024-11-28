import 'dart:io';

import 'package:download_wallpapers/app/core/constants/app_text.dart';
import 'package:download_wallpapers/app/core/utils/methods.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static List<Permission> androidPermissions = <Permission>[Permission.storage];

  static List<Permission> iosPermissions = <Permission>[Permission.storage];

  static Future<bool?> checkPermission() async {
    try {
      PermissionStatus permissionStatus;
      permissionStatus = await Permission.storage.status;
      if (permissionStatus.isDenied) {
        if (Platform.isIOS) {
          await iosPermissions.request();
        }
        await androidPermissions.request();
        permissionStatus = await Permission.storage.status;
        if (permissionStatus.isGranted) {
          return true;
        }
      }
      if (permissionStatus.isGranted) {
        return true;
      }
      if (permissionStatus.isPermanentlyDenied) {
        // Here open app settings for user to manually enable permission in case
        // where permission was permanently denied
        await openAppSettings();
        return false;
      }
    } catch (e) {
      UtilMethods.getSnackBar(AppText.wentWrong);
      return false;
    }
    return null;
  }

  static Future<Map<Permission, PermissionStatus>> request(
      Permission permission) async {
    final List<Permission> permissions = <Permission>[permission];
    return await permissions.request();
  }
}
