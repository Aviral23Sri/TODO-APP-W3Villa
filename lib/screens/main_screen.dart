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
        MaterialPageRoute(builder: (context) => AuthenticationScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged out successfully!')),
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
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
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
                              icon: Icon(Icons.logout_outlined)),
                        ],
                      )),
                  const Divider(),
                  // Search Box
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
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
                    child: _buildMenuItem(Icons.event_note, 'Tasks', 12),
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
                          _buildMenuItem(Icons.calendar_today, 'Calendar', 0)),
                  InkWell(
                      onTap: () {
                        setState(() {
                          _isStickyWakkClicked = true;
                          _isCalendarClicked = false;
                          _isTaksClicked = false;
                        });
                      },
                      child: _buildMenuItem(
                          Icons.sticky_note_2, 'Sticky Wall', 0)),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Lists',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: _buildMenuItem(Icons.circle, 'Personal', 3,
                        color: Colors.red),
                  ),
                  InkWell(
                      onTap: () {},
                      child: _buildMenuItem(Icons.circle, 'Work', 6,
                          color: Colors.blue)),
                  InkWell(
                    onTap: () {},
                    child: _buildMenuItem(Icons.circle, 'Others', 3,
                        color: Colors.yellow),
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
                color: Colors.white,
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
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Renew driver\'s license',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Description:'),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Add details...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('List:'),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: 'Personal',
                    items: ['Personal', 'Work', 'List 1']
                        .map((list) => DropdownMenuItem(
                              value: list,
                              child: Text(list),
                            ))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  Text('Tags:'),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text('Tag 1')),
                      Chip(label: Text('Tag 2')),
                      Chip(label: Text('+ Add Tag')),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Delete Task'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int count,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(title),
      trailing: count > 0 ? Text(count.toString()) : null,
    );
  }
}
