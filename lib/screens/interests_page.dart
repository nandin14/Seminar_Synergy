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
  Map<String, bool> selectedCategories = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchCategories();
  }

  Future<void> getCurrentUser() async {
    user = _auth.currentUser;
    if (user != null) {
      loadSelectedCategories();
    }
  }

  Future<void> loadSelectedCategories() async {
    if (user == null) return;
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

  Future<void> saveSelectedCategories() async {
    if (user == null) return;
    final categoriesCollection = _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('categories');

    final batch = _firestore.batch();
    final existingCategoriesSnapshot = await categoriesCollection.get();
    for (var doc in existingCategoriesSnapshot.docs) {
      batch.delete(doc.reference);
    }

    selectedCategories.forEach((category, isSelected) {
      if (isSelected) {
        batch.set(categoriesCollection.doc(category), {'selected': isSelected});
      }
    });

    await batch.commit();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Selected categories saved successfully!"),
        backgroundColor: Colors.black87,
      ),
    );

    final seminarData =
    await loadSeminarData('assets/seminar_data_with_categories.xlsx');
    final selectedCategoryList = selectedCategories.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final filteredSeminars = seminarData
        .where((seminar) => selectedCategoryList.contains(seminar['Category']))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeminarsPage(seminars: filteredSeminars),
      ),
    );
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.2.19:5000/get_categories'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categories = List<String>.from(data);
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Choose Your Interests',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w900,  // Make the font bolder
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF222222), // Dark black background for AppBar
        centerTitle: true,
      ),
      body: categories.isEmpty
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurple,
          strokeWidth: 6,
        ),
      )
          : Scrollbar(
        thumbVisibility: true,
        thickness: 10,
        radius: Radius.circular(12),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            String category = categories[index];
            bool isSelected = selectedCategories[category] ?? false;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [Colors.deepPurple, Colors.blueAccent],
                )
                    : LinearGradient(
                  colors: [Colors.white, Colors.grey[300]!],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Switch(
                  value: isSelected,
                  onChanged: (bool value) {
                    setState(() {
                      selectedCategories[category] = value;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3A3A3C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.symmetric(vertical: 14),
            textStyle: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
          ),
          onPressed: saveSelectedCategories,
          child: Text(
            "Show Seminars",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
