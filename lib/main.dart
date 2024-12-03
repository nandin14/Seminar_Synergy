import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:initial_app/providers/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:initial_app/providers/auth_provider.dart';
import 'package:initial_app/screens/login_page.dart';
import 'package:initial_app/screens/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Call the Firestore connection test after initialization
  await testFirestoreConnection();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider())
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> testFirestoreConnection() async {
  if (kDebugMode) {
    print("Starting Firestore connection test...");
  }
  try {
    await FirebaseFirestore.instance.collection('test').doc('connection').set({
      'connected': true,
      'timestamp': FieldValue.serverTimestamp(),
    });
    if (kDebugMode) {
      print("Connection to Firestore successful!");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error connecting to Firestore: $e");
    }
  }
  if (kDebugMode) {
    print("Firestore connection test complete.");
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seminar App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: StreamBuilder(
        stream: context.read<AuthProvider>().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            return user != null ? const HomePage() : const LoginPage();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}