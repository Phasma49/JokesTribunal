import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../create_judgment_screen.dart';

import '../../../classes/snack_bars.dart';
import '../../../src/game_management/game/game_info_screen.dart';
import '../../../classes/database_management/games.dart';
import '../../../classes/database_management/invitations.dart';
import '../../../classes/database_management/judgments.dart';
import '../../../classes/network_checker.dart';
import '../../../classes/database_management/crud_operations.dart'
    as my_crud_operations;

class GameScreen extends StatefulWidget {
  final Game game;
  final Invitation invitation;

  const GameScreen({super.key, required this.game, required this.invitation});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Map<Invitation, Judgment?>? gameInvitationsAndRelatedLastJudgment;

  @override
  void initState() {
    super.initState();

    my_crud_operations.updateInvitationLastSeen(
        invitationId: widget.invitation.invitationId!);

    _fetchGameAcceptedInvitations();
  }

  @override
  void dispose() {
    my_crud_operations.updateInvitationLastSeen(
        invitationId: widget.invitation.invitationId!);

    super.dispose();
  }

  void _fetchGameAcceptedInvitations() async {
    await checkNetworkAvailability(context);
    gameInvitationsAndRelatedLastJudgment =
        await my_crud_operations.readInvitationsAndRelatedLastJudgmentInGame(
            gameId: widget.game.gameId!);

    if (kDebugMode) {
      print(gameInvitationsAndRelatedLastJudgment);
    }

    setState(() {});
  }

  void _sortGameAcceptedInvitationsByNewScore({bool descending = false}) {
    if (_areGameAcceptedInvitationsAreSortableByValues()) {
      Map<Invitation, Judgment?>? sortedByValueMap;
      if (descending) {
        sortedByValueMap = Map.fromEntries(
            gameInvitationsAndRelatedLastJudgment!.entries.toList()
              ..sort((e1, e2) {
                if (e1.value != null && e2.value != null) {
                  return e2.value!.newScore.compareTo(e1.value!.newScore);
                } else {
                  //Alphabetical sort
                  return e1.key.playerPseudo.compareTo(e2.key.playerPseudo);
                }
              }));
      } else {
        sortedByValueMap = Map.fromEntries(
            gameInvitationsAndRelatedLastJudgment!.entries.toList()
              ..sort((e1, e2) {
                if (e1.value != null && e2.value != null) {
                  return e1.value!.newScore.compareTo(e2.value!.newScore);
                } else {
                  //Alphabetical sort
                  return e1.key.playerPseudo.compareTo(e2.key.playerPseudo);
                }
              }));
      }
      gameInvitationsAndRelatedLastJudgment = sortedByValueMap;
      setState(() {});
    }
  }

  void _sortGameAcceptedInvitationsByJudgedAt({bool descending = false}) {
    if (_areGameAcceptedInvitationsAreSortableByValues()) {
      Map<Invitation, Judgment?>? sortedByValueMap;

      if (descending) {
        sortedByValueMap = Map.fromEntries(
            gameInvitationsAndRelatedLastJudgment!.entries.toList()
              ..sort((e1, e2) {
                if (e1.value != null && e2.value != null) {
                  return e2.value!.judgedAt.compareTo(e1.value!.judgedAt);
                } else {
                  //Alphabetical sort
                  return e1.key.playerPseudo.compareTo(e2.key.playerPseudo);
                }
              }));
      } else {
        sortedByValueMap = Map.fromEntries(
            gameInvitationsAndRelatedLastJudgment!.entries.toList()
              ..sort((e1, e2) {
                if (e1.value != null && e2.value != null) {
                  return e1.value!.judgedAt.compareTo(e2.value!.judgedAt);
                } else {
                  //Alphabetical sort
                  return e1.key.playerPseudo.compareTo(e2.key.playerPseudo);
                }
              }));
      }
      gameInvitationsAndRelatedLastJudgment = sortedByValueMap;
      setState(() {});
    }
  }

  void _sortGameAcceptedInvitationsByPlayerInGamePseudos(
      {antiAlphabetical = false}) {
    Map<Invitation, Judgment?>? sortedByValueMap;
    if (antiAlphabetical) {
      sortedByValueMap = Map.fromEntries(gameInvitationsAndRelatedLastJudgment!
          .entries
          .toList()
        ..sort((e1, e2) => e2.key.playerPseudo.compareTo(e1.key.playerPseudo)));
    } else {
      sortedByValueMap = Map.fromEntries(gameInvitationsAndRelatedLastJudgment!
          .entries
          .toList()
        ..sort((e1, e2) => e1.key.playerPseudo.compareTo(e2.key.playerPseudo)));
    }
    gameInvitationsAndRelatedLastJudgment = sortedByValueMap;
    setState(() {});
  }

  bool _areGameAcceptedInvitationsAreSortableByValues() {
    bool result = gameInvitationsAndRelatedLastJudgment != null &&
        !gameInvitationsAndRelatedLastJudgment!.values.contains(null);
    if (!result) {
      _sortGameAcceptedInvitationsByPlayerInGamePseudos();
      ScaffoldMessenger.of(context).showSnackBar(myWarningSnackBar(
          message:
              "Tri impossible puisque tout les joueurs n'ont pas été jugés au moins une fois. "
              "Tri par ordre alphabétique effectué."));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    MenuController menuController = MenuController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        actions: [
          MenuAnchor(
            controller: menuController,
            menuChildren: [
              MenuItemButton(
                child: const Text("Infos sur la partie"),
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => GameInfoScreen(
                            game: widget.game,
                          )));
                  _fetchGameAcceptedInvitations();
                },
              ),
              SubmenuButton(
                menuChildren: [
                  MenuItemButton(
                    trailingIcon: const Icon(Icons.arrow_upward),
                    onPressed: () => _sortGameAcceptedInvitationsByNewScore(),
                    child: const Text("Scores (croissants"),
                  ),
                  MenuItemButton(
                    trailingIcon: const Icon(Icons.arrow_downward),
                    onPressed: () => _sortGameAcceptedInvitationsByNewScore(
                        descending: true),
                    child: const Text("Scores (décroissants)"),
                  ),
                  MenuItemButton(
                    trailingIcon: const Icon(Icons.arrow_upward),
                    onPressed: () => _sortGameAcceptedInvitationsByJudgedAt(),
                    child: const Text("Dernières blagues (croissant)"),
                  ),
                  MenuItemButton(
                    trailingIcon: const Icon(Icons.arrow_downward),
                    onPressed: () => _sortGameAcceptedInvitationsByJudgedAt(
                        descending: true),
                    child: const Text("Dernières blagues (décroissant)"),
                  ),
                  MenuItemButton(
                    trailingIcon: const Icon(Icons.arrow_upward),
                    onPressed: () =>
                        _sortGameAcceptedInvitationsByPlayerInGamePseudos(),
                    child: const Text("Noms joueurs (alphabétique)"),
                  ),
                  MenuItemButton(
                    trailingIcon: const Icon(Icons.arrow_downward),
                    onPressed: () =>
                        _sortGameAcceptedInvitationsByPlayerInGamePseudos(
                            antiAlphabetical: true),
                    child: const Text("Noms joueurs (anti-alphabétique)"),
                  ),
                  //Possibility to add more sorting methods here
                ],
                child: const Text("Trier"),
              ),
              MenuItemButton(
                onPressed: _fetchGameAcceptedInvitations,
                child: const Text("Rafraîchir"),
              ),
            ],
            builder: (_, __, ___) {
              return IconButton(
                tooltip: "Menu",
                onPressed: () {
                  if (menuController.isOpen) {
                    menuController.close();
                  } else {
                    menuController.open();
                  }
                },
                icon: const Icon(Icons.menu),
              );
            },
          ),
        ],
      ),
      body: _playersScoreList(),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateJudgmentScreen(
                      gameInvitationList:
                          gameInvitationsAndRelatedLastJudgment!.keys.toList(),
                      gameId: widget.game.gameId!,
                      judgeInvitation: widget.invitation,
                    )),
          );
          _fetchGameAcceptedInvitations();
        },
        child: const Text("Juger une blague"),
      ),
    );
  }

  Widget _playersScoreList() {
    if (gameInvitationsAndRelatedLastJudgment == null) {
      //Scores not generated yet
      return const Center(child: CircularProgressIndicator());
    } else if (gameInvitationsAndRelatedLastJudgment!.values
        .where((judgment) => judgment != null)
        .isEmpty) {
      //There is no score for the moment -> display the default page (game description)
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
              text: TextSpan(
                  style: const TextStyle(
                      color: Colors.black, fontSize: 18, height: 1.5),
                  text: "Bienvenue dans ",
                  children: [
                TextSpan(
                  text: widget.game.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: " ! Vous disposez de "),
                TextSpan(
                  text: widget.game.startingScore.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                    text: " points au début de la partie. "
                        "Au fil du temps, vous pouvez juger les blagues des autres joueurs et les scores vont ainsi évoluer. "
                        "Il n'y a pas de fin prévue à cette partie, vous pouvez atteindre un score faramineux ou au contraire tomber dans le négatif !\n\n"
                        "Quand vous voulez juger une blague, cliquez simplement sur le bouton en bas de l'écran."),
              ])),
        ),
      );
    } else {
      //Scores are generated
      return ListView.builder(
          itemCount: gameInvitationsAndRelatedLastJudgment!.length,
          itemBuilder: (context, index) {
            String score = "";
            String lastJoke = "";
            if (gameInvitationsAndRelatedLastJudgment!.values
                    .elementAt(index) !=
                null) {
              score =
                  "${gameInvitationsAndRelatedLastJudgment!.values.elementAt(index)?.newScore}";
              lastJoke =
                  "Dernière blague : (${gameInvitationsAndRelatedLastJudgment!.values.elementAt(index)?.scoreModification}) "
                  "${gameInvitationsAndRelatedLastJudgment!.values.elementAt(index)?.jokeDescription}";
            } else {
              score = "${widget.game.startingScore}";
              lastJoke =
                  "Cette personne n'a pas encore été jugée sur une blague. Son score est égal au score de départ de la partie";
            }
            return ListTile(
              title: Text(
                  "${gameInvitationsAndRelatedLastJudgment!.keys.elementAt(index).playerPseudo}"
                  "${FirebaseAuth.instance.currentUser?.uid == gameInvitationsAndRelatedLastJudgment!.keys.elementAt(index).playerId ? " (Vous)" : ""}"),
              trailing: Text(score),
              subtitle: Text(lastJoke),
            );
          });
    }
  }
}
