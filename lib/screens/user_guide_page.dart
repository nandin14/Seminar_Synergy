import 'package:flutter/material.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Guide'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Guide',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildGuideSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
