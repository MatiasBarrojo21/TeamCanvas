import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Operaciones con Tableros
  Future<void> createBoard(String name, String userId) async {
    await _firestore.collection('boards').add({
      'name': name,
      'ownerId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'members': [userId],
      'taskCount': 0,
    });
  }

  Stream<QuerySnapshot> getUserBoards(String userId) {
    return _firestore
        .collection('boards')
        .where('members', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Operaciones con Tareas
  Future<void> addTask(String boardId, String title) async {
    await _firestore.collection('boards/$boardId/tasks').add({
      'title': title,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('boards').doc(boardId).update({
      'taskCount': FieldValue.increment(1),
    });
  }

  Stream<QuerySnapshot> getTasks(String boardId) {
    return _firestore
        .collection('boards/$boardId/tasks')
        .orderBy('createdAt')
        .snapshots();
  }

  Future<void> updateTaskStatus(
    String boardId,
    String taskId,
    bool completed,
  ) async {
    await _firestore.collection('boards/$boardId/tasks').doc(taskId).update({
      'completed': completed,
    });
  }

  Future<void> deleteTask(String boardId, String taskId) async {
    await _firestore.collection('boards/$boardId/tasks').doc(taskId).delete();
    await _firestore.collection('boards').doc(boardId).update({
      'taskCount': FieldValue.increment(-1),
    });
  }
}
