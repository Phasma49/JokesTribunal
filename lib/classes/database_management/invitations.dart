import 'package:cloud_firestore/cloud_firestore.dart';

class Invitation {
  final String? invitationId;

  final String playerId;

  final String gameId;

  final Timestamp invitedAt;
  final String playerPseudo;
  final bool? isInvitationAccepted;
  final Timestamp lastUpdateAt;
  final Timestamp? lastSeenAt;
  Invitation({
    this.invitationId,
    required this.playerId,
    required this.gameId,
    required this.invitedAt,
    required this.playerPseudo,
    required this.isInvitationAccepted,
    required this.lastUpdateAt,
    this.lastSeenAt,
  });

  factory Invitation.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Invitation(
      invitationId: snapshot.id,
      playerId: data?['id_player'],
      gameId: data?['id_game'],
      invitedAt: data?['invited_at'],
      playerPseudo: data?['pseudo_player'],
      isInvitationAccepted: data?['is_invitation_accepted'],
      lastUpdateAt: data?['last_update_at'],
      lastSeenAt: data?['last_seen_at'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id_player": playerId,
      "id_game": gameId,
      "invited_at": invitedAt,
      "pseudo_player": playerPseudo,
      "is_invitation_accepted": isInvitationAccepted,
      "last_update_at": lastUpdateAt,
      "last_seen_at": lastSeenAt,
    };
  }

  @override
  String toString() {
    return 'Invitation{invitationId: $invitationId, '
        'playerId: $playerId, '
        'gameId: $gameId, '
        'invitedAt: $invitedAt, '
        'playerPseudo: $playerPseudo, '
        'isInvitationAccepted: $isInvitationAccepted, '
        'lastUpdateAt: $lastUpdateAt, '
        'lastSeenAt: $lastSeenAt}';
  }
}
