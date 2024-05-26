import 'package:flutter/material.dart';

class Snackbar {
  BuildContext get context => null;

  void showSnack(String message, GlobalKey<ScaffoldState> _scaffoldKey,
          Function undo) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: undo != null ? SnackBarAction(
            textColor: Theme.of(_scaffoldKey.currentState.context).primaryColor,
            label: "Undo",
            onPressed: () => undo,
          ):null,
        ),
      );
}
