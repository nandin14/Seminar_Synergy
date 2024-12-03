import 'package:flutter/material.dart';

class SeminarsPage extends StatelessWidget {
  final List<Map<String, dynamic>> seminars; // Accept seminar details as a list of maps

  const SeminarsPage({super.key, required this.seminars});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtered Seminars"),
        backgroundColor: Colors.deepPurple, // Set a custom color for the AppBar
        elevation: 4.0, // Add some shadow
      ),
      body: seminars.isEmpty
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
          itemCount: seminars.length,
          itemBuilder: (context, index) {
            final seminar = seminars[index];
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
                    seminar['Title'] ?? "Seminar",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600, // Bold text for emphasis
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Presenter: ${seminar['Presenter']}"),
                      Text("Date: ${seminar['Date']}"),
                      Text("Time: ${seminar['Time']}"),
                      Text("Location: ${seminar['Location']}"),
                    ],
                  ),
                  onTap: () {
                    // Handle tapping on the seminar item
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(seminar['Title'] ?? "Seminar Details"),
                          content: Text(
                            seminar['Abstract'] ??
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
