import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> board;

  const BoardCard({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    final boardData = board.data();
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/board', arguments: board.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                boardData['name'] ?? 'Sin nombre',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Creado por: ${boardData['createdBy'] ?? 'Desconocido'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
