
import 'package:flutter/material.dart';
import 'package:taximan/api/google_api.dart';
import 'package:taximan/types/resolved_address.dart';
import 'package:taximan/ui/address_search.dart';
import 'package:taximan/providers/location.dart';
import 'package:taximan/ui/common.dart';

import 'package:google_maps_webservice/places.dart';
import 'package:lottie/lottie.dart';

class LocationScaffold extends StatelessWidget {
  LocationScaffold({Key? key}) : super(key: key);

  final demoAddressPikine = ResolvedAddress(
      location: Location(lat: 40.748558, lng: -73.9879518),
      mainText: "Centre de formation xaral, Pikine",
      secondaryText: "PK 10001, Sénégal");

  final demoAddressMermoz = ResolvedAddress(
      location: Location(lat: 51.5007292, lng: -0.1268194),
      mainText: "UVS, Dakar",
      secondaryText: "MZ1A 0AA, Sénégal");

  final demoAddressParis = ResolvedAddress(
      location: Location(lat: 48.8752611, lng: 2.2878047),
      mainText: "Arc de Triomphe, Paris",
      secondaryText: "75008 France");

  void _setDemoLocation(BuildContext context, ResolvedAddress address) {
    final locProvider = LocationProvider.of(context, listen: false);
    locProvider.currentAddress = address;
    showScaffoldSnackBarMessage(
        '${address.mainText} was set as a current location.');
  }

  void _selectCurrentLocation(BuildContext context) async {
    final Prediction? prd = await showSearch<Prediction?>(
        context: context, delegate: AddressSearch(), query: '');

    if (prd != null) {
      PlacesDetailsResponse placeDetails = await apiGooglePlaces
          .getDetailsByPlaceId(prd.placeId!, fields: [
        "address_component",
        "geometry",
        "type",
        "adr_address",
        "formatted_address"
      ]);

      final address = ResolvedAddress(
          location: placeDetails.result.geometry!.location,
          mainText: prd.structuredFormatting?.mainText ??
              placeDetails.result.addressComponents.join(','),
          secondaryText: prd.structuredFormatting?.secondaryText ?? '');

      final locProvider = LocationProvider.of(context, listen: false);
      locProvider.currentAddress = address;
      showScaffoldSnackBarMessage(
          '${address.mainText} a été défini comme emplacement actuel.');

      showScaffoldSnackBarMessage(
          placeDetails.result.geometry?.location.lat.toString() ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool pendingDetermineLocation =
        LocationProvider.of(context).pendingDetermineCurrentLocation;
    return buildAppScaffold(
        context,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left : 64, top : 8),
              child: Text(
                "Taximan demo",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Expanded(child: Lottie.asset('assets/lottie/taxi-animation.json')),
            if (pendingDetermineLocation) ...[
              const LinearProgressIndicator(),
              const Text('Veuillez patienter pendant que votre position soit déterminée....'),
            ],
            if (!pendingDetermineLocation) ...[
              Text(
                'Choisissez votre emplacement',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('SicapMbao, Sénégal'),
                subtitle: const Text("Centre de formation xarala"),
                onTap: () => _setDemoLocation(context, demoAddressPikine),
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Mermoz, Sénégal'),
                subtitle: const Text("UVS"),
                onTap: () => _setDemoLocation(context, demoAddressMermoz),
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Paris, France'),
                subtitle: const Text("Arc de Triomphe"),
                onTap: () => _setDemoLocation(context, demoAddressParis),
                trailing: const Icon(Icons.chevron_right),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Rechercher la localisation par nom'),
                onTap: () => _selectCurrentLocation(context),
              ),
              ListTile(
                leading: const Icon(Icons.gps_fixed),
                title: const Text('Determiner ma location par GPS'),
                onTap: () => LocationProvider.of(context, listen: false)
                    .determineCurrentLocation(),
              )
            ],
          ]),
        ),
        isLoggedIn: false);
  }
}
