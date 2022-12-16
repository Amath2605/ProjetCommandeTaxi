// ignore_for_file: unused_import, prefer_const_declarations, unused_element

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import "package:google_maps_webservice/places.dart";
import "package:google_maps_webservice/geocoding.dart";

import 'package:google_maps_webservice/directions.dart' as dir;
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

const String _appleBundleId = "https://github.com/Amath2605/ProjetCommandeTaxi.git";
const String _googleMapsApiKey = "AIzaSyBDYanX82fCOO3bkDU9KX3xhIM89doGAEw";
final _googleApiHeaders = {"x-ios-bundle-identifier": _appleBundleId};

//Platform.environment['API_KEY']

const prodApiProxy =
    "https://europe-west2-flutterbasedotcom.cloudfunctions.net/TaximanWebDemo";
final googleApiProxy = "$prodApiProxy/__https__/maps.googleapis.com/maps/api";

final apiGooglePlaces = GoogleMapsPlaces(
  apiKey: _googleMapsApiKey,
  // apiHeaders: _googleApiHeaders,
  baseUrl: googleApiProxy,
);

final apiGeocoding = GoogleMapsGeocoding(
  apiKey: _googleMapsApiKey,
  //apiHeaders: _googleApiHeaders,
  baseUrl: googleApiProxy,
);

final apiDirections = dir.GoogleMapsDirections(
  apiKey: _googleMapsApiKey,
  //apiHeaders: _googleApiHeaders,
  baseUrl: googleApiProxy,
);

List<LatLng>? createPolylinePointsFromDirections(
    dir.DirectionsResponse response) {
  if (response.isOkay) {
    final polylineRawList =
        decodePolyline(response.routes[0].overviewPolyline.points);
    List<LatLng> polylinePointList = polylineRawList
        .map((p) => LatLng(p[0].toDouble(), p[1].toDouble()))
        .toList();
    return polylinePointList;
  }
  return null;
}

// Copied from Google map style builder
const String googleMapDefaultStyle = '[]';
const String googleMapDarkStyle = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#263c3f"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6b9a76"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#38414e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#212a37"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9ca5b3"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#1f2835"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#f3d19c"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2f3948"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#515c6d"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  }
]''';
