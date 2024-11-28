import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:initial_app/screens/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:initial_app/providers/auth_provider.dart';
import 'package:initial_app/screens/login_page.dart';

// Import other pages for navigation
import 'package:initial_app/screens/interests_page.dart';
import 'package:initial_app/screens/calendar_page.dart';
import 'package:initial_app/screens/settings_page.dart';

import '../providers/navigation_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _currentIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    InterestsPage(),
    CalendarPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
              child: Image.asset(
                'assets/logo.png', // Ensure the logo image is in your assets folder and registered in pubspec.yaml
                height: 30,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Seminar Synergy',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await authProvider.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to log out. Please try again.')),
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Optional: Add a Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Seminar Synergy',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout', style: GoogleFonts.poppins()),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                try {
                  await authProvider.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to log out. Please try again.')),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Show Contact Us dialog or navigate to a page
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Contact Us', style: GoogleFonts.poppins()),
                      content: Text('Email: support@seminarsynergy.com', style: GoogleFonts.poppins()),
                      actions: [
                        TextButton(
                          child: Text('Close', style: GoogleFonts.poppins()),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: _pages[navigationProvider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.currentIndex,
        onTap: (index) {
          navigationProvider.setCurrentIndex(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Interests'),
          // BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Seminars'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
