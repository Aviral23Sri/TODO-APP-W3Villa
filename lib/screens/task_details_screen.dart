import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatefulWidget {
  TaskDetailsScreen({super.key,});

  @override
  State<TaskDetailsScreen> createState() {
    return _TaskDetailsScreenState();
  }
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}