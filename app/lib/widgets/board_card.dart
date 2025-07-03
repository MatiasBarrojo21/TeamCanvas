import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardCard extends StatelessWidget {
  final QueryDocumentSnapshot board;

  const BoardCard({required this.board, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            Navigator.pushNamed(context, '/board', arguments: board.id),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                board['name'],
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.task, size: 16),
                  const SizedBox(width: 4),
                  Text('${board['taskCount'] ?? 0} tareas'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
