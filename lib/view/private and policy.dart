import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy for E-Parking Bill App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Last Updated: 01-11-2024',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '1. Introduction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our E-Parking Bill App. Please read this policy carefully. If you do not agree with the terms of this privacy policy, please do not access the application.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Information We Collect',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'We may collect the following types of information:\n'
                  '- Personal Information: Information that identifies you, such as your name, email address, phone number, and payment information.\n'
                  '- Usage Data: Information about how you use the App, including your interactions with the App’s features and content.',
            ),
            SizedBox(height: 16),
            Text(
              '3. How We Use Your Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'We may use the information we collect from you in the following ways:\n'
                  '- To provide, operate, and maintain our App.\n'
                  '- To improve, personalize, and expand our App.\n'
                  '- To process your transactions and send you related information, including purchase confirmations and invoices.\n'
                  '- To communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the App, and for marketing and promotional purposes.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Disclosure of Your Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'We may share your information in the following situations:\n'
                  '- By Law or to Protect Rights: If we believe the release of information about you is necessary to respond to legal process, to investigate or remedy potential violations of our policies, or to protect the rights, property, and safety of others, we may share your information as permitted or required by any applicable law, rule, or regulation.\n'
                  '- Third-Party Service Providers: We may share your information with third parties who perform services for us or on our behalf, including payment processing, data analysis, email delivery, hosting services, customer service, and marketing assistance.',
            ),
            SizedBox(height: 16),
            Text(
              '5. Security of Your Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'We use administrative, technical, and physical security measures to help protect your personal information. While we have taken reasonable steps to secure the personal information you provide to us, please be aware that no method of transmission over the internet or method of electronic storage is 100% secure, and we cannot guarantee its absolute security.',
            ),
            SizedBox(height: 16),
            Text(
              '6. Your Rights',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Depending on your location, you may have the following rights regarding your personal information:\n'
                  '- The right to access – You have the right to request copies of your personal information.\n'
                  '- The right to rectification – You have the right to request that we correct any information you believe is inaccurate or incomplete.\n'
                  '- The right to erasure – You have the right to request that we erase your personal information under certain conditions.',
            ),
            SizedBox(height: 16),
            Text(
              '7. Changes to This Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
            ),
            SizedBox(height: 16),
            Text(
              '8. Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'If you have any questions about this Privacy Policy, please contact us:\n'
                  '- Email:eparkingbill@gmail.com\n'
                  '- Phone: 9361557446',
            ),
            SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {

                Navigator.pop(context);
              },
              child: Text('Accept'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF004EA3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
