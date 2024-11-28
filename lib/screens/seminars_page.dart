import 'package:flutter/material.dart';

class SeminarsPage extends StatelessWidget {
  final List<String> seminarTitles; // Accept seminar titles

  const SeminarsPage({super.key, required this.seminarTitles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtered Seminars"),
        backgroundColor: Colors.deepPurple, // Set a custom color for the AppBar
        elevation: 4.0, // Add some shadow
      ),
      body: seminarTitles.isEmpty
          ? const Center(
        child: Text(
          "No seminars match your selected interests.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : Scrollbar(
        thumbVisibility: true, // Ensure scrollbar is always visible
        radius: const Radius.circular(8), // Rounded scrollbar
        thickness: 10, // Adjust scrollbar thickness
        child: ListView.builder(
          padding: const EdgeInsets.all(16), // Add padding to the list
          itemCount: seminarTitles.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
              child: Card(
                elevation: 4.0, // Add shadow for better separation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.event, // Add an icon representing a seminar
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    seminarTitles[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600, // Bold text for emphasis
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {
                      // Add functionality for bookmarking later
                    },
                    color: Colors.deepPurple,
                  ),
                  onTap: () {
                    // Handle tapping on the seminar item
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(seminarTitles[index]),
                          content: const Text(
                            "More details about this seminar will be available soon.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
