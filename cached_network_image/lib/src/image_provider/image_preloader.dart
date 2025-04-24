import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImagePreloader {
  static final DefaultCacheManager _cacheManager = DefaultCacheManager();

  /// Preloads a list of images into the cache
  /// Returns a list of results indicating success/failure for each URL
  static Future<List<bool>> preloadImages(
    List<String> urls, {
    String? cacheKey,
    Map<String, String>? authHeaders,
  }) async {
    List<bool> results = [];

    for (String url in urls) {
      try {
        // Download and store in cache
        await _cacheManager.downloadFile(
          url,
          key: cacheKey,
          authHeaders: authHeaders,
        );

        // If file is successfully downloaded and cached
        results.add(true);
        debugPrint('Successfully cached: $url');
      } catch (e) {
        results.add(false);
        debugPrint('Error caching $url: $e');
      }
    }

    return results;
  }

  static Future<String> cacheImage(String url) async{
    FileInfo? alreadyCached = await isImageAvailable(url);
    if(alreadyCached != null){
      return alreadyCached.file.path;
    }
   FileInfo fileInfo = await _cacheManager.downloadFile(
      url
    );
   return fileInfo.file.path;
  }

  static Future<FileInfo?> isImageAvailable(String url) async{
    final fileInfo = await _cacheManager.getFileFromCache(url);
    return fileInfo;
  }

  /// Checks if an image is already cached
  static Future<bool> isImageCached(String url) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);
    return fileInfo != null;
  }
}
