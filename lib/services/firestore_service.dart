import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get tasksCollection => _db.collection('tasks');

  // Fetch all tasks in real-time
  Stream<List<Task>> getTasks() {
    return tasksCollection.snapshots().handleError((error) {
      print('Error fetching tasks: $error');
    }).map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Add new task to Firestore
  Future<void> addTask(Task task) async {
    try {
      await tasksCollection.add(task.toMap());
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  // Update task completion status
  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    try {
      await tasksCollection.doc(taskId).update({
        'isCompleted': isCompleted,
      });
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await tasksCollection.doc(taskId).delete();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
