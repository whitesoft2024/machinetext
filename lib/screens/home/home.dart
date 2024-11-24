import 'dart:async';

import 'package:flutter/material.dart';
import 'package:text/screens/CertificatePage/certificate.dart';
import 'package:text/screens/SettingsPage/settings.dart';
import 'package:text/screens/profile/profile.dart';

class HomeScreen extends StatefulWidget {
  final String? email;
  
  final String? phoneNumber;
  
  final String? photoUrl;

  const HomeScreen({Key? key, this.email , this.phoneNumber, this.photoUrl}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ProfilePage(),
     CertificatePage(),
    settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else if (hour < 20) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.photoUrl != null
                      ? NetworkImage(widget.photoUrl!) // Display photo if available
                      : AssetImage('assets/profile.jpg') as ImageProvider, // Fallback image
                  radius: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${getGreeting()}!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4), 
            // Row(
            //   children: [
            //     Expanded(
            //       child: Text(
            //         widget.email ?? "Guest", // Display email or "Guest"
            //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Notification action
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'certificate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}





