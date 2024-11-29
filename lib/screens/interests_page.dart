import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:initial_app/screens/seminars_page.dart';

import '../utils/data_loader.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<String> categories = [];
  Map<String, bool> selectedCategories = {}; // Track selected categories
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user; // Logged-in user

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchCategories();
  }

  // Fetch the currently logged-in user
  Future<void> getCurrentUser() async {
    user = _auth.currentUser;
    if (user != null) {
      loadSelectedCategories();
    }
  }

  // Load selected categories from Firestore
  Future<void> loadSelectedCategories() async {
    if (user == null) return; // Ensure user is logged in

    final categoriesSnapshot = await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('categories')
        .get();

    for (var doc in categoriesSnapshot.docs) {
      setState(() {
        selectedCategories[doc.id] = doc['selected'] ?? false;
      });
    }
  }

  // Save selected categories to Firestore in a 'categories' sub-collection
  Future<void> saveSelectedCategories() async {
    if (user == null) return; // Ensure user is logged in

    final categoriesCollection = _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('categories');

    // Start a batch operation
    final batch = _firestore.batch();

    // Delete all existing documents in the 'categories' sub-collection
    final existingCategoriesSnapshot = await categoriesCollection.get();
    for (var doc in existingCategoriesSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Add new selections
    selectedCategories.forEach((category, isSelected) {
      if (isSelected) {
        batch.set(categoriesCollection.doc(category), {'selected': isSelected});
      }
    });

    // Commit the batch operation to apply all changes at once
    await batch.commit();

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Selected categories saved successfully!")),
    );

    // Navigate to Seminars page
    // Load seminar data from the Excel file
    final seminarData = await loadSeminarData('assets/seminar_data_with_categories.xlsx');

    // Filter seminars based on selected categories
    final selectedCategoryList = selectedCategories.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final filteredSeminars = seminarData
        .where((seminar) => selectedCategoryList.contains(seminar['Category']))
        .map((seminar) => seminar['Title'])
        .whereType<String>() // Filters out any null values, ensuring a List<String>
        .toList();


    // Navigate to SeminarsPage with the filtered seminars
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeminarsPage(seminarTitles: filteredSeminars),
      ),
    );
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.2.89:5000/get_categories'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categories = List<String>.from(data);
          // Initialize selection map, keeping previous selections if any
          for (var category in categories) {
            selectedCategories.putIfAbsent(category, () => false);
          }
        });
      } else {
        setState(() {
          categories = ["Error: Server responded with status ${response.statusCode}"];
        });
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Interests"),
      ),
      body: categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Scrollbar(
        thumbVisibility: true, // Ensures scrollbar is always visible
        radius: Radius.circular(8), // Rounds the scrollbar for better visibility
        thickness: 10, // Adjust thickness of the scrollbar for visibility
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 80), // Padding for the bottom button
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: saveSelectedCategories, // Call the function to save selected categories
          child: Text("Show Seminars"),
        ),
      ),
    );
  }
}


