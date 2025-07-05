import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserBoards(String userId) {
    return _firestore
        .collection('boards')
        .where('members', arrayContains: userId)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        )
        .snapshots();
  }

  // Resto de tus métodos...
  Stream<QuerySnapshot<Map<String, dynamic>>> getTasks(String boardId) {
    return _firestore
        .collection('boards')
        .doc(boardId)
        .collection('tasks')
        .orderBy('order')
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        )
        .snapshots();
  }

  Future<void> addTask(String boardId, String title, {int order = 0}) async {
    await _firestore.collection('boards').doc(boardId).collection('tasks').add({
      'title': title,
      'completed': false,
      'order': order,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createBoard(String name, String userId) async {
    await _firestore.collection('boards').add({
      'name': name,
      'createdBy': userId,
      'members': [userId],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTaskStatus(
    String boardId,
    String taskId,
    bool completed,
  ) async {
    await _firestore
        .collection('boards')
        .doc(boardId)
        .collection('tasks')
        .doc(taskId)
        .update({'completed': completed});
  }

  Future<void> deleteTask(String boardId, String taskId) async {
    await _firestore
        .collection('boards')
        .doc(boardId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}
