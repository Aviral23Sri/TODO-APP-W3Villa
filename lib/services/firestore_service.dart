import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get tasksCollection => _db.collection('tasks');

  Stream<List<Task>> getTasks() {
    return tasksCollection.snapshots().handleError((error) {}).map((snapshot) {
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
      SnackBar(content: Text(e.toString()));
    }
  }

  // Update task completion status
  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    try {
      await tasksCollection.doc(taskId).update({
        'isCompleted': isCompleted,
      });
    } catch (e) {
      SnackBar(content: Text(e.toString()));
    }
  }

  // Method to update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await _db.collection('tasks').doc(task.id).update(task.toMap());
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await tasksCollection.doc(taskId).delete();
    } catch (e) {
      SnackBar(content: Text(e.toString()));
    }
  }
}
