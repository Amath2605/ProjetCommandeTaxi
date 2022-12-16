

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'resolved_address.dart';

enum ExTripStatus {
  submitted,
  allocated,
  arrived,
  driving,
  completed,
  cancelled,
}

final tripStatusDescriptions = <ExTripStatus, String>{
  ExTripStatus.submitted: "Commande soumise",
  ExTripStatus.allocated: "Trouver un taximan",
  ExTripStatus.arrived: "Arriver de taximan",
  ExTripStatus.driving: "Conduire...",
  ExTripStatus.completed: "Commande terminer",
  ExTripStatus.cancelled: "Commande annulée",
};

bool tripIsFinished(ExTripStatus status) =>
    [ExTripStatus.completed, ExTripStatus.cancelled].contains(status);

String getTripStatusDescription(ExTripStatus status) =>
    tripStatusDescriptions[status] ?? status.toString();

class TripDataEntity {
  final ResolvedAddress from;
  final ResolvedAddress to;
  final Polyline polyline;
  final int distanceMeters;
  final String distanceText;
  ExTripStatus status;
  LatLngBounds mapLatLngBounds;
  CameraPosition? cameraPosition;

  TripDataEntity(
      {required this.from,
      required this.to,
      required this.polyline,
      required this.distanceMeters,
      required this.distanceText,
      required this.mapLatLngBounds,
      this.cameraPosition,
      this.status = ExTripStatus.submitted});
}
