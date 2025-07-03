import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskItem extends StatelessWidget {
  final QueryDocumentSnapshot task;
  final VoidCallback onDelete;
  final Function(bool?) onToggle;

  const TaskItem({
    required this.task,
    required this.onDelete,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: task['completed'],
        onChanged: onToggle,
        title: Text(task['title']),
        secondary: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
