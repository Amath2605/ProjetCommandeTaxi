

import 'package:flutter/material.dart';
import 'package:taximan/providers/active_trip.dart';
import 'package:taximan/providers/location.dart';
import 'package:taximan/providers/theme.dart';
import 'package:taximan/ui/common.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

Widget mainDrawer(BuildContext context, {bool isLoggedIn = true}) => Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height : 100,
                    child: Expanded(
                        child:
                            Lottie.asset('assets/lottie/taxi-animation.json')),
                  ),
                  Text(
                    "Taximan",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.black),
                  ),
                ],
              )),
          ListTile(
            leading: const Icon(Icons.local_taxi),
            title: const Text('Acceuil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Basculer le thème'),
            onTap: () {
              final tp = Provider.of<ThemeProvider>(context, listen: false);
              tp.isDark = !tp.isDark;
              Navigator.pop(context);
            },
          ),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Se déconnecter'),
              onTap: () {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  TripProvider.of(context, listen: false).deactivateTrip();
                  LocationProvider.of(context, listen: false).reset();
                });
                Navigator.pop(context);
              },
            ),
          const Divider(
            height : 10,
            thickness: 1,
          ),
          ListTile(
            title: const Text('Connecter avec le développeur'),
            subtitle: const Text(
              'https://www.linkedin.com/in/amadou-diatta-503bb7172/',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              launchUrl('https://www.linkedin.com/in/amadou-diatta-503bb7172/');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Obtenir le code source complet'),
            subtitle: const Text(
              'https://github.com/Amath2605/taximan',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              launchUrl('https://github.com/Amath2605/taximan');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
