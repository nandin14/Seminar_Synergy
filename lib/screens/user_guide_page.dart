import 'package:flutter/material.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Guide',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF222222), // Dark background for AppBar
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back button color
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true,  // Always show the scrollbar thumb
        child: SingleChildScrollView(  // Makes the content scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Guide',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to the Seminar Synergy App! Here\'s a guide to help you navigate and use the app effectively:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Add the guide content here
                _buildGuideSection(
                  'Interest Page',
                  '   - The Interest Page allows you to select seminar categories such as "Machine Learning" or "Software Engineering." These interests help personalize the seminars displayed on the Seminar Page.',
                ),
                _buildGuideSection(
                  'Seminar Page',
                  '   - The Seminar Page displays seminars based on your selected interests. You can view the title, time, location, and a brief abstract of each seminar.',
                ),
                _buildGuideSection(
                  'Calendar Page',
                  '   - The Calendar Page integrates an interactive calendar to view seminar dates. When you select a date, the seminars for that day will be displayed, with details available for each seminar.',
                ),
                // Add more sections as needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each guide section
  Widget _buildGuideSection(String title, String content) {
    return Container(
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
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
