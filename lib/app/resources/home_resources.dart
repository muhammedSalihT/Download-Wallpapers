import 'package:download_wallpapers/app/core/constants/app_urls.dart';
import 'package:download_wallpapers/app/core/utils/enums.dart';
import 'package:download_wallpapers/app/services/api_service.dart';

class HomeResources {
  static Future<ApiResponce> getPhotosListApi({required int pageNumber}) async {
    try {
      return await ApiService.call(
          method: ApiMethod.get,
          url: AppUrls.photosUrl,
          queryParameters: {'page': pageNumber});
    } catch (e) {
      return ApiResponce(ApiResponceType.internalException, {'error': e});
    }
  }
}
