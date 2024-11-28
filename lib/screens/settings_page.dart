// import 'package:flutter/material.dart';
//
// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Scrollbar(
//         thumbVisibility: true,  // Always show the scrollbar thumb
//         child: SingleChildScrollView(  // Makes the content scrollable
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'User Guide',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Welcome to the Seminar Synergy App! Here\'s a guide to help you navigate and use the app effectively:',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Interest Page Description
//                 _buildGuideSection(
//                   'Interest Page',
//                   '   - The Interest Page allows you to select seminar categories such as "Machine Learning" or "Software Engineering." These interests help personalize the seminars displayed on the Seminar Page.',
//                 ),
//
//                 // Seminar Page Description
//                 _buildGuideSection(
//                   'Seminar Page',
//                   '   - The Seminar Page displays seminars based on your selected interests. You can view the title, time, location, and a brief abstract of each seminar.',
//                 ),
//
//                 // Calendar Page Description
//                 _buildGuideSection(
//                   'Calendar Page',
//                   '   - The Calendar Page integrates an interactive calendar to view seminar dates. When you select a date, the seminars for that day will be displayed, with details available for each seminar.',
//                 ),
//
//                 // User Profile Page Description
//                 _buildGuideSection(
//                   'User Profile Page',
//                   '   - The User Profile Page allows you to update your personal information and academic interests. This helps the app recommend seminars based on your updated profile.',
//                 ),
//
//                 // Contact Us Page Description
//                 _buildGuideSection(
//                   'Contact Us Page',
//                   '   - The Contact Us Page allows you to reach out to the admin for any support or questions you may have. You can easily get help for any app-related issues.',
//                 ),
//
//                 // Settings Page Description
//                 _buildGuideSection(
//                   'Settings Page',
//                   '   - The Settings Page lets you access the user guide, update app preferences, and configure notification settings.',
//                 ),
//
//                 // Sign Up Page Description
//                 _buildGuideSection(
//                   'Sign Up Page',
//                   '   - The Sign Up Page allows new users to create an account and start personalizing their seminar experience by providing basic details.',
//                 ),
//
//                 // Login Page Description
//                 _buildGuideSection(
//                   'Login Page',
//                   '   - The Login Page is for returning users to log into their account and access their personalized seminar information and preferences.',
//                 ),
//
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Enjoy using the app, and feel free to contact support for any further assistance.',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build each guide section with hover effects
//   Widget _buildGuideSection(String title, String content) {
//     return MouseRegion(
//       onEnter: (_) {
//         // You can add any action here, such as changing the background color
//       },
//       onExit: (_) {
//         // Revert the background color when the mouse leaves the container
//       },
//       child: GestureDetector(
//         child: Card(
//           elevation: 5,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   content,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:initial_app/screens/user_guide_page.dart';  // Import the User Guide Page
import 'package:initial_app/screens/contact_us_page.dart';  // Import the Contact Us Page

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
