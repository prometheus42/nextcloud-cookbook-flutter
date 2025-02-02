import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/services/version_provider.dart';

class ApiVersionWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VersionProvider versionProvider = UserRepository().versionProvider;
    ApiVersion apiVersion = versionProvider.getApiVersion();

    if (!versionProvider.warningWasShown) {
      versionProvider.warningWasShown = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (apiVersion.loadFailureMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                translate(
                  "categories.errors.api_version_check_failed",
                  args: {"error_msg": apiVersion.loadFailureMessage},
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (apiVersion.isVersionAboveConfirmed()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                translate(
                  "categories.errors.api_version_above_confirmed",
                  args: {
                    "version": apiVersion.majorApiVersion.toString() +
                        "." +
                        apiVersion.minorApiVersion.toString()
                  },
                ),
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    }
    return Container();
  }
}
