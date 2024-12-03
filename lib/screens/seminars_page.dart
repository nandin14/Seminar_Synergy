import 'package:flutter/material.dart';

class SeminarsPage extends StatelessWidget {
  final List<Map<String, dynamic>> seminars;

  const SeminarsPage({super.key, required this.seminars});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Filtered Seminars",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF222222),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // This line handles navigating back
          },
        ),
      ),
      body: seminars.isEmpty
          ? const Center(
        child: Text(
          "No seminars match your selected interests.",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
      )
          : Scrollbar(
        thumbVisibility: true,
        radius: const Radius.circular(8),
        thickness: 8,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: seminars.length,
          itemBuilder: (context, index) {
            final seminar = seminars[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4.0,
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
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      Icons.event,
                      color: Colors.white,
                      size: 32,
                    ),
                    title: Text(
                      seminar['Title'] ?? "Seminar",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Presenter: ${seminar['Presenter']}",
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          "Date: ${seminar['Date']}",
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          "Time: ${seminar['Time']}",
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          "Location: ${seminar['Location']}",
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              seminar['Title'] ?? "Seminar Details",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              seminar['Abstract'] ??
                                  "More details about this seminar will be available soon.",
                              style: const TextStyle(fontFamily: 'Poppins'),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
