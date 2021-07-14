import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class Network {
  static final Network _network = Network._internal();

  factory Network() {
    return _network;
  }

  Network._internal();

  /// Try to load file from locale cache first, if not available get it from the server
  Future<String> get(String url) async {
    AppAuthentication appAuthentication = UserRepository().getCurrentAppAuthentication();

    FileInfo file = await DefaultCacheManager()
        .getFileFromCache(url);
    if (file == null) {
      // Download, if not available
      file = await DefaultCacheManager().
      downloadFile(
          url,
          authHeaders: {
            "authorization": appAuthentication.basicAuth,
          }
      );
      if (file == null) {
        throw Exception("could not download " + url);
      }
    }
    String contents = await file.file.readAsString();
    return contents;
  }
}