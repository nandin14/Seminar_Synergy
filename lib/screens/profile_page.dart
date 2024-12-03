//
//
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final _formKey = GlobalKey<FormState>(); // Key for the form
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController enrollmentIdController = TextEditingController();
//
//   File? _image; // To store selected image
//   final ImagePicker _picker = ImagePicker();
//   String? _imageUrl; // Store the profile picture URL
//
//   // Firebase references
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserProfile(); // Load user profile data when the page initializes
//   }
//
//   // Function to load user profile data from Firestore
//   Future<void> _loadUserProfile() async {
//     try {
//       final User? user = _auth.currentUser;
//       if (user == null) {
//         print('No user is signed in.');
//         return;
//       }
//
//       final userDoc = await _firestore.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         final data = userDoc.data();
//         if (data != null) {
//           setState(() {
//             nameController.text = data['name'] ?? '';
//             emailController.text = data['email'] ?? '';
//             enrollmentIdController.text = data['enrollmentId'] ?? '';
//             _imageUrl = data['imageUrl'];
//           });
//         }
//       }
//     } catch (e) {
//       print('Error loading user profile: $e');
//     }
//   }
//
//   // Function to pick an image from the gallery
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _imageUrl = null;
//       });
//     }
//   }
//
//   // Function to upload image to Firebase Storage and return the URL
//   Future<String?> _uploadImage(File image) async {
//     try {
//       final storageRef = _storage.ref().child('profile_pictures/${_auth.currentUser?.uid}.jpg');
//       await storageRef.putFile(image);
//       String imageUrl = await storageRef.getDownloadURL();
//       return imageUrl;
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }
//
//   // Function to save profile data to Firestore
//   Future<void> _saveProfile() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         String? imageUrl = _imageUrl;
//         if (_image != null) {
//           imageUrl = await _uploadImage(_image!);
//         }
//
//         User? user = _auth.currentUser;
//         if (user != null) {
//           Map<String, dynamic> profileData = {
//             'name': nameController.text,
//             'email': emailController.text,
//             'enrollmentId': enrollmentIdController.text,
//             'imageUrl': imageUrl,
//           };
//
//           await _firestore.collection('users').doc(user.uid).set(profileData);
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profile saved successfully!')),
//           );
//
//           setState(() {
//             _imageUrl = imageUrl;
//           });
//         } else {
//           print("No user signed in.");
//         }
//       } catch (e) {
//         print('Error saving profile: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to save profile. Please try again.')),
//         );
//       }
//     } else {
//       print("Form validation failed.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Profile Page',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: const Color(0xFF222222),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               Center(
//                 child: GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 60,
//                     backgroundColor: Colors.grey[300],
//                     backgroundImage: _image != null
//                         ? FileImage(_image!)
//                         : (_imageUrl != null ? NetworkImage(_imageUrl!) : null),
//                     child: _image == null && _imageUrl == null
//                         ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
//                         : null,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildTextInputField(
//                 controller: nameController,
//                 label: 'Full Name',
//                 icon: Icons.person,
//                 validator: (value) => value?.isEmpty ?? true ? 'Please enter your full name' : null,
//               ),
//               const SizedBox(height: 16),
//               _buildTextInputField(
//                 controller: emailController,
//                 label: 'Email',
//                 icon: Icons.email,
//                 validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
//               ),
//               const SizedBox(height: 16),
//               _buildTextInputField(
//                 controller: enrollmentIdController,
//                 label: 'Enrollment ID',
//                 icon: Icons.school,
//                 validator: (value) => value?.isEmpty ?? true ? 'Please enter your enrollment ID' : null,
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState?.validate() ?? false) {
//                     _saveProfile();
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Save Profile',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     int maxLines = 1,
//     required String? Function(String?) validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.deepPurple),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.deepPurple, width: 2),
//         ),
//       ),
//       maxLines: maxLines,
//       validator: validator,
//       style: const TextStyle(fontSize: 16),
//     );
//   }
// }


import 'dart:convert'; // Import for Base64 encoding
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? _base64Image; // Store the Base64 encoded string

  // Firebase references
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load user profile data when the page initializes
  }

  // Function to load user profile data from Firestore
  Future<void> _loadUserProfile() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        print('No user is signed in.');
        return;
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          setState(() {
            nameController.text = data['name'] ?? '';
            emailController.text = data['email'] ?? '';
            enrollmentIdController.text = data['enrollmentId'] ?? '';
            _base64Image = data['base64Image']; // Load Base64 image string
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
        _base64Image = null; // Clear any existing Base64 image
      });
    }
  }

  // Function to convert image to Base64 string
  Future<String?> _convertImageToBase64(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes); // Convert to Base64
      return base64Image;
    } catch (e) {
      print('Error converting image to Base64: $e');
      return null;
    }
  }

  // Function to save profile data to Firestore
  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        String? base64Image = _base64Image;
        if (_image != null) {
          base64Image = await _convertImageToBase64(_image!); // Convert the image to Base64
        }

        User? user = _auth.currentUser;
        if (user != null) {
          Map<String, dynamic> profileData = {
            'name': nameController.text,
            'email': emailController.text,
            'enrollmentId': enrollmentIdController.text,
            'base64Image': base64Image, // Save the Base64 image string
          };

          await _firestore.collection('users').doc(user.uid).set(profileData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved successfully!')),
          );

          setState(() {
            _base64Image = base64Image; // Update the state with the Base64 image string
          });
        } else {
          print("No user signed in.");
        }
      } catch (e) {
        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile. Please try again.')),
        );
      }
    } else {
      print("Form validation failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Page',
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (_base64Image != null ? MemoryImage(base64Decode(_base64Image!)) : null),
                    child: _image == null && _base64Image == null
                        ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextInputField(
                controller: nameController,
                label: 'Full Name',
                icon: Icons.person,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 16),
              _buildTextInputField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 16),
              _buildTextInputField(
                controller: enrollmentIdController,
                label: 'Enrollment ID',
                icon: Icons.school,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your enrollment ID' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveProfile();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Profile',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 16),
    );
  }
}
