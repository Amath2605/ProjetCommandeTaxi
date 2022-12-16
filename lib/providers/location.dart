// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:taximan/api/google_api.dart';
import 'package:taximan/types/resolved_address.dart';
import 'package:taximan/ui/common.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  bool pendingDetermineCurrentLocation = false;

  ResolvedAddress? _currentAddress;
  set currentAddress(ResolvedAddress? newAddress) {
    _currentAddress = newAddress;
    notifyListeners();
  }

  ResolvedAddress? get currentAddress => _currentAddress;

  bool get isDemoLocationFixed => _currentAddress != null;

  void reset() {
    _currentAddress = null;
    notifyListeners();
  }

  void determineCurrentLocation() async {
    try {
      pendingDetermineCurrentLocation = true;
      notifyListeners();

      final p = await _determinePosition();
      final res = await apiGeocoding
          .searchByLocation(Location(lat: p.latitude, lng: p.longitude));
      if (!res.isOkay)
        throw Exception(
            'Erreur API de géocodage. Statut: ${res.status} ${res.errorMessage ?? ""}');
      final f = res.results.first;
      final mainPart = (f.addressComponents.length / 2.0).floor();

      currentAddress = ResolvedAddress(
        mainText: f.addressComponents.take(mainPart).join(',').toString(),
        secondaryText: f.addressComponents.skip(mainPart).join(',').toString(),
        location: f.geometry.location,
      );

      showScaffoldSnackBarMessage(
          '${currentAddress!.mainText} a été défini comme emplacement actuel.');
    } catch (e) {
      showScaffoldSnackBarMessage(e.toString());
    } finally {
      pendingDetermineCurrentLocation = false;
      notifyListeners();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Les services de localisation sont désactivés.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Les autorisations de localisation sont refusées');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Les autorisations de localisation sont définitivement refusées, nous ne pouvons pas demander dautorisations.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final cp = await Geolocator.getCurrentPosition();
    return cp;
  }

  static LocationProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<LocationProvider>(context, listen: listen);
}
