import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/firestore_service.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  // Method to show dialog and add new tasks
  void _showAddTaskDialog(BuildContext context) {
    String? title;
    String? description;
    Category? category;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add New Task',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => title = value,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => description = value,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<Category>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: Category.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) => category = value,
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (title != null && title!.isNotEmpty && category != null) {
                            Task newTask = Task(
                              id: '',  // Firestore will generate this when adding
                              title: title!,
                              description: description ?? '',
                              category: category!,
                              isCompleted: false,
                            );
                            _firestoreService.addTask(newTask);
                            Navigator.pop(context); // Close the dialog
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please provide both a title and a category.')),
                            );
                          }
                        },
                        child: Text('Add Task'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Method to delete a task
  void _deleteTask(String taskId) async {
    try {
      await _firestoreService.deleteTask(taskId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: _firestoreService.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No tasks available.', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _showAddTaskDialog(context),
                  icon: Icon(Icons.add),
                  label: Text('Add New Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        final tasks = snapshot.data!..sort((a, b) => a.isCompleted ? 1 : -1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${tasks.length}',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () => _showAddTaskDialog(context),
                icon: Icon(Icons.add),
                label: Text('Add New Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _buildTaskItem(task);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskItem(Task task) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          color: task.isCompleted ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text(task.description ?? ''),
      leading: Icon(
        _getCategoryIcon(task.category),
        color: _getCategoryColor(task.category),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) async {
              setState(() {
                task.isCompleted = value ?? false;
              });
              await _firestoreService.updateTaskStatus(task.id, task.isCompleted); // Update in Firestore
            },
          ),
          SizedBox(width: 12,),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteTask(task.id),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.Personal:
        return Colors.blue;
      case Category.Work:
        return Colors.orange;
      case Category.Others:
      default:
        return Colors.yellow; 
    }
  }

  IconData _getCategoryIcon(Category category) {
    switch (category) {
      case Category.Personal:
        return Icons.person;
      case Category.Work:
        return Icons.work;
      case Category.Others:
      default:
        return Icons.person_add_alt_1_outlined;
    }
  }
}
