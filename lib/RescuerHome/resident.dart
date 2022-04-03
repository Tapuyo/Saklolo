import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:sakloloresident/RescuerHome/residentmap.dart';
import 'package:url_launcher/url_launcher.dart';

class ResidentPage extends StatefulWidget {
  String id,name,address,contact,lati,longi,image;
  ResidentPage(this.id,this.name,this.address,this.contact,this.lati,this.longi,this.image);
  @override
  _FindRescuerState createState() => _FindRescuerState(this.id,this.name,this.address,this.contact,this.lati,this.longi,this.image);
}

class _FindRescuerState extends State<ResidentPage> {
  String id,name,address,contact,lati,longi,image;
  _FindRescuerState(this.id,this.name,this.address,this.contact,this.lati,this.longi,this.image);

  Completer<GoogleMapController> _controller = Completer();
  bool loadingme = false;

  @override
  void initState() {
    super.initState();
    //loadstate();
    //getMoreInfo();
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
              Container(
                child: Center(child: Text(address, style: TextStyle(fontSize: 14),textAlign: TextAlign.center,)),
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
                              String uri = 'sms:' + contact + '?body=rescue is coming.';
                              launch(uri);
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
                              launch("tel://" + contact);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text('call',style: TextStyle(color: Colors.blueAccent),)
                    ],
                  ),

                ],
              ),
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
                height: MediaQuery.of(context).size.height / 2 ,
                child: image != '' ? Image.memory(base64Decode(image), fit: BoxFit.cover, gaplessPlayback: true):Container(child: Center(child: Text('No image'),),)
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

                      Text('Go Now',  style: TextStyle(color: Colors.white, letterSpacing: 1.0,
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
    var uid = box.get('uid');
    var myname = box.get('name');

    FirebaseFirestore.instance.collection('emergency').doc(id).update(
        {

          'response': uid,
          'status': 'coming',


        })
        .then((value){
      sendNotif();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              ResidentMap(id,name,lati,longi,address))
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
          "body" : "Rescue is coming",
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
