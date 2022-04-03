import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindRescuer extends StatefulWidget {
  String emid;
  FindRescuer(this.emid);
  @override
  _FindRescuerState createState() => _FindRescuerState(this.emid);
}

class _FindRescuerState extends State<FindRescuer> {
  String emid;
  _FindRescuerState(this.emid);
  Completer<GoogleMapController> _controller = Completer();
  bool loadingme = true;
  String name = '';
  String contact = '';
  String vehicle = '';
  String stat = 'open';

  @override
  void initState() {
    name = '';
    contact = '';
    vehicle = '';
    stat = 'open';
    super.initState();
    getcheck();


    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      getcheck();
    });

  }


  getcheck() async{

    await FirebaseFirestore.instance
        .collection('emergency')
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        if(doc.id == emid){
          print(doc.id);
          if(doc['response'] == 'none'){
            setState(() {
              loadingme = true;
            });
          }else{
            setState(() {
              stat = doc['status'];
              getRescuerInfo(doc['response']);
              loadingme = false;
            });
          }
        }
      })
    });

  }

  getRescuerInfo(String resid)async{
    print(resid);
    await FirebaseFirestore.instance
        .collection('rescuer')
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        if(doc.id == resid){
         setState(() {
            name = doc['name'];
            contact = doc['contact'];
            vehicle = doc['vehicle'];

         });
        }
      })
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
        actions: [

          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: (){
                getcheck();

              },
              child: Icon(Icons.refresh, color: Colors.white,size: 30,),
            ),
          )

        ],//J3X2p4b4IOEAn3l9lz54
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
              Text('Waiting for response....'),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesome.user_circle_o, color: Colors.black.withOpacity(.2),size: 150,),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Column(
                   children: [
                     ClipOval(
                       child: Material(
                         color: Colors.blueAccent, // button color
                         child: InkWell(
                           child: SizedBox(width: 40, height: 40, child: Icon(Feather.message_circle, color: Colors.white,)),
                           onTap: () {

                           },
                         ),
                       ),
                     ),
                     SizedBox(height: 5,),
                     Text('message',style: TextStyle(color: Colors.blueAccent),)
                   ],
                 ),
                  SizedBox(width: 30,),
                  Column(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.blueAccent, // button color
                          child: InkWell(
                            child: SizedBox(width: 40, height: 40, child: Icon(Icons.phone, color: Colors.white,)),
                            onTap: () {

                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text('call',style: TextStyle(color: Colors.blueAccent),)
                    ],
                  ),
                  SizedBox(width: 30,),
                  Column(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.blueAccent, // button color
                          child: InkWell(
                            child: SizedBox(width: 40, height: 40, child: Icon(Icons.video_call, color: Colors.white,)),
                            onTap: () {

                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text('video',style: TextStyle(color: Colors.blueAccent),)
                    ],
                  ),
                  SizedBox(width: 30,),
                  Column(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.blueAccent, // button color
                          child: InkWell(
                            child: SizedBox(width: 40, height: 40, child: Icon(Icons.star, color: Colors.white,)),
                            onTap: () {

                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text('rate',style: TextStyle(color: Colors.blueAccent),)
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              Divider(),
              SizedBox(height: 20,),
              Text('mobile',style: TextStyle(color: Colors.black),),
              SizedBox(height: 5,),
              Text(contact,style: TextStyle(color: Colors.blueAccent, fontSize: 18),),
              SizedBox(height: 10,),
              Text('Model & Plate #',style: TextStyle(color: Colors.black),),
              SizedBox(height: 5,),
              Text(vehicle,style: TextStyle(color: Colors.blueAccent, fontSize: 18),),
              SizedBox(height: 10,),
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
                height: MediaQuery.of(context).size.height / 2 ,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              )

            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: loadingme == true ? false:true,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async{
                  if(stat == 'complete'){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                    width: 256,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0),),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
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
                        textstat(),

                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  textstat(){
    if(stat == 'open'){
      return Text('5 mins to arrive',  style: TextStyle(color: Colors.blueAccent, letterSpacing: 1.0,
          fontFamily: "SanFrancisco", fontSize: 20),
        textAlign: TextAlign.center,
      );
    }else if(stat == 'coming'){
      return Text('Coming',  style: TextStyle(color: Colors.blueAccent, letterSpacing: 1.0,
          fontFamily: "SanFrancisco", fontSize: 20),
        textAlign: TextAlign.center,
      );
    }else if(stat == 'arrive'){
      return Text('Arrived',  style: TextStyle(color: Colors.blueAccent, letterSpacing: 1.0,
          fontFamily: "SanFrancisco", fontSize: 20),
        textAlign: TextAlign.center,
      );
    }else if(stat == 'complete'){
      return Text('Complete',  style: TextStyle(color: Colors.blueAccent, letterSpacing: 1.0,
          fontFamily: "SanFrancisco", fontSize: 20),
        textAlign: TextAlign.center,
      );
    }else{

    }

  }
}
