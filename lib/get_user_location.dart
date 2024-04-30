import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserLocation extends StatefulWidget {
  final VoidCallback onLocationUpdate; // Callback function to trigger on location update

  const GetUserLocation({super.key, required this.onLocationUpdate});

  @override
  State<GetUserLocation> createState() => _GetUserLocationState();
}

class _GetUserLocationState extends State<GetUserLocation> {

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _initialPosition = CameraPosition(
      target: LatLng(0.3338, 32.5514), zoom: 14.0
  );

  final List<Marker> myMarker = [];
  final List<Marker> markerList = const[
    Marker(markerId: MarkerId("First"),
        position: LatLng(0.3987, 32.4793),
        infoWindow: InfoWindow(
          title: "My Home",
        )
    ),
  ];

  @override
  void initState(){
    // Todo : Implement initState
    super.initState();
    myMarker.addAll(markerList);
    // packData()
  }

  Future<Position> getUserLocation() async{
    await Geolocator.requestPermission().then((value)
    {

    }).onError((error, stackTrace){
      print('error$error');
    });

    return Geolocator.getCurrentPosition();
  }

  Future<void> packData() async {
    getUserLocation().then((value) async {
      print('My Location');
      print('${value.latitude} ${value.longitude}');

      setState(() {
        myMarker.add(
          Marker(
            markerId: const MarkerId('Second'),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: const InfoWindow(
              title: 'Current Location',
            ),
          ),
        );
      });

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // Trigger the callback function when the location is updated
      widget.onLocationUpdate();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          markers: Set<Marker>.of(myMarker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // Method getting current location for user
          packData();
        },
        child: const Icon(Icons.radio_button_off),
      ),
    );
  }
}
