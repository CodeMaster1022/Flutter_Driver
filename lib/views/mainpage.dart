import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:kenorider_driver/common/colormanager.dart';
import 'package:kenorider_driver/common/textcontent.dart';
import 'package:kenorider_driver/views/arrivedpickuppage.dart';
import 'package:kenorider_driver/views/earninghistorypage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late GoogleMapController mapController;
  late LatLng _currentPosition;
  late Marker _currentLocationMarker;
  bool _locationInitialized = false;
  bool _isOnline = false;
  bool _isReqest = false;

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
        _locationInitialized = true;// Set _isLoading to false when the position is determined
      });
      // Future.delayed(Duration(seconds: 6), () {
      //   showDialog(
      //     context: context,
      //     builder: (context) => RideRequestDialog(),
      //   );
      // });
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

  void _onPressedOnlineButton(){
    setState(() {
      _isOnline = !_isOnline;
      _isReqest = true;
    });
    // showDialog(
    //   context: context,
    //   builder: (context) => RideRequestDialog(),
    // );
  }

  void _onPressedHistoryButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> EarningHistoryPage()));
  }

  void _onPressedDeclineButton(){
    setState(() {
      _isReqest = false;
    });
  }

  void _onPressedAcceptButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ArrivePickupPointPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if(_locationInitialized)
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 16.0,
              ),
              markers: {_currentLocationMarker},
            ),
          if(_isReqest)
            Container(
               color: Colors.black.withOpacity(0.4),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child : Column(
                  children: [
                    SizedBox(height: 40,),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Credit Balance',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '\$30.00',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Image.asset(Apptext.profileAvatarImage, width: 55, height: 55,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1), // Set the border color and width
                                borderRadius: BorderRadius.circular(20), // Set the border radius
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4,),
                                  Text(
                                    '5.0',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
                
              ),
            ),
          ),
          _isReqest ?
          Positioned(
            bottom: 20,
            left: 20,
            right: 20, 
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ride Request!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$30.00',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'John Pierce',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child:Row(
                          children: [
                            SizedBox(width: 5,),
                            Icon(Icons.star, color: Colors.yellow),
                            Text('5.0', style: TextStyle(fontSize: 16, color: Colors.black54)),
                            SizedBox(width: 10,)
                          ],
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 30,
                        margin: EdgeInsets.only(right: 8),
                        child: Column(
                           children: [
                            Image.asset(Apptext.fromLocationIconImage),
                            SizedBox(height: 5,),
                            Image.asset(Apptext.betweenIconImage),
                            Image.asset(Apptext.betweenIconImage),
                            Image.asset(Apptext.betweenIconImage),
                            SizedBox(height: 5,),
                            Image.asset(Apptext.toLocationIconImage),
                           ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From',
                              style: TextStyle(color: ColorManager.primary_color, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Spe Ornamental Corp',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Row(
                              children: [
                                Text("3 min"),
                                SizedBox(width: 2,),
                                Text("(1.8km)", style: TextStyle(color: ColorManager.primary_color),)
                              ],
                            ),
                            Text(
                              '2136 SW 5th St, Miami, FL 33135, United States',
                              style: TextStyle(color: Colors.black54, fontSize: 15),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'To',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Miami Senior High School',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Row(
                              children: [
                                Text("12 min"),
                                SizedBox(width: 2,),
                                Text("(4.2km)", style: TextStyle(color: ColorManager.primary_color),)
                              ],
                            ),
                            Text(
                              '2450 SW 1st St, Miami, FL 33135, United States',
                              style: TextStyle(color: Colors.black54, fontSize: 15),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _onPressedDeclineButton,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary_gery_color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          ),
                          child: Text('Decline', style: TextStyle(color: Colors.black),),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _onPressedAcceptButton,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    ColorManager.dark_primary_color,
                                    ColorManager.primary_color,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                  maxHeight: 50, 
                                  minHeight: 50, 
                                  maxWidth: double.infinity,
                                ),
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text(
                                      Apptext.acceptButtonText,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ) 
          : Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2), // Semi-transparent background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _onPressedOnlineButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                ColorManager.dark_primary_color,
                                ColorManager.primary_color,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              maxHeight: 50, 
                              minHeight: 50, 
                              maxWidth: double.infinity,
                            ),
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                  _isOnline ? 'Go Online' : "Off line",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8), // Space between text and icon
                                Image.asset(Apptext.powerIconImage, width: 24, height: 24,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onPressedHistoryButton,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                      child: Text(
                        'History',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(!_isReqest)
            Positioned(
              right: 16,
              bottom: 100,
              child: Column(  
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      mapController.animateCamera(
                        google_maps.CameraUpdate.zoomIn(),
                      );
                    },
                    child: Icon(Icons.zoom_in),
                  ),
                  SizedBox(height: 5),
                  FloatingActionButton(
                    onPressed: () {
                      mapController.animateCamera(
                        google_maps.CameraUpdate.zoomOut(),
                      );
                    },
                    child: Icon(Icons.zoom_out),
                  ),
                ],
              ),
            ),

          if (!_locationInitialized)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Fetching current location...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
