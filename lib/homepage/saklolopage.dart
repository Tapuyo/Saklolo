import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sakloloresident/homepage/findrescuer.dart';

class SakloloPage extends StatefulWidget {
  String wht;
  SakloloPage(this.wht);
  @override
  _SakloloPageState createState() => _SakloloPageState(this.wht);
}

class _SakloloPageState extends State<SakloloPage> {
  String wht;
  _SakloloPageState(this.wht);
  Completer<GoogleMapController> _controller = Completer();
  double lati = 37.42796133580664;
  double longi = -122.085749655962;
  File _image;
  final Map<String, Marker> _markers = {};
  final txtAddress = TextEditingController();
  final txtIns = TextEditingController();
  final picker = ImagePicker();
  GoogleMapController _gcontroller;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    loaddetails();
  }
  loaddetails()async{
    await Hive.openBox('Mybox');
    var box = Hive.box('Mybox');
    var uid = box.get('address');
    print('Address: $uid');
    if(uid != '' || uid != null){
      setState(() {
        txtAddress.text = uid;
      });
    }else{
      setState(() {
        txtAddress.text = '';
      });
    }
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
    lati = position.latitude;
    longi = position.longitude;
    final marker = Marker(
      markerId: MarkerId('123'),
      position: LatLng(lati, longi),
      infoWindow: InfoWindow(
        snippet: 'Your location here.',
        title: 'Your location',
      ),
    );

    _markers['location123'] = marker;
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
              Text(wht, style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Text('INPUT DETAILS'),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: txtAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your address here',
                          contentPadding: EdgeInsets.all(10),
                        ),
                        style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      color: Colors.red.withOpacity(.2),
                    ),
                    width: 100,
                    height: 40,
                    child: Center(
                      child: Text('Change'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: txtIns,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Special instruction',
                          contentPadding: EdgeInsets.all(10),
                        ),
                        style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text('PHOTO',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  Text('(optional)')
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  GestureDetector(
                      onTap: (){
                        getImage('Camera');
                      },
                      child: Icon(Icons.camera_alt,size: 40,color: Colors.black.withOpacity(.5),)),
                  SizedBox(width: 10,),
                  Text('or'),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: (){
                      getImage('Gallery');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        color: Colors.red.withOpacity(.2),
                      ),
                      width: 150,
                      height: 40,
                      child: Center(
                        child: Text('Upload Photo'),
                      ),
                    ),
                  ),
                ],
              ),
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
                  onMapCreated:_onMapCreated,
                  markers: _markers.values.toSet(),
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

                pasteCollection();
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

                      Text('SAKLOLO!',  style: TextStyle(color: Colors.white, letterSpacing: 1.0,
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
  Future getImage(String source) async {

    if(source == "Gallery"){
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }else{
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }

  }
  void _onMapCreated(GoogleMapController _ctrl) async{
    _gcontroller = _ctrl;

    _gcontroller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(lati, longi), zoom: 14)),);
  }


  pasteCollection()async{
    await Hive.openBox('Mybox');
    var box = Hive.box('Mybox');
    var uid = box.get('uid');
    var name = box.get('name');
    var cont = box.get('contact');
    final DateTime now = DateTime. now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm:ss');
    final String formatted = formatter.format(now);
    final bytes = Io.File(_image.path).readAsBytesSync();

    String img64 = base64Encode(bytes);

    CollectionReference users = FirebaseFirestore.instance.collection('emergency');
    return users
        .add({
      'uid': uid,
      'address': txtAddress.text,
      'instruction': txtIns.text,
      'date': formatted,
      'active': 'true',
      'backup': 'false',
      'needed': 1,
      'status': 'open',
      'response': 'none',
      'lati': lati.toString(),
      'longi': longi.toString(),
      'type': wht,
      'image': img64,
      'name': name,
      'contact': cont

    }).then((value)async{
      sendNotif(txtAddress.text,name,wht,txtIns.text);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              FindRescuer(value.id))
      );
    });
  }

  sendNotif(String address,name,type,note) async{
    String token = 'key=AAAAA0STVGc:APA91bFfX2V8_7tNjAf8okElpIjlLMH29eK3oniGguGdUdmGBXZuogmRcu0O1kSgFfB3HC2OOlD6QfdTtZPNBdhyDHKEa8QAZ-yXk4dHxx1KikF1TT2hda_9LD7r-eYViZeJQGPqfW6S';
    Map<String, String> headers = {"Authorization": token,"Content-Type": "application/json"};
    Map map = {
      'data':{
        "to" : "/topics/Toall",
        "notification" : {
          "body" : name + " need a " + type + " at " + address + ", note: " + note,
          "title": "Alert " + type
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
