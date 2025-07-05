import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskItem extends StatelessWidget {
  final DocumentSnapshot task;
  final VoidCallback onDelete;
  final Function(bool?) onToggle;
  @override
  final Key? key;

  const TaskItem({
    required this.task,
    required this.onDelete,
    required this.onToggle,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) => onDelete(),
        child: CheckboxListTile(
          value: task['completed'] ?? false,
          onChanged: onToggle,
          title: Text(
            task['title'] ?? '',
            style: TextStyle(
              decoration: (task['completed'] ?? false)
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          secondary: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: task['title'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Tarea'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                task.reference.update({'title': controller.text.trim()});
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
