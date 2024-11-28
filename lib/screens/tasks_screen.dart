import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/firestore_service.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final FirestoreService _firestoreService = FirestoreService();

 
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
            width:
                MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Add New Task',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => title = value,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => description = value,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Category>(
                    decoration: const InputDecoration(
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
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (title != null &&
                              title!.isNotEmpty &&
                              category != null) {
                            Task newTask = Task(
                              id: '', 
                              title: title!,
                              description: description ?? '',
                              category: category!,
                              isCompleted: false,
                            );
                            _firestoreService.addTask(newTask);
                            Navigator.pop(context); 
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please provide both a title and a category.')),

                            );
                          }
                        },
                        child: const Text('Add Task'),
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
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
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
                const Text('No tasks available.', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _showAddTaskDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Task'),
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
                icon: const Icon(Icons.add),
                label: const Text('Add New Task'),
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

  Widget modifyTask(String taskId, String initialTitle, String initialDescription) {
    
    TextEditingController titleController =
        TextEditingController(text: initialTitle);
    TextEditingController descriptionController =
        TextEditingController(text: initialDescription);

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Description:'),
              const SizedBox(height: 8),
             
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Add details...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('List:'),
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
                onPressed: () {
                  _deleteTask(taskId);
                  Navigator.pop(context); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete Task'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                 
                  String updatedTitle = titleController.text;
                  String updatedDescription = descriptionController.text;

                 
                  FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(taskId)
                      .update({
                    'title': updatedTitle,
                    'description': updatedDescription,
                  });

                  Navigator.pop(context); 
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskItem(Task task) {
    return ListTile(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return modifyTask(task.id, task.title, task.description ??"");
          },
        );
      },
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
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
              await _firestoreService.updateTaskStatus(
                  task.id, task.isCompleted); 
            },
          ),
          const SizedBox(
            width: 12,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
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
