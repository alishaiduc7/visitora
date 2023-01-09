import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:visitora/components/constants.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

import 'package:visitora/widgets/custom_circular_indicator.dart';
import 'package:visitora/widgets/custom_info_window.dart';

class MapScreen extends StatefulWidget {
  MapScreen({this.listOfSights, Key? key}) : super(key: key);
  List<QueryDocumentSnapshot?>? listOfSights;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  LatLng? currentPosition;
  Set<Marker> markers = {};

  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _sourceLocation =
      LatLng(47.027350299999995, 21.900644276364012);
  static const LatLng _destinationLocation =
      LatLng(47.052632450000004, 21.952924434127375);
  static const LatLng _moskivitsMiksaPalace = LatLng(47.0588609, 21.9350419);
  static const LatLng _sinagogaNeologaSion =
      LatLng(47.0549221, 21.932401249999998);
  static const LatLng _primariaOradea =
      LatLng(47.055993599999994, 21.9278426689081);
  static const LatLng _zooOradea = LatLng(47.0496347, 21.916554275389114);
  static const LatLng _casaDarvas = LatLng(47.0560639, 21.9325403);

  static const LatLng _1decParc = LatLng(47.0530092, 21.93551942671266);
  static const LatLng _muzeulIstorieiEvreilor = LatLng(47.0570631, 21.92316395);
  static const LatLng _bisericaCuLuna = LatLng(47.053698, 21.929004684752417);
  static const LatLng _oradeaCoordinates = LatLng(47.0746904, 21.8674043);
  static const _initialCameraPosition = CameraPosition(
    target: _sourceLocation,
    zoom: 11,
  );

  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    if (currentPosition != null) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          apiKey,
          PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
          PointLatLng(_bisericaCuLuna.latitude, _bisericaCuLuna.longitude),
          wayPoints: [
            PolylineWayPoint(
                location: "${_1decParc.latitude},${_1decParc.longitude}")
          ],
          travelMode: TravelMode.walking);

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    }
    setState(() {});
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high);
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      markers.add(
        Marker(
            markerId: const MarkerId('12'),
            position: currentPosition!,
            infoWindow: const InfoWindow(title: 'My location')),
      );

      if (currentPosition != null) {
        getPolyPoints();
      }
    });
  }

//TODO: get marker color
  // BitmapDescriptor _getMarkerColor() {

  // }

  @override
  Widget build(BuildContext context) {
    int index, i = 0;
    for (index = 0; index < widget.listOfSights!.length; index++) {
      markers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        markerId: MarkerId('${widget.listOfSights![index]!['title']}'),
        position: LatLng(double.parse(widget.listOfSights![index]!['latitude']),
            double.parse(widget.listOfSights![index]!['longitude'])),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              CustomMarkerWindow(),
              LatLng(double.parse(widget.listOfSights![i]!['latitude']),
                  double.parse(widget.listOfSights![i]!['longitude'])));
          i++;
        },
      ));
    }

    List<LatLng> latLng = [];
    widget.listOfSights!.forEach((element) {
      latLng.add(LatLng(double.parse(element!.get('latitude')),
          double.parse(element.get('longitude'))));
    });
    print(markers.iterator);
    return Scaffold(
        body: currentPosition != null
            ? Stack(
                children: [
                  GoogleMap(
                    markers: markers,
                    initialCameraPosition: const CameraPosition(
                        target: _oradeaCoordinates, zoom: 12),
                    //polylines: polylineCoordinates,
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: polylineCoordinates,
                        color: Colors.blue,
                        width: 6,
                      ),
                    },
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _customInfoWindowController.googleMapController =
                          controller;
                    },
                    onTap: (position) {
                      latLng.forEach((element) {
                        if (element.latitude.compareTo(position.latitude) ==
                                0 &&
                            element.longitude.compareTo(position.longitude) ==
                                0) {
                          _customInfoWindowController.addInfoWindow!(
                              CustomMarkerWindow(), position);
                          _customInfoWindowController.hideInfoWindow!();
                        }
                      });
                    },
                    onCameraMove: (position) {
                      _customInfoWindowController.onCameraMove!();
                    },
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 75,
                    width: 150,
                    offset: 50,
                  ),
                ],
              )
            : const CustomLoadingIndicator());
  }
}
