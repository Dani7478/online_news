import 'package:flutter/material.dart';

snackBar(BuildContext context, String text, String lbl) {
  final scaffold = ScaffoldMessenger.of(context);
  return scaffold.showSnackBar(
    SnackBar(
      backgroundColor: Color(0xFF04128f),
      //duration: Duration(seconds: 1),
      content: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      action: SnackBarAction(
        label: lbl,
        onPressed: scaffold.hideCurrentSnackBar,
        textColor: Colors.white,
      ),
    ),
  );
}
