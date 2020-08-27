import 'package:flutter/material.dart';

class DebugWidget extends StatelessWidget {
  String error;

  DebugWidget(this.error);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
      child: Text(this.error),
    );
  }
}
