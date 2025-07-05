import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:teamcanvas/services/firestore_service.dart';
import 'package:teamcanvas/widgets/task_item.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late String boardId;
  late FirestoreService firestoreService;
  late List<DocumentSnapshot> tasks = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    boardId = ModalRoute.of(context)!.settings.arguments as String;
    firestoreService = Provider.of<FirestoreService>(context);
  }

  Future<void> _reorderTasks(int oldIndex, int newIndex) async {
    if (oldIndex != newIndex) {
      final reorderedTasks = List<DocumentSnapshot>.from(tasks);
      final task = reorderedTasks.removeAt(oldIndex);
      reorderedTasks.insert(newIndex, task);

      setState(() => tasks = reorderedTasks);

      final batch = FirebaseFirestore.instance.batch();
      for (int i = 0; i < reorderedTasks.length; i++) {
        batch.update(reorderedTasks[i].reference, {'order': i});
      }
      await batch.commit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tablero'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTaskDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTasks(boardId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay tareas en este tablero'));
          }

          tasks = snapshot.data!.docs;

          return ReorderableListView(
            onReorder: _reorderTasks,
            padding: const EdgeInsets.all(8),
            children: tasks.map((task) {
              final taskId = task.id;
              return TaskItem(
                key: Key(taskId),
                task: task,
                onDelete: () => firestoreService.deleteTask(boardId, taskId),
                onToggle: (value) => firestoreService.updateTaskStatus(
                  boardId,
                  taskId,
                  value ?? false,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    final taskNameController = TextEditingController();
    final currentContext = this.context;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: TextField(
          controller: taskNameController,
          decoration: const InputDecoration(labelText: 'Descripción'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (taskNameController.text.trim().isNotEmpty) {
                await firestoreService.addTask(
                  boardId,
                  taskNameController.text.trim(),
                  order: tasks.length,
                );
                if (mounted) Navigator.pop(currentContext);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
