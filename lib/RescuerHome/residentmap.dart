import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sakloloresident/RescuerHome/arrivepage.dart';

class ResidentMap extends StatefulWidget {
  String uid,name,lati,longi,address;
  ResidentMap(this.uid,this.name,this.lati,this.longi,this.address);
  @override
  _FindRescuerState createState() => _FindRescuerState(this.uid,this.name,this.lati,this.longi,this.address);
}

class _FindRescuerState extends State<ResidentMap> {
  String uid,name,lati,longi,address;
  _FindRescuerState(this.uid,this.name,this.lati,this.longi,this.address);

  bool loadingme = false;
  final Map<String, Marker> _markers = {};
  String mylat = '';
  String mylongi = '';
  GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    //loadstate();
    requestPermissions();
  }
  loadstate()async{
    setState(() {
      loadingme = true;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      loadingme = false;
    });
    requestPermissions();
  }



  requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      _getLocation();
    }

// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
    ].request();
    print(statuses[Permission.location]);
  }

  _getLocation()async{
    //serviceEnabled = await Geolocator.isLocationServiceEnabled();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    mylat = position.latitude.toString();
    mylongi = position.longitude.toString();
    final marker = Marker(
      markerId: MarkerId('123'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
        snippet: 'Your location here.',
        title: 'Your location',
      ),
    );

    setState(() {
      _markers['mylocation'] = marker;
    });

    _loadEmergenycLocation();
  }

  _loadEmergenycLocation()async{
    //serviceEnabled = await Geolocator.isLocationServiceEnabled();

    final marker = Marker(
      markerId: MarkerId('345'),
      position: LatLng(double.parse(lati), double.parse(longi)),
      infoWindow: InfoWindow(
        snippet: 'Your location here.',
        title: 'Your location',
      ),
    );

    setState(() {
      _markers['emergencylocation'] = marker;
    });

    setState(() {

      _controller.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(double.parse(lati), double.parse(longi)), zoom: 10),));
    });
  }
  void _onMapCreated(GoogleMapController _ctrl) async{
    _controller = _ctrl;
  }
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: Center(child: new Text("SAKLOLO.PH",style: TextStyle(fontSize: 20, color: Colors.white),)),
        leading:  IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [

          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              child: Icon(Feather.menu, color: Colors.white,size: 30,),
            ),
          )

        ],
      ),
      body: SingleChildScrollView(
        child: loadingme == true ? Container(
          padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Column(
            children: [
              Center(
                  child: Icon(Icons.search_rounded, size: 200, color: Colors.black.withOpacity(.2),)
              ),
              SizedBox(height: 10,),
              CircularProgressIndicator(
                value: null,
                strokeWidth: 7.0,
              ),
            ],
          ),
        ):Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('FIRE ACCIDENT', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Text('ADDRESS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Text(address, style: TextStyle(fontSize: 16),),
              SizedBox(height: 20,),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  color: Colors.red.withOpacity(.2),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height ,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      myLocationEnabled: true,
                      markers: _markers.values.toSet(),
                      onMapCreated:_onMapCreated,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async{

                              },
                              child: Container(
                                  width: 256,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                    color: Colors.white,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.white,
                                    //     spreadRadius: 2,
                                    //     blurRadius: 10,
                                    //     offset: Offset(0, 3), // changes position of shadow
                                    //   ),
                                    // ],
                                  ),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                          ),
                                          color: Colors.blueAccent,
                                        ),
                                        width: 55,
                                        height: 55,
                                        child: Icon(Ionicons.ios_car,size: 30, color: Colors.white,),
                                      ),
                                      SizedBox(width: 20,),
                                      Text('5 mins to arrive',  style: TextStyle(color: Colors.blueAccent, letterSpacing: 1.0,
                                          fontFamily: "SanFrancisco", fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),

                                    ],
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              )

            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async{
                UpdateEmergency();
              },
              child: Container(
                  width: 256,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22.0),),
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text('Arrive',  style: TextStyle(color: Colors.white, letterSpacing: 1.0,
                          fontFamily: "SanFrancisco", fontSize: 26, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                    ],
                  )
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }


  UpdateEmergency()async{
    var box = Hive.box('Mybox');
    var ud = box.get('uid');
    final DateTime now = DateTime. now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm:ss');
    final String formatted = formatter.format(now);

    FirebaseFirestore.instance.collection('emergency').doc(uid).update(
        {

          'response': ud,
          'status': 'arrive',
          'arrivetime': formatted


        })
        .then((value){
      sendNotif();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              ArrivePage(uid,name,lati,longi,address))
      );
    });

  }

  sendNotif() async{
    String token = 'key=AAAAA0STVGc:APA91bFfX2V8_7tNjAf8okElpIjlLMH29eK3oniGguGdUdmGBXZuogmRcu0O1kSgFfB3HC2OOlD6QfdTtZPNBdhyDHKEa8QAZ-yXk4dHxx1KikF1TT2hda_9LD7r-eYViZeJQGPqfW6S';
    Map<String, String> headers = {"Authorization": token,"Content-Type": "application/json"};
    Map map = {
      'data':{
        "to" : "/topics/Toall",
        "notification" : {
          "body" : "Rescue is arrived",
          "title": "Saklolo"
        }
      },
    };
    var body = json.encode(map['data']);
    String url = 'https://fcm.googleapis.com/fcm/send';
    final response = await http.post(Uri.parse(url),headers: headers, body: body);
    //var jsondata = json.decode(response.headers);
    print(response.body.toString());
    if(response.statusCode == 200){

    }else{

    }
  }
}
