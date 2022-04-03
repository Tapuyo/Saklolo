import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sakloloresident/RescuerHome/successpage.dart';

class DonePage extends StatefulWidget {
  String uid,name,address;
  DonePage(this.uid,this.name,this.address);
  @override
  _SakloloPageState createState() => _SakloloPageState(this.uid,this.name,this.address);
}

class _SakloloPageState extends State<DonePage> {
  String uid,name,address;
  _SakloloPageState(this.uid,this.name,this.address);
  Completer<GoogleMapController> _controller = Completer();
  bool one = false;
  bool two = false;
  bool three = false;
  bool four = false;
  bool five = false;
  String remarks = '';
  String arrival = '';
  String completetime = '';
  File _image1;
  final picker = ImagePicker();
  final addremarks = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getMoreInfo();
    requestPermissions();
  }
  requestPermissions() async {
    if (await Permission.camera.request().isGranted) {

    }

// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,

    ].request();
    print(statuses[Permission.camera]);
  }
  getMoreInfo()async{

    await FirebaseFirestore.instance
        .collection('emergency')
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc)async{
        if(doc.id == uid){
          setState(() {
            arrival = doc['arrivetime'];
            completetime = doc['completetime'];
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
              child: Icon(Feather.menu, color: Colors.white,size: 30,),
            ),
          )

        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INCIDENT REPORT', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Row(
                children: [
                  Text('Name', style: TextStyle(fontSize: 20),),
                  SizedBox(width: 35,),
                  Text(name, style: TextStyle(fontSize: 20),),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text('Address', style: TextStyle(fontSize: 20),),
                    SizedBox(width: 20,),
                    Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(address, style: TextStyle(fontSize: 20),)),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text('Take a photo', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap:(){
                        getImage('gallery');
                        },
                        child: Icon(Icons.image, color: Colors.black, size: 50,)),
                    SizedBox(width: 10,),
                  ],
                ),
              ),
              Divider(),
              Row(
                children: [
                  Text('Time arrived:', style: TextStyle(fontSize: 20),),
                  SizedBox(width: 50,),
                  Text(arrival, style: TextStyle(fontSize: 20),),
                ],
              ),
              Row(
                children: [
                  Text('Accomplished:', style: TextStyle(fontSize: 20),),
                  SizedBox(width: 35,),
                  Text(completetime, style: TextStyle(fontSize: 20),),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Text('Status:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  Text('(put check to specify status)', style: TextStyle(fontSize: 14),),
                ],
              ),
              SizedBox(height: 10,),

               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         one = true;
                         two = false;
                         three = false;
                         four = false;
                         five = false;
                         remarks = 'Assisted in hospital';
                       });
                     },
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Icon(one == true ? Icons.circle:Feather.circle, color: one == true ? Colors.red:Colors.black,),
                         SizedBox(width: 5,),
                         Text('Assisted in hospital', style: TextStyle(fontSize: 14),),
                       ],
                     ),
                   ),
                   Spacer(),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         one = false;
                         two = false;
                         three = false;
                         four = true;
                         five = false;
                         remarks = 'For hospital transfer';
                       });
                     },
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Icon(four == true ? Icons.circle:Feather.circle, color: four == true ? Colors.red:Colors.black,),
                         SizedBox(width: 5,),
                         Text('For hospital transfer', style: TextStyle(fontSize: 14),),
                       ],
                     ),
                   ),
                 ],
               ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        one = false;
                        two = true;
                        three = false;
                        four = false;
                        five = false;
                        remarks = 'First Aid Done';
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(two == true ? Icons.circle:Feather.circle, color: two == true ? Colors.red:Colors.black,),
                        SizedBox(width: 5,),
                        Text('First Aid Done', style: TextStyle(fontSize: 14),),
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        one = false;
                        two = false;
                        three = false;
                        four = false;
                        five = true;
                        remarks = 'Under Control';
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(five == true ? Icons.circle:Feather.circle, color: five == true ? Colors.red:Colors.black,),
                        SizedBox(width: 5,),
                        Text('Under Control', style: TextStyle(fontSize: 14),),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    one = false;
                    two = false;
                    three = true;
                    four = false;
                    five = false;
                    remarks = 'Waiting for family member';
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(three == true ? Icons.circle:Feather.circle, color: three == true ? Colors.red:Colors.black,),
                    SizedBox(width: 5,),
                    Text('Waiting for family member', style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),

              SizedBox(height: 10,),
              Divider(),
              Text('Remarks', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Container(
                color: Colors.white,
                child: TextField(
                  controller: addremarks,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type remarks here.',
                    contentPadding: EdgeInsets.all(10),
                  ),
                  style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
                ),
              ),
              SizedBox(height: 200,),
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

                      Text('Submit Report',  style: TextStyle(color: Colors.white, letterSpacing: 1.0,
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

    if(_image1 == null){
      String ad = addremarks.text;
      FirebaseFirestore.instance.collection('emergency').doc(uid).update(
          {

            'response': ud,
            'status': 'complete',
            'backup': 'false',
            'remarks': remarks,
            'addremarks': ad

          })
          .then((value){
        sendNotif();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                SuccessPage())
        );
      });
    }else{
      final bytes = Io.File(_image1.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      String ad = addremarks.text;
      FirebaseFirestore.instance.collection('emergency').doc(uid).update(
          {

            'response': ud,
            'status': 'complete',
            'backup': 'false',
            'completeimage': img64,
            'remarks': remarks,
            'addremarks': ad

          })
          .then((value){
        sendNotif();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                SuccessPage())
        );
      });
    }


  }

  Future getImage(String source) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image1 = File(pickedFile.path);
        print(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });


  }

  sendNotif() async{
    String token = 'key=AAAAA0STVGc:APA91bFfX2V8_7tNjAf8okElpIjlLMH29eK3oniGguGdUdmGBXZuogmRcu0O1kSgFfB3HC2OOlD6QfdTtZPNBdhyDHKEa8QAZ-yXk4dHxx1KikF1TT2hda_9LD7r-eYViZeJQGPqfW6S';
    Map<String, String> headers = {"Authorization": token,"Content-Type": "application/json"};
    Map map = {
      'data':{
        "to" : "/topics/Toall",
        "notification" : {
          "body" : "Task is close",
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
