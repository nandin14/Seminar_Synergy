import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController enrollmentIdController = TextEditingController();

  File? _image; // To store selected image
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl; // Store the profile picture URL

  // Firebase references
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load user profile data when the page initializes
  }

  // Function to load user profile data from Firestore
  Future<void> _loadUserProfile() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          setState(() {
            nameController.text = data['name'] ?? '';
            emailController.text = data['email'] ?? '';
            enrollmentIdController.text = data['enrollmentId'] ?? '';
            _imageUrl = data['imageUrl'];

            // If image URL is available, download it to display locally
            if (_imageUrl != null) {
              // This can be enhanced to fetch the image from the URL if needed.
            }
          });
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageUrl = null; // Reset the image URL since a new image is selected
      });
    }
  }

  // Function to upload image to Firebase Storage and return the URL
  Future<String?> _uploadImage(File image) async {
    try {
      // Create a reference to the location where the image will be stored
      final storageRef = _storage.ref().child('profile_pictures/${_auth.currentUser?.uid}.jpg');
      // Upload the file
      await storageRef.putFile(image);
      // Get the image URL
      String imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to save profile data to Firestore
  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Upload the image if selected
        String? imageUrl = _imageUrl;
        if (_image != null) {
          imageUrl = await _uploadImage(_image!);
        }

        // Get current user
        User? user = _auth.currentUser;
        if (user != null) {
          // Prepare the user profile data
          Map<String, dynamic> profileData = {
            'name': nameController.text,
            'email': emailController.text,
            'enrollmentId': enrollmentIdController.text,
            'imageUrl': imageUrl,
          };

          // Save to Firestore
          await _firestore.collection('users').doc(user.uid).set(profileData);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved successfully!')),
          );

          // Update the local state with the saved image URL
          setState(() {
            _imageUrl = imageUrl;
          });
        }
      } catch (e) {
        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Section
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _image != null
                          ? FileImage(_image!) // Display selected image
                          : (_imageUrl != null ? NetworkImage(_imageUrl!) : null) as ImageProvider?,
                      child: _image == null && _imageUrl == null
                          ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Name Field
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Email Field
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Enrollment ID Field
                TextFormField(
                  controller: enrollmentIdController,
                  decoration: const InputDecoration(
                    labelText: 'Enrollment ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your enrollment ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
