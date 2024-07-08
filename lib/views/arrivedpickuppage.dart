import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:kenorider_driver/common/colormanager.dart';
import 'package:kenorider_driver/common/textcontent.dart';
import 'package:kenorider_driver/views/starttrippage.dart';

class ArrivePickupPointPage extends StatefulWidget {
  @override
  _ArrivePickupPointPageState createState() => _ArrivePickupPointPageState();
}

class _ArrivePickupPointPageState extends State<ArrivePickupPointPage> {
  late GoogleMapController mapController;
  late LatLng _currentPosition;
  late Marker _currentLocationMarker;
  bool _locationInitialized = false;

  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _currentLocationMarker = Marker(
          markerId: MarkerId("current_location"),
          position: _currentPosition,
          icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(google_maps.BitmapDescriptor.hueBlue),
        );
        _locationInitialized = true;
      });
    }).catchError((e) {
      print("Error getting location: $e");
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 18.0));
  }

  void _onPressedArrivedButton() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => StartTripPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_locationInitialized)
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 16.0,
              ),
              markers: {_currentLocationMarker},
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: ColorManager.primary_white_color,
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child : Column(
                  children: [
                    SizedBox(height: 40,),
                    Row(
                      children: [
                        Image.asset(Apptext.fromLocationIconImage),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spe Ornamental Corp',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '2136 SW 5th St, Miami, FL 33135, United States',
                              style: TextStyle(fontSize: 15, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Colors.grey, width: 1.0),
              ),
              color: ColorManager.primary_white_color,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(Apptext.riderAvatarImage),
                          radius: 25,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Pierce',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text("On the way - 3 min", style: TextStyle(fontSize: 15, color: Colors.black54),),
                                Text(" (1.8km)", style: TextStyle(fontSize: 15, color: ColorManager.primary_color, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Add padding for spacing
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Wrap content
                              children: [
                                Text(
                                  'Text your passenger',
                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(width: 8), // Space between text and icon
                                Image.asset(Apptext.messageIconImage),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary_color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Add padding for spacing
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Wrap content
                                children: [
                                  Text(
                                    'Call',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 8), // Space between text and icon
                                  Icon(Icons.call, color: Colors.white,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey, width: 1),
                          color: Colors.white
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Payment Type',
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                              Spacer(),
                              Image.asset(Apptext.creditCardIconImage),
                              SizedBox(width: 5,),
                              Text(
                                'CREDIT',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text(
                                'Fare Total',
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                              Spacer(),
                              Text(
                                '\$12.08',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _onPressedArrivedButton,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary_white_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: ColorManager.primary_color, width: 1),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Center(
                        child: Text(
                          'Arrived at Pickup Point',
                          style: TextStyle(fontSize: 18, color: ColorManager.primary_color),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
