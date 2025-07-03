import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear nuevo tablero
  Future<void> createBoard(String name, String userId) async {
    await _firestore.collection('boards').add({
      'name': name,
      'ownerId': userId,
      'createdAt': Timestamp.now(),
      'members': [userId],
    });
  }

  // Obtener todos los tableros de un usuario
  Stream<QuerySnapshot> getUserBoards(String userId) {
    return _firestore
        .collection('boards')
        .where('members', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Actualizar nombre de tablero
  Future<void> updateBoardName(String boardId, String newName) async {
    await _firestore.collection('boards').doc(boardId).update({
      'name': newName,
    });
  }
}
