import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final void Function() onSave;
  final void Function() onCancel;

  const DialogBox({
    super.key,
    required this.onSave,
    required this.onCancel,
  });


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout'),
      content: Text('Are you sure you want to logout ?'),
      actions: [
        TextButton(
          onPressed: onSave,
          child: Text('Logout'),
        ),
        TextButton(
          onPressed: onCancel,
          child: Text('Cancel'),
        ),
      ],
    );
  }
}