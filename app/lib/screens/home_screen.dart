import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:teamcanvas/services/auth_service.dart';
import 'package:teamcanvas/services/firestore_service.dart';
import 'package:teamcanvas/widgets/board_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = Provider.of<FirestoreService>(context);
    final userId = auth.getCurrentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Usuario no autenticado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tableros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showCreateBoardDialog(context, firestore, userId),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.getUserBoards(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay tableros creados'));
          }

          final boards = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.2,
              ),
              itemCount: boards.length,
              itemBuilder: (ctx, index) => BoardCard(board: boards[index]),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showCreateBoardDialog(
    BuildContext context,
    FirestoreService firestore,
    String userId,
  ) async {
    final boardNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Tablero'),
        content: TextField(
          controller: boardNameController,
          decoration: const InputDecoration(labelText: 'Nombre del tablero'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (boardNameController.text.trim().isNotEmpty) {
                await firestore.createBoard(
                  boardNameController.text.trim(),
                  userId,
                );
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}
