// // import 'package:flutter/material.dart';
// //
// // class InterestsPage extends StatelessWidget {
// //   const InterestsPage({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Text('Interests Page'),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class InterestsPage extends StatefulWidget {
//   const InterestsPage({super.key});
//
//   @override
//   _InterestsPageState createState() => _InterestsPageState();
// }
//
// class _InterestsPageState extends State<InterestsPage> {
//   List<String> categories = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }
//
//   Future<void> fetchCategories() async {
//     try {
//       final response = await http.get(
//           Uri.parse('http://192.168.2.89:5000/get_categories'),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (kDebugMode) {
//           print("Error fetching categories 2: ");
//         }
//         setState(() {
//           categories = List<String>.from(data);
//         });
//       } else {
//         if (kDebugMode) {
//           print("Server responded with status: ${response.statusCode}");
//         }
//         setState(() {
//           categories = ["Error: Server responded with status ${response.statusCode}"];
//         });
//       }
//
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error fetching categories 1: $e");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: categories.isEmpty
//           ? CircularProgressIndicator()
//           : ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(categories[index]),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<String> categories = [];
  Map<String, bool> selectedCategories = {}; // Track selected categories

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.2.89:5000/get_categories'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print("Fetched categories successfully");
        }
        setState(() {
          categories = List<String>.from(data);
          // Initialize the selection map with false for each category
          selectedCategories = {
            for (var category in categories) category: false
          };
        });
      } else {
        if (kDebugMode) {
          print("Server responded with status: ${response.statusCode}");
        }
        setState(() {
          categories = ["Error: Server responded with status ${response.statusCode}"];
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching categories: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: categories.isEmpty
          ? CircularProgressIndicator()
          : ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          String category = categories[index];
          return CheckboxListTile(
            title: Text(category),
            value: selectedCategories[category],
            onChanged: (bool? value) {
              setState(() {
                selectedCategories[category] = value ?? false;
              });
            },
          );
        },
      ),
    );
  }
}

