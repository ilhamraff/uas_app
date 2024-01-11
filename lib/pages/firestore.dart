import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference games =
      FirebaseFirestore.instance.collection('games');

  Future<void> addGame(String game) {
    return games.add({'game': game, 'timestamp': Timestamp.now()});
  }

  Stream<QuerySnapshot> getGameStream() {
    final gamesStream =
        games.orderBy('timestamp', descending: true).snapshots();
    return gamesStream;
  }

  Future<void> updateGame(String docID, String newGame) {
    return games.doc(docID).update({
      'game': newGame,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteGame(String docID) {
    return games.doc(docID).delete();
  }
}
