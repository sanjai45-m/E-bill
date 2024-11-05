
import 'package:e_bill/app_widgets/drawer.dart';
import 'package:e_bill/view/private%20and%20policy.dart';
import 'package:e_bill/view/terms%20and%20conditions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_bill/app_widgets/clear_cache.dart';
import 'package:e_bill/view/about.dart';
import 'package:e_bill/providers/theme_provider.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? selectedLanguage; // Variable to hold the selected language

  @override
  void initState() {
    super.initState();
    selectedLanguage = 'English'; // Set default language

}
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        title: Text('Settings'),centerTitle: true
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Theme Toggle
          ListTile(
            title: Text("Theme"),
            trailing: Switch(
              value: themeProvider.isDarkTheme,
              onChanged: (value) {
                themeProvider.toggleTheme(); // Toggle the theme
              },
              activeTrackColor: Colors.yellow[700],
              activeColor: Colors.white,
              inactiveTrackColor: Colors.grey[300],
              inactiveThumbColor: Colors.grey,
            ),
          ),
          Divider(),

          // Language Selection
          ListTile(
            title: Text("Language"),
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              items: <String>['English', 'Tamil', 'Hindi'].map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue; // Update the state with the selected language
                });
              },
            ),
          ),
          Divider(),

          // Notifications
          ListTile(
            title: Text("Notifications"),
            trailing: Switch(
              value: true, // Set the default value for notifications
              onChanged: (value) {
                // Handle notification toggle
              },
            ),
          ),
          Divider(),



          // Contact Support
          ListTile(
            title: Text("Contact Support"),
            onTap: () {
              ClearCache().launchEmail(context);
            },
          ),
          Divider(),

          // Privacy Policy
          ListTile(
            title: Text("Privacy Policy"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PrivacyPolicyScreen(),
              ));
            },
          ),
          Divider(),
          ListTile(
            title: Text("Terms and Conditions"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TermsAndConditionsScreen(),
              ));
            },
          ),
          Divider(),
          // About
          ListTile(
            title: Text("About"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AboutScreen(),
              ));
            },
          ),
          Divider(),


          // Clear Cache
          ListTile(
            title: Text("Clear Cache"),
            onTap: () async {
              await ClearCache().clearCache(context);
            },
          ),
          Divider(),

          // App Version
          ListTile(
            title: Text("App Version"),
            subtitle: Text("Version 1.0.0"), // You can fetch the actual version
          ),
        ],
      ),
    );
  }
}
