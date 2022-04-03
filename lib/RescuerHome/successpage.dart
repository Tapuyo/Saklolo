import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakloloresident/RescuerHome/rescuehomepage.dart';

class SuccessPage extends StatefulWidget {
  @override
  _FindRescuerState createState() => _FindRescuerState();
}

class _FindRescuerState extends State<SuccessPage> {
  Completer<GoogleMapController> _controller = Completer();
  bool loadingme = true;

  @override
  void initState() {
    super.initState();
    loadstate();
  }
  loadstate()async{
    setState(() {
      loadingme = true;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      loadingme = false;
    });
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

      ),
      body: SingleChildScrollView(
        child: loadingme == true ? Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Column(
            children: [

              SizedBox(height: 10,),
              CircularProgressIndicator(
                value: null,
                strokeWidth: 7.0,
              ),
              SizedBox(height: 20,),
              Text('Submiting your report', style: TextStyle(fontSize: 16),),

            ],
          ),
        ):Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Icon(Icons.check_circle, size: 200, color: Colors.green,),
              SizedBox(height: 50,),
              Text('Report Submitted!!!', style: TextStyle(fontSize: 16),),
               SizedBox(height: 50,),
              GestureDetector(
                onTap: () async{
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          RescuerHomePage())
                  );
                },
                child: Container(
                    width: 256,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(22.0),),
                      color: Colors.green,
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

                        Text('DONE',  style: TextStyle(color: Colors.white, letterSpacing: 1.0,
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
      ),

    );
  }
}
