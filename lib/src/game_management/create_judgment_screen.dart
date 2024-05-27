import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../classes/snack_bars.dart';
import '../../classes/database_management/judgments.dart';
import '../../classes/database_management/invitations.dart';
import '../../classes/network_checker.dart';
import '../../classes/database_management/crud_operations.dart'
    as my_crud_operation;

class CreateJudgmentScreen extends StatefulWidget {
  final String gameId;
  final Invitation judgeInvitation;
  final List<Invitation> gameInvitationList;
  const CreateJudgmentScreen(
      {super.key,
      required this.gameId,
      required this.judgeInvitation,
      required this.gameInvitationList});

  @override
  State<CreateJudgmentScreen> createState() => _CreateJudgmentScreenState();
}

//TODO: change this for a Dialog and add it in the GameScreen

class _CreateJudgmentScreenState extends State<CreateJudgmentScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    Invitation? selectedPlayerInvitation;

    final TextEditingController jokeDescription = TextEditingController();

    final TextEditingController scoreModification = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Juger une blague"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                    validator: (value) => List.generate(
                                widget.gameInvitationList.length,
                                (index) =>
                                    widget.gameInvitationList[index].playerId)
                            .contains(value?.playerId)
                        ? null
                        : "Veuillez sélectionner un joueur",
                    items: List.generate(
                        widget.gameInvitationList.length,
                        (index) => DropdownMenuItem(
                              value: widget.gameInvitationList[index],
                              child: Text(
                                  "${widget.gameInvitationList[index].playerPseudo} "
                                  "${widget.gameInvitationList[index].playerPseudo == widget.judgeInvitation.playerPseudo ? "(Vous)" : ""}"),
                            )),
                    onChanged: (value) {
                      selectedPlayerInvitation = value;
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: jokeDescription,
                  decoration: const InputDecoration(
                    labelText: "Description de la blague",
                    border: OutlineInputBorder(),
                    hintText:
                        "Ex : 'Tire sur mon doigt' (Minimum 10 caractères)",
                  ),
                  validator: (value) => value!.length >= 10
                      ? null
                      : "10 caractères minimum s'il vous plaît",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: scoreModification,
                  decoration: const InputDecoration(
                      labelText: "Score de la blague",
                      border: OutlineInputBorder(),
                      hintText: "Ex : 5 ou -5"),
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  validator: (value) => RegExp(r'^-?[1-9]\d*$')
                          .hasMatch(value ?? "")
                      ? null
                      : "Vous devez saisir un score (négatif ou positif) valide",
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      //All the form fields are good

                      await checkNetworkAvailability(context);

                      int playerScore = await my_crud_operation
                          .readLastJudgmentInGameForPlayer(
                              gameId: widget.gameId,
                              playerId: selectedPlayerInvitation!.playerId)
                          .then((judgment) {
                        if (judgment != null) {
                          return judgment.newScore;
                        } else {
                          return my_crud_operation
                              .readGame(gameId: widget.gameId)
                              .then((game) => game.startingScore);
                        }
                      });

                      int scoreModificationValue =
                          int.parse(scoreModification.text);
                      my_crud_operation.createJudgment(
                          judgment: Judgment(
                              judgedAt: Timestamp.now(),
                              scoreModification: scoreModificationValue,
                              jokeDescription: jokeDescription.text.trim(),
                              newScore: playerScore + scoreModificationValue,
                              judgedBy: widget.judgeInvitation.playerPseudo,
                              playerId: selectedPlayerInvitation!.playerId,
                              gameId: widget.gameId));
                      ScaffoldMessenger.of(context).showSnackBar(
                          mySuccessSnackBar(message: "Jugement ajouté !"));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Valider le jugement")),
            ],
          ),
        ),
      ),
    );
  }
}
