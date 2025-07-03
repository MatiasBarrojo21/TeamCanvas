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
  late final String boardId;
  late final FirestoreService firestore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    boardId = ModalRoute.of(context)!.settings.arguments as String;
    firestore = Provider.of<FirestoreService>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tablero'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddTaskDialog,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.getTasks(boardId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay tareas en este tablero'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) {
              final task = snapshot.data!.docs[index];
              return TaskItem(
                task: task,
                onDelete: () => firestore.deleteTask(boardId, task.id),
                onToggle: (value) => firestore.updateTaskStatus(
                  boardId,
                  task.id,
                  value ?? false,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showAddTaskDialog() async {
    final taskNameController = TextEditingController();

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
                await firestore.addTask(
                  boardId,
                  taskNameController.text.trim(),
                );
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
