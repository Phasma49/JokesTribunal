import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String?
      gameId; // game's database id. Should not be provided when creating a game (automatically generated)

  final Timestamp createdAt;
  final String
      name; // user chosen name of the game. Displayed on the user home page
  final int
      startingScore; // number of points the players will start the game. They will be increased or decreased later
  final String ownerId;

  Game({
    this.gameId,
    required this.createdAt,
    required this.name,
    required this.startingScore,
    required this.ownerId,
  });

  factory Game.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Game(
      gameId: snapshot.id,
      createdAt: data?['created_at'],
      name: data?['name'],
      startingScore: data?['starting_score'],
      ownerId: data?['id_owner'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "created_at": createdAt,
      "name": name,
      "starting_score": startingScore,
      "id_owner": ownerId,
    };
  }

  @override
  String toString() {
    return 'Game{gameId: $gameId, '
        'createdAt: $createdAt, '
        'name: $name, '
        'startingScore: $startingScore, '
        'ownerId: $ownerId}';
  }
}
