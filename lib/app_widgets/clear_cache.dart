import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ClearCache{
  Future<void> clearCache(BuildContext context) async {
    final Directory? cacheDir = await getTemporaryDirectory();
    if (cacheDir != null) {
      try {
        // Get all files in the cache directory
        final List<FileSystemEntity> files = cacheDir.listSync();

        // Delete each file
        for (FileSystemEntity file in files) {
          if (file is File) {
            await file.delete();
          }
        }

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cache cleared successfully!")),
        );
      } catch (e) {
        // Handle any errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to clear cache: $e")),
        );
      }
    }
  }


  void launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'sanjaim202@gmail.com', // Change to your support email
      query: 'subject=Support Request&body=Describe your issue here...',
    );

    // Attempt to launch the email client
    try {
      final url = emailLaunchUri.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        // Handle the case where the email client is not installed
        _showErrorDialog(context, 'No email client found.');
      }
    } catch (e) {
      // Handle error (e.g., show a Snackbar or a dialog)
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