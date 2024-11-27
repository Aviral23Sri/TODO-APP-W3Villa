enum Category { Personal, Work, Others }

class Task {
  final String id;
  final String title;
  final String description;
  final Category category;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isCompleted,
  });

  // Convert Firestore document to Task
  factory Task.fromMap(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      title: data['title'],
      description: data['description'] ?? '',
      category: Category.values.firstWhere(
        (e) => e.toString() == 'Category.' + data['category'],
        orElse: () => Category.Others,
      ),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  // Convert Task to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category.toString().split('.').last,
      'isCompleted': isCompleted,
    };
  }
}
