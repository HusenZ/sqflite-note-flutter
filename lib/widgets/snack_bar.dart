import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
