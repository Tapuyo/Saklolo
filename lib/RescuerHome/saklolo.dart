import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakloloresident/RescuerHome/resident.dart';

class SakloloPage extends StatefulWidget {

  @override
  _SakloloPageState createState() => _SakloloPageState();
}

class _SakloloPageState extends State<SakloloPage> {
  Future _emfuture;
  List<EmergencyHelp> myEmergency = [];


  @override
  void initState() {
    super.initState();
    myEmergency = [];
    _emfuture = getEmergency();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      myEmergency = [];
      _emfuture = getEmergency();

    });

  }

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


  Future<List<EmergencyHelp>> getEmergency()async{
    myEmergency = [];
    await FirebaseFirestore.instance
        .collection('emergency').where('status',isEqualTo: 'open')
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc)async{
        print(doc.id);
        EmergencyHelp _em = new EmergencyHelp(doc.id, doc['name'], doc['address'], doc['type'], doc['date'],doc['contact'],doc['lati'],doc['longi'],doc['image']);

        myEmergency.add(_em);

      })
    });

    return myEmergency;
  }

  mybody(){
    return Container(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
          future: _emfuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if (myEmergency.length <= 0) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(FontAwesome5.smile, color: Colors.red, size: 70,),
                      SizedBox(height: 20,),
                      Text('All clear',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red),),
                    ],
                  ),
                );
              }else{
                return ListView.builder(
                  //physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    itemBuilder: (context, index){
                      return  Container(
                        padding: EdgeInsets.fromLTRB(0,0,0,10),
                        child: Card(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        ResidentPage(snapshot.data[index].id,snapshot.data[index].name,snapshot.data[index].address,snapshot.data[index].contact,snapshot.data[index].lati,snapshot.data[index].longi,snapshot.data[index].image))
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                  color: Colors.black12.withOpacity(.2),
                                ),
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data[index].name, style: TextStyle(color: Colors.black, fontSize: 18),),
                                    SizedBox(height: 15,),
                                    Text(snapshot.data[index].address, style: TextStyle(color: Colors.black.withOpacity(.5), fontSize: 16),),
                                    SizedBox(height: 5,),
                                    Text(snapshot.data[index].type, style: TextStyle(color: Colors.red.withOpacity(.9), fontSize: 16),),
                                    SizedBox(height: 5,),
                                    Text(snapshot.data[index].datetime, style: TextStyle(color: Colors.black.withOpacity(.5), fontSize: 16),),
                                  ],
                                ),
                              ),
                            ),
                          ),

                      );
                    }
                );

              }
            }else{
              return Container(
                child: Center(
                  child: Text('loading.'),
                ),
              );
            }

          }

      ),
    );
  }

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
        child: mybody()
      ),
      floatingActionButton: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async{
                myEmergency = [];
                _emfuture = getEmergency();
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

                      Text('Refresh',  style: TextStyle(color: Colors.white, letterSpacing: 1.0,
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
}

class EmergencyHelp{
  final String id;
  final String name;
  final String address;
  final String type;
  final String datetime;
  final String contact;
  final String lati;
  final String longi;
  final String image;

  EmergencyHelp(this.id,this.name,this.address,this.type,this.datetime,this.contact,this.lati,this.longi,this.image);
}
