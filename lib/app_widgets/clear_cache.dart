import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ClearCache{
  Future<void> clearCache(BuildContext context) async {
    final Directory? cacheDir = await getTemporaryDirectory();
    if (cacheDir != null) {
      try {
        final List<FileSystemEntity> files = cacheDir.listSync();

        for (FileSystemEntity file in files) {
          if (file is File) {
            await file.delete();
          }
        }


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cache cleared successfully!")),
        );
      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to clear cache: $e")),
        );
      }
    }
  }


  void launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'sanjaim202@gmail.com',
      query: 'subject=Support Request&body=Describe your issue here...',
    );


    try {
      final url = emailLaunchUri.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {

        _showErrorDialog(context, 'No email client found.');
      }
    } catch (e) {

      print(e);
      _showErrorDialog(context, 'Could not launch email client.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );

}
}