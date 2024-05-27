import 'package:flutter/material.dart';

SnackBar mySuccessSnackBar({required String message}) => SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );

SnackBar myWarningSnackBar({required String message}) => SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.yellow,
    );

SnackBar myErrorSnackBar({required String message}) => SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.red,
    );