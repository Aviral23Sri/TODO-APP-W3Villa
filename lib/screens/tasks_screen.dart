import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
