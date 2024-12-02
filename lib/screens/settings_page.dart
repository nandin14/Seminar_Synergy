import 'package:flutter/material.dart';
import 'package:initial_app/screens/user_guide_page.dart';  // Import the User Guide Page
import 'package:initial_app/screens/contact_us_page.dart';  // Import the Contact Us Page

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF222222), // Dark background for AppBar
        centerTitle: true,
      ),
      body: Scrollbar(
        thumbVisibility: true,  // Always show the scrollbar thumb
        child: SingleChildScrollView(  // Makes the content scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Navigation buttons for User Guide and Contact Us
                _buildNavigationButton(
                  context,
                  'User Guide',
                  'Learn how to use the app effectively.',
                  const UserGuidePage(), // Navigate to User Guide Page
                ),
                const SizedBox(height: 5),
                _buildNavigationButton(
                  context,
                  'Contact Us',
                  'Reach out for support or questions.',
                  const ContactUsPage(), // Navigate to Contact Us Page
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build navigation buttons
  Widget _buildNavigationButton(
      BuildContext context,
      String title,
      String description,
      Widget destinationPage,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.purple.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
