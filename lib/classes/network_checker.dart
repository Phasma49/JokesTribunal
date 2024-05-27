import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> checkNetworkAvailability(BuildContext context) async {
  bool result = await InternetConnection().hasInternetAccess;
  if (!result) {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const NetworkActivationDialog());
  }
}

class NetworkActivationDialog extends StatefulWidget {
  const NetworkActivationDialog({super.key});

  @override
  State<NetworkActivationDialog> createState() =>
      _NetworkActivationDialogState();
}

class _NetworkActivationDialogState extends State<NetworkActivationDialog> {
  @override
  void initState() {
    super.initState();
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.signal_cellular_connected_no_internet_0_bar),
          SizedBox(
            width: 8,
          ),
          Icon(Icons.signal_wifi_connected_no_internet_4),
        ],
      ),
      title: const Text("Pas de connection à internet !"),
      content: const Column(
        children: [
          Text(
              "L'action que vous voulez réaliser nécessite une connexion à internet. "
              "Veuillez activer vos données cellulaires ou votre connection WIFI."),
          Text(
              "Cette pop-up ce fermera automatiquement quand une connection à internet sera détectée. "
              "Vous pouvez fermer cette pop-up manuellement sans activer de connection à internet mais l'action que vous voulez réaliser pourrais ne pas s'effectuer.")
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Ne pas activer de connection à internet"))
      ],
    );
  }
}
