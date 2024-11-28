import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/screens/auth_screen.dart';
import 'package:todo_app/screens/calendar_screen.dart';
import 'package:todo_app/screens/sticky_wall_screen.dart';
import 'package:todo_app/screens/tasks_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e')),
      );
    }
  }

  bool _isTaksClicked = true;
  bool _isCalendarClicked = false;
  bool _isStickyWakkClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 1,
      //   backgroundColor: Colors.white,
      //   automaticallyImplyLeading: false,
      //   actions: [
      //     IconButton(
      //         onPressed: () async {
      //           await _logout(context);
      //         },
      //         icon: Icon(Icons.logout_outlined))
      //   ],
      //   title: Center(
      //     child: Text(
      //       'All TODOs',
      //       style: TextStyle(fontWeight: FontWeight.bold),
      //     ),
      //   ),
      // ),
      body: Row(
        children: [
          // Sidebar For Tasks and List
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu Title
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Menu',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                await _logout(context);
                              },
                              icon: const Icon(Icons.logout_outlined)),
                        ],
                      )),
                  const Divider(),
                  // Search Box
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const Divider(),
                  // Menu Items
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isTaksClicked = true;
                        _isCalendarClicked = false;
                        _isStickyWakkClicked = false;
                      });
                    },
                    splashColor: Colors.green, // Ripple color on tap
                    highlightColor: Colors.yellow
                        .withOpacity(0.5), // Highlight color when pressed
                    borderRadius: BorderRadius.circular(10),
                    child: _buildMenuItem(Icons.event_note, 'Tasks',),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          _isCalendarClicked = true;
                          _isTaksClicked = false;
                          _isStickyWakkClicked = false;
                        });
                      },
                      child:
                          _buildMenuItem(Icons.calendar_today, 'Calendar',)),
                  InkWell(
                      onTap: () {
                        setState(() {
                          _isStickyWakkClicked = true;
                          _isCalendarClicked = false;
                          _isTaksClicked = false;
                        });
                      },
                      child: _buildMenuItem(
                          Icons.sticky_note_2, 'Sticky Wall',)),
                  const Divider(),
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Lists',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: _buildMenuItem(Icons.circle, 'Personal', 
                        color: Colors.red),
                  ),
                  InkWell(
                      onTap: () {},
                      child: _buildMenuItem(Icons.circle, 'Work', 
                          color: Colors.blue)),
                  InkWell(
                    onTap: () {},
                    child: _buildMenuItem(Icons.circle, 'Others', 
                        color: Colors.grey),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
          // Task List

          if (_isTaksClicked)
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(),
                child: TasksScreen(),
              ),
            ),
          // Task Details
          if (_isCalendarClicked)
            Expanded(
              flex: 4,
              child: Container(
                child: CalendarScreen(),
              ),
            ),
          if (_isStickyWakkClicked)
            Expanded(
              flex: 4,
              child: Container(
                child: StickyWallScreen(),
              ),
            ),

        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, 
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(title),
    );
  }
}
