import 'package:cloud_firestore/cloud_firestore.dart';

import 'games.dart';
import 'invitations.dart';
import 'judgments.dart';

// ----------------------------------- Games -----------------------------------
const String GAMES_COLLECTION = "Games";

Future<String> createGame(
    {required Game game,
    required String creatorPseudo}) async {
  String gameIdInDatabase = await FirebaseFirestore.instance
      .collection(GAMES_COLLECTION)
      .add(game.toFirestore())
      .then((value) => value.id);

  createInvitation(
    invitation: Invitation(
      playerId: game.ownerId,
      gameId: gameIdInDatabase,
      playerPseudo: creatorPseudo,
      invitedAt: game.createdAt,
      isInvitationAccepted: true,
      lastUpdateAt: game.createdAt,
    ),
  );
  return gameIdInDatabase;
}

Future<Game> readGame({required String gameId}) async {
  return FirebaseFirestore.instance
      .collection(GAMES_COLLECTION)
      .doc(gameId)
      .get()
      .then((document) => Game.fromFirestore(document, null));
}

void deleteGame({required String gameId}) {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  instance.collection(GAMES_COLLECTION).doc(gameId).delete();

  instance
      .collection(INVITATIONS_COLLECTION)
      .where("id_game", isEqualTo: gameId)
      .get()
      .then((query) => query.docs.forEach((document) {
            document.reference.delete();
          }));

  instance
      .collection(JUDGMENTS_COLLECTION)
      .where("id_game", isEqualTo: gameId)
      .get()
      .then((query) => query.docs.forEach((document) {
            document.reference.delete();
          }));
}

// -------------------------------- Invitations --------------------------------
const String INVITATIONS_COLLECTION = "Invitations";

void createInvitation({required Invitation invitation}) {
  FirebaseFirestore.instance
      .collection(INVITATIONS_COLLECTION)
      .add(invitation.toFirestore());
}

Future<List<Invitation>> readUserNewInvitations(
    {required String userId}) async {
  List<Invitation> list = [];
  await FirebaseFirestore.instance
      .collection(INVITATIONS_COLLECTION)
      .where("id_player", isEqualTo: userId)
      .where("is_invitation_accepted", isNull: true)
      .orderBy("invited_at", descending: true)
      .get()
      .then((query) => query.docs.forEach((document) {
            list.add(Invitation.fromFirestore(document, null));
          }));
  return list;
}

Future<Map<Invitation, Game>> readUserNewInvitationsAndRelatedGames(
    {required String userId}) async {
  Map<Invitation, Game> map = {};

  List<Invitation> invitationList =
      await readUserNewInvitations(userId: userId);

  await Future.wait(invitationList.map((invitation) async {
    Game game = await readGame(gameId: invitation.gameId);
    map.putIfAbsent(invitation, () => game);
  }));

  return map;
}

void acceptInvitation({required String invitationId}) {
  FirebaseFirestore.instance
      .collection(INVITATIONS_COLLECTION)
      .doc(invitationId)
      .update({"is_invitation_accepted": true});
}

void refuseInvitation({required String invitationId}) {
  FirebaseFirestore.instance
      .collection(INVITATIONS_COLLECTION)
      .doc(invitationId)
      .update({"is_invitation_accepted": false});
}

Future<List<Invitation>> _readUserAcceptedInvitationList(
    {required String userId}) async {
  List<Invitation> list = [];

  QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
      .collection(INVITATIONS_COLLECTION)
      .where("id_player", isEqualTo: userId)
      .where("is_invitation_accepted", isEqualTo: true)
      .orderBy("last_update_at", descending: true)
      .get();

  list = query.docs
      .map((document) => Invitation.fromFirestore(document, null))
      .toList();

  return list;
}

Future<Map<Invitation, Game>> readUserAcceptedInvitationsAndRelatedGames(
    {required String userId}) async {
  Map<Invitation, Game> map = {};

  List<Invitation> invitationList =
      await _readUserAcceptedInvitationList(userId: userId);

  await Future.wait(invitationList.map((invitation) async {
    Game game = await readGame(gameId: invitation.gameId);
    map.putIfAbsent(invitation, () => game);
  }));

  return map;
}

Future<List<Invitation>> readGameAcceptedInvitationList(
    {required String gameId}) async {
  List<Invitation> list = [];

  QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
      .collection(INVITATIONS_COLLECTION)
      .where("id_game", isEqualTo: gameId)
      .where("is_invitation_accepted", isEqualTo: true)
      .get();

  list = query.docs
      .map((document) => Invitation.fromFirestore(document, null))
      .toList();

  return list;
}

void updateInvitationLastSeen({required String invitationId}) {
  FirebaseFirestore.instance
      .collection(INVITATIONS_COLLECTION)
      .doc(invitationId)
      .update({"last_seen_at": Timestamp.now()});
}

Future<List<Invitation>> readAllGameInvitations(
    {required String gameId}) async {
  List<Invitation> list = [];

  await FirebaseFirestore.instance
      .collection(INVITATIONS_COLLECTION)
      .where("id_game", isEqualTo: gameId)
      .get()
      .then((query) => query.docs.forEach((document) {
            list.add(Invitation.fromFirestore(document, null));
          }));

  return list;
}

void deleteUserFromGame(
    {required String userId,
    required String gameId,
    required String invitationId}) {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  instance.collection(INVITATIONS_COLLECTION).doc(invitationId).delete();

  instance
      .collection(JUDGMENTS_COLLECTION)
      .where("id_game", isEqualTo: gameId)
      .where("id_player", isEqualTo: userId)
      .get()
      .then((query) => query.docs.forEach((document) {
            document.reference.delete();
          }));
}

// --------------------------------- Judgments ---------------------------------
const String JUDGMENTS_COLLECTION = "Judgments";

void createJudgment({required Judgment judgment}) {
  FirebaseFirestore.instance
      .collection(JUDGMENTS_COLLECTION)
      .add(judgment.toFirestore())
      .then((judgmentDoc) {
    readGameAcceptedInvitationList(gameId: judgment.gameId)
        .then((invitationList) => Future.forEach(invitationList, (invitation) {
              FirebaseFirestore.instance
                  .collection(INVITATIONS_COLLECTION)
                  .doc(invitation.invitationId)
                  .update({"last_update_at": judgment.judgedAt});
            }));
  });
}

Future<Judgment?> readLastJudgmentInGameForPlayer(
    {required String gameId, required String playerId}) async {
  return await FirebaseFirestore.instance
      .collection(JUDGMENTS_COLLECTION)
      .where("id_game", isEqualTo: gameId)
      .where("id_player", isEqualTo: playerId)
      .orderBy("judged_at", descending: true)
      .limit(1)
      .get()
      .then((document) {
    if (document.docs.firstOrNull != null) {
      return Judgment.fromFirestore(document.docs.first, null);
    } else {
      return null;
    }
  });
}

Future<Map<Invitation, Judgment?>> readInvitationsAndRelatedLastJudgmentInGame(
    {required String gameId}) async {
  Map<Invitation, Judgment?> map = {};

  List<Invitation> invitationList =
      await readGameAcceptedInvitationList(gameId: gameId);

  await Future.wait(invitationList.map((invitation) async {
    Judgment? judgment = await readLastJudgmentInGameForPlayer(
        gameId: gameId, playerId: invitation.playerId);
    map.putIfAbsent(invitation, () => judgment);
  }));

  return map;
}
