import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../classes/database_management/games.dart';
import '../../../classes/database_management/invitations.dart';
import '../../../classes/network_checker.dart';
import '../../../classes/utils.dart';
import '../../../classes/database_management/crud_operations.dart'
    as my_crud_operations;

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final List<Widget> _playersFormFieldList = [];

  final List<TextEditingController> _playerIdControllersList = [];
  final List<TextEditingController> _playerPseudoControllersList = [];

  bool _doesControllerTextNotAlreadyInControllersTexts(
      {required TextEditingController controller,
      required List<TextEditingController> controllers}) {
    return controllers
            .where((element) => element.text.trim() == controller.text.trim())
            .length ==
        1;
  }

  void _addPlayersFormField() {
    TextEditingController playerId = TextEditingController();
    TextEditingController playerPseudo = TextEditingController();
    _playersFormFieldList.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value != null && isValidFirebaseUserId(value.trim())) {
                  if (_doesControllerTextNotAlreadyInControllersTexts(
                      controller: playerId,
                      controllers: _playerIdControllersList)) {
                    if (value.trim() !=
                        FirebaseAuth.instance.currentUser?.uid) {
                      return null;
                    } else {
                      return "Vous ne pouvez pas vous inviter vous-même dans la partie";
                    }
                  } else {
                    return "Vous ne pouvez pas inviter 2 fois la même personne";
                  }
                } else {
                  return "Cette chaine de caractère ne ressemble pas à un identifiant utilisateur";
                }
              },
              controller: playerId,
              decoration: InputDecoration(
                errorMaxLines: 3,
                labelText:
                    "Identifiant joueur ${_playersFormFieldList.length + 1}",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.numbers),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value?.trim() != null && value!.trim().length >= 5) {
                  if (_doesControllerTextNotAlreadyInControllersTexts(
                      controller: playerPseudo,
                      controllers: _playerPseudoControllersList)) {
                    if (value.trim() != _creatorPseudo.text.trim()) {
                      return null;
                    } else {
                      return "Vous ne pouvez pas utiliser votre pseudo pour quelqu'un d'autre";
                    }
                  } else {
                    return "Vous ne pouvez pas utiliser 2 fois le même pseudo";
                  }
                } else {
                  return "Choisissez un pseudo d'au moins 5 caractères s'il vous plait";
                }
              },
              controller: playerPseudo,
              decoration: InputDecoration(
                errorMaxLines: 3,
                labelText: "Pseudo joueur ${_playersFormFieldList.length + 1}",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
    ));
    _playerIdControllersList.add(playerId);
    _playerPseudoControllersList.add(playerPseudo);
    setState(() {});
  }

  void _removeLastFormField() {
    if (_playersFormFieldList.isNotEmpty) {
      _playersFormFieldList.removeLast();
      _playerIdControllersList.removeLast();
      _playerPseudoControllersList.removeLast();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _addPlayersFormField(); // Add an initial form field
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _gameName = TextEditingController();
  final TextEditingController _creatorPseudo = TextEditingController();
  final TextEditingController _startingScore = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer une partie"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return value!.trim().length >= 3
                            ? null
                            : "Choisissez un nom de partie d'au moins 3 caractères s'il vous plait";
                      },
                      controller: _gameName,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.abc),
                        labelText: "Nom de la partie",
                        border: OutlineInputBorder(),
                        hintText:
                            "Example : 'La partie de vos rêves' (Minimum 3 caractères)",
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return value!.isEmpty
                            ? "Veuillez entrer un nombre"
                            : null;
                      },
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            r'^[1-9]\d*$')), // Autoriser les chiffres seulement
                        FilteringTextInputFormatter.deny(RegExp(
                            r'[-,.]')), // Interdire les signes négatifs, les virgules et les points
                      ],
                      controller: _startingScore,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.onetwothree),
                          labelText: "Score de départ",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return value!.trim().length >= 5
                            ? null
                            : "Choisissez un pseudo d'au moins 5 caractères s'il vous plait";
                      },
                      controller: _creatorPseudo,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Votre pseudo",
                          border: OutlineInputBorder(),
                          hintText: "Minimum 5 caractères"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: _playersFormFieldList,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                          tooltip: "Supprimer un joueur",
                          onPressed: _playersFormFieldList.length > 1
                              ? _removeLastFormField
                              : null,
                          icon: const Icon(Icons.remove_circle_outline)),
                      IconButton(
                          tooltip: "Ajouter un joueur",
                          onPressed: _addPlayersFormField,
                          icon: const Icon(Icons.add_circle_outline)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text("Créer la partie"),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await checkNetworkAvailability(context);

            Timestamp gameCreationTimestamp = Timestamp.now();

            //Creating the game and the invitation for the creator
            String gameId = await my_crud_operations.createGame(
              game: Game(
                createdAt: gameCreationTimestamp,
                name: _gameName.text.trim(),
                startingScore: int.parse(_startingScore.text),
                ownerId: FirebaseAuth.instance.currentUser!.uid,
              ),
              creatorPseudo: _creatorPseudo.text.trim(),
            );

            //Creating the invitations for the other players
            for (int i = 0; i < _playerIdControllersList.length; i++) {
              my_crud_operations.createInvitation(
                  invitation: Invitation(
                invitedAt: gameCreationTimestamp,
                lastUpdateAt: gameCreationTimestamp,
                playerId: _playerIdControllersList[i].text.trim(),
                gameId: gameId,
                isInvitationAccepted: null,
                playerPseudo: _playerPseudoControllersList[i].text.trim(),
              ));
            }
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
