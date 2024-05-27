import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'game/create_game_screen.dart';
import 'game/game_screen.dart';

import '../../classes/network_checker.dart';
import '../../classes/database_management/games.dart';
import '../../classes/database_management/invitations.dart';
import '../../classes/database_management/crud_operations.dart'
    as my_crud_operations;

class UserNewInvitationListScreen extends StatefulWidget {
  const UserNewInvitationListScreen({Key? key}) : super(key: key);

  @override
  State<UserNewInvitationListScreen> createState() =>
      _UserNewInvitationListScreenState();
}

class _UserNewInvitationListScreenState
    extends State<UserNewInvitationListScreen> {
  Map<Invitation, Game>? newInvitationsAndRelatedGames;

  @override
  void initState() {
    super.initState();
    _fetchNewInvitations();
  }

  void _fetchNewInvitations() async {
    await checkNetworkAvailability(context);

    newInvitationsAndRelatedGames =
        await my_crud_operations.readUserNewInvitationsAndRelatedGames(
            userId: FirebaseAuth.instance.currentUser!.uid);

    if (kDebugMode) {
      print(newInvitationsAndRelatedGames);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelles invitations"),
        actions: [
          IconButton(
              tooltip: "Rafraîchir",
              onPressed: _fetchNewInvitations,
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _newInvitationList(),
      ),
    );
  }

  Widget _newInvitationList() {
    if (newInvitationsAndRelatedGames == null) {
      //Invitations not generated yet
      return const Center(child: CircularProgressIndicator());
    } else if (newInvitationsAndRelatedGames!.isEmpty) {
      //There is no new invitation
      return const Center(
        child: Text(
            "Vous n'avez pas de nouvelle invitation. Vous pouvez rafraîchir la page avec le bouton en haut à droite"),
      );
    } else {
      //Invitations are generated
      return ListView.builder(
        itemCount: newInvitationsAndRelatedGames!.length,
        itemBuilder: (BuildContext context, index) => ListTile(
          title:
              Text(newInvitationsAndRelatedGames!.values.elementAt(index).name),
          subtitle: Text(
              "Votre pseudo serait : '${newInvitationsAndRelatedGames!.keys.elementAt(index).playerPseudo}'"),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                icon: const Icon(Icons.info),
                title: const Text("Informations sur la partie"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                            "Votre pseudo serrait : '${newInvitationsAndRelatedGames!.keys.elementAt(index).playerPseudo}'"),
                      ),
                      ListTile(
                        title: Text(
                            "Le score de départ est de ${newInvitationsAndRelatedGames!.values.elementAt(index).startingScore} points"),
                      ),
                      ListTile(
                        title: Text(
                            "La partie a été créée le : ${newInvitationsAndRelatedGames!.values.elementAt(index).createdAt.toDate()}"),
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await checkNetworkAvailability(context);
                        my_crud_operations.refuseInvitation(
                            invitationId: newInvitationsAndRelatedGames!.keys
                                .elementAt(index)
                                .invitationId!);
                        Navigator.pop(context);
                      },
                      child: const Text("Refuser l'invitation")),
                  TextButton(
                      onPressed: () async {
                        await checkNetworkAvailability(context);
                        my_crud_operations.acceptInvitation(
                            invitationId: newInvitationsAndRelatedGames!.keys
                                .elementAt(index)
                                .invitationId!);
                        Navigator.pop(context);
                      },
                      child: const Text("Accepter l'invitation")),
                ],
              ),
            );
            _fetchNewInvitations();
          },
        ),
      );
    }
  }
}

class UserAcceptedInvitationsScreen extends StatefulWidget {
  const UserAcceptedInvitationsScreen({super.key});

  @override
  State<UserAcceptedInvitationsScreen> createState() =>
      _UserAcceptedInvitationsScreenState();
}

class _UserAcceptedInvitationsScreenState
    extends State<UserAcceptedInvitationsScreen> {
  Map<Invitation, Game>? acceptedInvitationsAndRelatedGames;

  @override
  void initState() {
    super.initState();
    _fetchAcceptedInvitations();
  }

  void _fetchAcceptedInvitations() async {
    await checkNetworkAvailability(context);

    acceptedInvitationsAndRelatedGames =
        await my_crud_operations.readUserAcceptedInvitationsAndRelatedGames(
            userId: FirebaseAuth.instance.currentUser!.uid);

    if (kDebugMode) {
      print(acceptedInvitationsAndRelatedGames);
    }

    setState(() {});
  }

  void _sortAcceptedInvitationsAndRelatedGamesByLastUpdate(
      {bool descending = false}) {
    if (acceptedInvitationsAndRelatedGames != null) {
      Map<Invitation, Game>? sortedByValueMap;
      if (descending) {
        sortedByValueMap = Map.fromEntries(acceptedInvitationsAndRelatedGames!
            .entries
            .toList()
          ..sort(
              (e1, e2) => e2.key.lastUpdateAt.compareTo(e1.key.lastUpdateAt)));
      } else {
        sortedByValueMap = Map.fromEntries(acceptedInvitationsAndRelatedGames!
            .entries
            .toList()
          ..sort(
              (e1, e2) => e1.key.lastUpdateAt.compareTo(e2.key.lastUpdateAt)));
      }
      setState(() {
        acceptedInvitationsAndRelatedGames = sortedByValueMap;
      });
    }
  }

  void _sortAcceptedInvitationsAndRelatedGamesByGamesNames(
      {bool antiAlphabetical = false}) {
    if (acceptedInvitationsAndRelatedGames != null) {
      Map<Invitation, Game>? sortedByValueMap;
      if (antiAlphabetical) {
        sortedByValueMap = Map.fromEntries(
            acceptedInvitationsAndRelatedGames!.entries.toList()
              ..sort((e1, e2) => e2.value.name.compareTo(e1.value.name)));
      } else {
        sortedByValueMap = Map.fromEntries(
            acceptedInvitationsAndRelatedGames!.entries.toList()
              ..sort((e1, e2) => e1.value.name.compareTo(e2.value.name)));
      }
      setState(() {
        acceptedInvitationsAndRelatedGames = sortedByValueMap;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des parties"),
        actions: [
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                trailingIcon: const Icon(Icons.arrow_upward),
                onPressed: () =>
                    _sortAcceptedInvitationsAndRelatedGamesByLastUpdate(),
                child: const Text("Dernières mises à jour (croissants"),
              ),
              MenuItemButton(
                trailingIcon: const Icon(Icons.arrow_downward),
                onPressed: () =>
                    _sortAcceptedInvitationsAndRelatedGamesByLastUpdate(
                        descending: true),
                child: const Text("Dernières mises à jour (décroissants)"),
              ),
              MenuItemButton(
                trailingIcon: const Icon(Icons.arrow_upward),
                onPressed: () =>
                    _sortAcceptedInvitationsAndRelatedGamesByGamesNames(),
                child: const Text("Noms parties (alphabétique)"),
              ),
              MenuItemButton(
                trailingIcon: const Icon(Icons.arrow_downward),
                onPressed: () =>
                    _sortAcceptedInvitationsAndRelatedGamesByGamesNames(
                        antiAlphabetical: true),
                child: const Text("Noms parties (anti-alphabétique)"),
              ),
              //Possibility to add more sorting methods here
            ],
            builder: (_, MenuController controller, Widget? child) {
              return IconButton(
                tooltip: "Trier",
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.sort),
              );
            },
          ),
          IconButton(
              tooltip: "Rafraîchir",
              onPressed: _fetchAcceptedInvitations,
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _acceptedInvitationList(),
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CreateGameScreen()));
            _fetchAcceptedInvitations();
          },
          child: const Text("Créer une nouvelle partie")),
    );
  }

  Widget _acceptedInvitationList() {
    if (acceptedInvitationsAndRelatedGames == null) {
      //Invitations are not generated yet
      return const Center(child: CircularProgressIndicator());
    } else if (acceptedInvitationsAndRelatedGames!.isEmpty) {
      //There is no accepted invitation
      return const Center(
        child: Text(
            "Vous n'êtes enregistré dans aucune partie pour le moment. Acceptez une inviation ou créez une partie"),
      );
    } else {
      //Invitations are generated
      return ListView.builder(
          itemCount: acceptedInvitationsAndRelatedGames!.length,
          itemBuilder: (BuildContext context, index) {
            bool hasUserSeenLastUpdate = acceptedInvitationsAndRelatedGames!
                        .keys
                        .elementAt(index)
                        .lastSeenAt ==
                    null
                ? false
                : acceptedInvitationsAndRelatedGames!.keys
                            .elementAt(index)
                            .lastSeenAt
                            ?.compareTo(acceptedInvitationsAndRelatedGames!.keys
                                .elementAt(index)
                                .lastUpdateAt) ==
                        -1
                    ? false
                    : true;
            return ListTile(
                tileColor: !hasUserSeenLastUpdate ? Colors.grey[200] : null,
                title: Badge(
                  isLabelVisible: !hasUserSeenLastUpdate,
                  child: Text(acceptedInvitationsAndRelatedGames!.values
                      .elementAt(index)
                      .name),
                ),
                subtitle: Text(
                    "Votre pseudo : ${acceptedInvitationsAndRelatedGames!.keys.elementAt(index).playerPseudo}"),
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => GameScreen(
                              game: acceptedInvitationsAndRelatedGames!.values
                                  .elementAt(index),
                              invitation: acceptedInvitationsAndRelatedGames!
                                  .keys
                                  .elementAt(index))));
                  _fetchAcceptedInvitations();
                });
          });
    }
  }
}
