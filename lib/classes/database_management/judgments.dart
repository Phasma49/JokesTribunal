import 'package:cloud_firestore/cloud_firestore.dart';

class Judgment {
  final String? judgmentId;

  final String playerId;

  final String gameId;

  final Timestamp judgedAt;

  final int scoreModification;

  final String jokeDescription;
  final int newScore;
  final String judgedBy;

  Judgment({
    this.judgmentId,
    required this.judgedAt,
    required this.scoreModification,
    required this.jokeDescription,
    required this.newScore,
    required this.judgedBy,
    required this.playerId,
    required this.gameId,
  });

  factory Judgment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Judgment(
      judgmentId: snapshot.id,
      playerId: data?['id_player'],
      gameId: data?['id_game'],
      judgedAt: data?['judged_at'],
      scoreModification: data?['score_modification'],
      jokeDescription: data?['joke_description'],
      newScore: data?['new_score'],
      judgedBy: data?['judged_by'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id_player": playerId,
      "id_game": gameId,
      "judged_at": judgedAt,
      "score_modification": scoreModification,
      "joke_description": jokeDescription,
      "new_score": newScore,
      "judged_by": judgedBy,
    };
  }

  @override
  String toString() {
    return 'Judgment{judgmentId: $judgmentId, '
        'playerId: $playerId, '
        'gameId: $gameId, '
        'judgedAt: $judgedAt, '
        'scoreModification: $scoreModification, '
        'jokeDescription: $jokeDescription, '
        'newScore: $newScore, '
        'judgedBy: $judgedBy}';
  }
}
