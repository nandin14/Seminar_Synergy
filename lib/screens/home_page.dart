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
              icon: const Icon(Icons.menu, color: Colors.white),
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
                color: Colors.white, // White color for text
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF222222), // Dark background for AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF222222), // Dark background for DrawerHeader
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
              leading: Icon(Icons.person, size: 28,),
              title: Text('Profile', style: GoogleFonts.poppins(fontSize: 22)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, size: 28),
              title: Text('Logout', style: GoogleFonts.poppins(fontSize: 22)),
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
          ],
        ),
      ),
      body: _pages[navigationProvider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.currentIndex,
        onTap: (index) {
          navigationProvider.setCurrentIndex(index);
        },
        backgroundColor: const Color(0xFF222222), // Dark background for BottomNavigationBar
        selectedItemColor: Colors.deepPurpleAccent, // Active icon color
        unselectedItemColor: Colors.white70, // Inactive icon color
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Interests'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
