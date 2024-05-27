import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user_invitations_screens.dart';

import '../../../classes/database_management/games.dart';
import '../../../classes/database_management/invitations.dart';
import '../../../classes/network_checker.dart';
import '../../../classes/snack_bars.dart';
import '../../../classes/utils.dart';
import '../../../classes/database_management/crud_operations.dart'
    as my_crud_operations;

class GameInfoScreen extends StatefulWidget {
  final Game game;

  const GameInfoScreen({
    super.key,
    required this.game,
  });

  @override
  State<GameInfoScreen> createState() => _GameInfoScreenState();
}

class _GameInfoScreenState extends State<GameInfoScreen> {
  List<Invitation>? allGameInvitations;
  @override
  void initState() {
    super.initState();
    _fetchAllGameInvitations();
  }

  void _fetchAllGameInvitations() async {
    await checkNetworkAvailability(context);

    allGameInvitations = await my_crud_operations.readAllGameInvitations(
        gameId: widget.game.gameId!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infos sur la partie"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nom de la partie : ${widget.game.name}"),
                    Text("Score de départ : ${widget.game.startingScore}"),
                    Text("Partie créée le : ${widget.game.createdAt.toDate()}"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Liste des joueurs de la partie',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        allGameInvitations != null
                            ? allGameInvitations!.length
                            : 1, (index) {
                      if (allGameInvitations != null) {
                        Invitation currentInvitation =
                            allGameInvitations!.elementAt(index);
                        return ListTile(
                          title: Text("${currentInvitation.playerPseudo}"
                              "${widget.game.ownerId == allGameInvitations!.elementAt(index).playerId ? " (Propriétaire de la partie)" : ""}"
                              "${FirebaseAuth.instance.currentUser?.uid == allGameInvitations!.elementAt(index).playerId ? " (Vous)" : ""}"),
                          subtitle: Text(
                              "Invité le : ${currentInvitation.invitedAt.toDate()}"),
                          trailing: switch (
                              currentInvitation.isInvitationAccepted) {
                            true => const Text("Invitation acceptée"),
                            false => const Text("Invitation refusée"),
                            null => const Text("Invitation en attente"),
                          },
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    }),
                  ),
                ),
              ),
              GameOwnerMenu(
                  game: widget.game, allGameInvitations: allGameInvitations),
            ],
          ),
        ),
      ),
    );
  }
}

class AddPlayerToGameDialog extends StatelessWidget {
  final String gameId;
  final List<Invitation> allGameInvitations;
  const AddPlayerToGameDialog({
    super.key,
    required this.gameId,
    required this.allGameInvitations,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final TextEditingController playerUid = TextEditingController();
    final TextEditingController playerPseudo = TextEditingController();

    return AlertDialog(
      title: const Text("Inviter quelqu'un à la partie"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value?.trim() != null) {
                        if (isValidFirebaseUserId(value!.trim())) {
                          return null;
                        } else {
                          return "Cette chaine de caractère ne ressemble pas à un identifiant";
                        }
                      } else {
                        return "Veuillez entrer un ID utilisateur ou supprimer ce champs";
                      }
                    },
                    controller: playerUid,
                    decoration: const InputDecoration(
                      labelText: "Identifiant",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return value?.trim() != null && value!.trim().length >= 5
                          ? null
                          : "Choisissez un pseudo d'au moins 5 caractères s'il vous plait";
                    },
                    controller: playerPseudo,
                    decoration: const InputDecoration(
                      labelText: "Pseudo",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler")),
        TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (allGameInvitations.any(
                    (element) => element.playerId == playerUid.text.trim())) {
                  ScaffoldMessenger.of(context).showSnackBar(myWarningSnackBar(
                      message: "Ce joueur est déjà présent dans la partie"));
                } else {
                  await checkNetworkAvailability(context);

                  Timestamp invitationTimestamp = Timestamp.now();
                  my_crud_operations.createInvitation(
                      invitation: Invitation(
                          playerId: playerUid.text.trim(),
                          gameId: gameId,
                          invitedAt: invitationTimestamp,
                          playerPseudo: playerPseudo.text.trim(),
                          isInvitationAccepted: null,
                          lastUpdateAt: invitationTimestamp));
                  ScaffoldMessenger.of(context).showSnackBar(
                      mySuccessSnackBar(message: "Invitation envoyée !"));
                  Navigator.pop(context);
                }
              }
            },
            child: const Text("Inviter"))
      ],
    );
  }
}

class RemovePlayerOfGameDialog extends StatelessWidget {
  final String gameId;
  final List<Invitation> allGameInvitations;
  const RemovePlayerOfGameDialog({
    super.key,
    required this.gameId,
    required this.allGameInvitations,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Invitation? selectedPlayerInvitation;
    return AlertDialog(
      title: const Text("Retirer quelqu'un de la partie"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              errorMaxLines: 2,
              labelText: "Pseudo de la personne",
              border: OutlineInputBorder(),
            ),
            items: List.generate(
                allGameInvitations.length,
                (index) => DropdownMenuItem(
                    value: allGameInvitations.elementAt(index),
                    child: Text(
                        allGameInvitations.elementAt(index).playerPseudo))),
            onChanged: (value) {
              selectedPlayerInvitation = value;
            },
            validator: (value) {
              if (selectedPlayerInvitation != null) {
                return null;
              } else {
                return "Veuillez sélectionner quelqu'un  à retirer de la partie.";
              }
            },
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler")),
        TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text(
                              "Retirer ${selectedPlayerInvitation?.playerPseudo} de la partie ?"),
                          content: Text(
                              "Êtes vous sûr de vouloir retirer ${selectedPlayerInvitation?.playerPseudo} de la partie ?\n\n"
                              "Il ne pourra plus accèder à la partie sans y être ré invité. "
                              "Les jugements qui lui ont été attribués seront supprimés également."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annuler")),
                            TextButton(
                                onPressed: () async {
                                  await checkNetworkAvailability(context);

                                  my_crud_operations.deleteUserFromGame(
                                      userId:
                                          selectedPlayerInvitation!.playerId,
                                      gameId: gameId,
                                      invitationId: selectedPlayerInvitation!
                                          .invitationId!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      mySuccessSnackBar(
                                          message:
                                              "Joueur retiré de la partie !"));
                                  Navigator.pop(context);
                                },
                                child: const Text("Oui, retirer"))
                          ],
                        ));
              }
            },
            child: const Text("Retirer cette personne"))
      ],
    );
  }
}

class DeleteGameDialog extends StatelessWidget {
  final Game game;
  const DeleteGameDialog({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Supprimer la partie"),
      content: Text("Êtes vous sûr de vouloir supprimer '${game.name}' ?\n\n"
          "La partie, tous les jugements et toutes les invitations de la partie seront supprimés."),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler")),
        TextButton(
            onPressed: () async {
              await checkNetworkAvailability(context);

              my_crud_operations.deleteGame(gameId: game.gameId!);
              ScaffoldMessenger.of(context).showSnackBar(
                  mySuccessSnackBar(message: "Partie supprimée !"));
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => const UserAcceptedInvitationsScreen()));
            },
            child: const Text("Oui, supprimer"))
      ],
    );
  }
}

class GameOwnerMenu extends StatelessWidget {
  final Game game;
  final List<Invitation>? allGameInvitations;
  const GameOwnerMenu(
      {super.key, required this.game, required this.allGameInvitations});

  @override
  Widget build(BuildContext context) {
    void allGameInvitationsIsNull() {
      ScaffoldMessenger.of(context).showSnackBar(myWarningSnackBar(
          message: "Les invitations de la partie ne sont pas chargées"));
    }

    if (game.ownerId == FirebaseAuth.instance.currentUser!.uid) {
      return Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  if (allGameInvitations != null) {
                    showDialog(
                        context: context,
                        builder: (_) => AddPlayerToGameDialog(
                              gameId: game.gameId!,
                              allGameInvitations: allGameInvitations!,
                            ));
                  } else {
                    allGameInvitationsIsNull();
                  }
                },
                child: const Text("Inviter quelqu'un à rejoindre la partie")),
            TextButton(
                onPressed: () {
                  if (allGameInvitations != null) {
                    showDialog(
                        context: context,
                        builder: (_) => RemovePlayerOfGameDialog(
                            gameId: game.gameId!,
                            allGameInvitations: allGameInvitations!));
                  } else {
                    allGameInvitationsIsNull;
                  }
                },
                child: const Text("Retirer quelqu'un de la partie")),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => DeleteGameDialog(game: game));
                },
                child: const Text(
                  "Supprimer la partie",
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
            "Pour ajouter/supprimer quelqu'un de la partie ou supprimer la partie, veuillez contacter le propriétaire de la partie."),
      );
    }
  }
}
