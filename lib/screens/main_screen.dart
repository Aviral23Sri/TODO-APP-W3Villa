import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/screens/auth_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await _logout(context);
              },
              icon: Icon(Icons.logout_outlined))
        ],
        title: Text(
          'All TODOs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
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
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                  _buildMenuItem(Icons.event_note, 'Tasks', 12),
                  _buildMenuItem(Icons.calendar_today, 'Calendar', 0),
                  _buildMenuItem(Icons.sticky_note_2, 'Sticky Wall', 0),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Lists',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildMenuItem(Icons.circle, 'Personal', 3,
                      color: Colors.red),
                  _buildMenuItem(Icons.circle, 'Work', 6, color: Colors.blue),
                  _buildMenuItem(Icons.circle, 'List 1', 3,
                      color: Colors.yellow),
                  _buildMenuItem(Icons.add, 'Add New List', 0),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tags',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text('Tag 1')),
                      Chip(label: Text('Tag 2')),
                      Chip(label: Text('+ Add Tag')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Task List
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Task Count
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '5',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add New Task Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                      label: Text('Add New Task'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  // Task List
                  Expanded(
                    child: ListView(
                      children: [
                        _buildTaskItem(
                          'Research content ideas',
                          'List 1',
                          false,
                        ),
                        _buildTaskItem(
                          'Create a database of guest authors',
                          'Work',
                          false,
                        ),
                        _buildTaskItem(
                          'Renew driver\'s license',
                          'Personal',
                          true,
                          dueDate: '22-03-22',
                          subtasks: 1,
                          color: Colors.red,
                        ),
                        _buildTaskItem(
                          'Consult accountant',
                          'List',
                          true,
                          subtasks: 3,
                        ),
                        _buildTaskItem('Print business card', '', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Task Details
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

  Widget _buildTaskItem(String title, String list, bool hasDetails,
      {String? dueDate, int subtasks = 0, Color? color}) {
    return ListTile(
      title: Text(title),
      subtitle: hasDetails
          ? Row(
              children: [
                if (dueDate != null) Text(dueDate),
                if (subtasks > 0) Text(' | $subtasks Subtasks'),
                if (list.isNotEmpty)
                  Text(
                    ' | $list',
                    style: TextStyle(color: color ?? Colors.black),
                  ),
              ],
            )
          : null,
      trailing: Checkbox(value: false, onChanged: (bool? value) {}),
    );
  }
}
