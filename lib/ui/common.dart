

// ignore_for_file: unused_local_variable, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:taximan/providers/location.dart';

import 'main_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showScaffoldSnackBar(SnackBar snackBar) =>
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);

void showScaffoldSnackBarMessage(String message) =>
    rootScaffoldMessengerKey.currentState
        ?.showSnackBar(SnackBar(content: Text(message)));

void launchUrl(String url) async {
  if (!await launch(url))
    showScaffoldSnackBarMessage('Impossible douvrir URL : "$url"');
}

Widget buildAppScaffold(BuildContext context, Widget child,
    {isLoggedIn = true}) {
  final isLocationFixed = LocationProvider.of(context).isDemoLocationFixed;
  return Scaffold(
    floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    floatingActionButton: Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(top : 8.0),
        child: FloatingActionButton(
          mouseCursor: SystemMouseCursors.click,
          child: const Icon(
            Icons.menu,
          ),

          onPressed: () =>
              Scaffold.of(context).openDrawer(), // <-- Opens drawer.
        ),
      );
    }),
    drawer: mainDrawer(context, isLoggedIn: isLoggedIn),
    body: SafeArea(child: child),
  );
}
