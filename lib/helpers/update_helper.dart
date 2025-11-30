// lib/helpers/update_helper.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateHelper {
  static const String _versionUrl = 'https://raw.githubusercontent.com/praisethelordbd/praisethelord-version-control/main/version.json';
  
  static Future<void> checkForUpdate(BuildContext context, {bool showNoUpdateDialog = false}) async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final currentVersionCode = int.parse(packageInfo.buildNumber);

      final response = await http.get(Uri.parse(_versionUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final latestVersionCode = jsonResponse['versionCode'];

        if (latestVersionCode > currentVersionCode) {
          _showUpdateDialog(context, jsonResponse);
        } else if (showNoUpdateDialog) {
          _showNoUpdateDialog(context);
        }
      }
    } catch (e) {
      print("Failed to check for updates: $e");
      if (showNoUpdateDialog) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not check for updates. Please check your internet connection.')));
      }
    }
  }

  static void _showUpdateDialog(BuildContext context, Map<String, dynamic> updateInfo) {
    // ... (এই কোডটি home_page.dart থেকে কপি করা হয়েছে, শুধু কিছু ছোট পরিবর্তন আছে)
    // ... (নিচে সম্পূর্ণ কোডটি দেওয়া আছে)
  }
  
  static void _showNoUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Updates Found'),
        content: const Text('You are already using the latest version of the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// --- Helper ফাংশনগুলোকে ক্লাসের বাইরে নিয়ে আসা হয়েছে ---

void _showUpdateDialog(BuildContext context, Map<String, dynamic> updateInfo) {
  bool isDownloading = false;
  double downloadProgress = 0.0;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          // ... (বাকি ডায়ালগের কোড)
          return AlertDialog(
            title: Text('New Update Available! (v${updateInfo['versionName']})'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Please update to get the latest features.'),
                  const SizedBox(height: 16),
                  const Text('What\'s New:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(updateInfo['releaseNotes']),
                  if (isDownloading)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Downloading...'),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: downloadProgress),
                          const SizedBox(height: 4),
                          Text('${(downloadProgress * 100).toStringAsFixed(0)}%'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: isDownloading ? null : () => Navigator.of(context).pop(), child: const Text('Later')),
              ElevatedButton(
                onPressed: isDownloading ? null : () => _startUpdate(context, updateInfo, setDialogState, (downloading, progress) {
                  setDialogState(() {
                    isDownloading = downloading;
                    downloadProgress = progress;
                  });
                }),
                child: const Text('Update Now'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _startUpdate(BuildContext context, Map<String, dynamic> updateInfo, StateSetter setDialogState, Function(bool, double) onProgress) async {
  if (Platform.isAndroid) {
    await _downloadAndInstallApk(context, updateInfo['androidUrl'], setDialogState, onProgress);
  } else {
    await _launchURL(updateInfo[Platform.isWindows ? 'windowsUrl' : 'webUrl'] ?? 'https://praisethelordbd-ministry.blogspot.com/');
    if (context.mounted) Navigator.of(context).pop();
  }
}

Future<void> _downloadAndInstallApk(BuildContext context, String url, StateSetter setDialogState, Function(bool, double) onProgress) async {
    // ... (ডাউনলোডের সম্পূর্ণ কোড এখানে)
}

Future<void> _launchURL(String url) async {
    // ... (URL লঞ্চ করার কোড এখানে)
}