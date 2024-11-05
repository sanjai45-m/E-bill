import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Title and Logo
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/logos.png', height: 100), // Replace with your logo asset
                    SizedBox(height: 8),
                    Text(
                      'E-Parking Bill App',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
        
              // Description
              Text(
                'The E-Parking Bill App allows users to manage parking tickets efficiently and share them easily. Our goal is to enhance your parking experience.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
        
              // Key Features
              Text(
                'Key Features:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '• Easy ticket generation\n'
                    '• Real-time parking spot availability\n'
                    '• E-bill sharing via WhatsApp\n'
                    '• Vehicle management features\n'
                    '• Secure payment options\n'
                    '• User-friendly interface\n'
                    '• Notifications for parking expiry',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
        
              // How to Use
              Text(
                'How to Use:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '1. Select your vehicle type.\n'
                    '2. Choose an available parking spot.\n'
                    '3. Generate your ticket and save it.\n'
                    '4. Share your e-bill via WhatsApp as needed.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
        
              // Contact Information
              Text(
                'Contact Us:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Email: email.com\n'
                    'Phone: +1234567890',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
        
              // Version Information
              Text(
                'Version: 1.0.0',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
        
              // Credits
              Text(
                'Credits:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Developed by San Tech.\n'
                    // 'Powered by Flutter.\n'
                    'Special thanks to the testers and contributors.',
                style: TextStyle(fontSize: 16), 
              ),
              SizedBox(height: 20),
        
              // Privacy Policy
              GestureDetector(
                onTap: () {

                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
        
              // User Feedback
              Text(
                'User Feedback:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'We would love to hear your thoughts about our app. Please rate us on the app store and send your feedback!',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
