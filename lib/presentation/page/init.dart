import 'package:flutter/material.dart';

class InitPage extends StatelessWidget {
  final String appTitle;

  const InitPage({required this.appTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: Text(
          appTitle,
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
      ),
    );
  }
}
