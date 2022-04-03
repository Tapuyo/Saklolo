import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:sakloloresident/RescuerHome/saklolo.dart';
import 'package:sakloloresident/main.dart';

class RescuerHomePage extends StatefulWidget {
  @override
  _RescuerHomePageState createState() => _RescuerHomePageState();
}

class _RescuerHomePageState extends State<RescuerHomePage> {

  String _token;
  Stream<String> _tokenStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(

          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  color: Colors.red,
                  height: 270,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  //sendNotif();
                                },
                                child: Icon(Feather.menu, color: Colors.white,size: 30,)),
                            Spacer(),
                            GestureDetector(
                              onTap: ()async{
                                await Hive.openBox('Mybox');
                                var box = Hive.box('Mybox');

                                box.put('uid', '');
                                box.put('name', '');
                                box.put('address', '');
                                box.put('email', '');
                                box.put('contact', '');
                                box.put('type', 'resident');
                                box.put('typeres', '');

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        MyHomePage())
                                );
                              },
                                child: Icon(Feather.log_out, color: Colors.white,size: 30,)),
                          ],
                        ),

                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 180,
                              child: Image.asset('assets/images/saklolowhite.png'),
                            ),
                          ],
                        ),

                      ),
                    ],
                  )
              ),
              SizedBox(height: 50,),
              Text('If you are on duty, click Get Started...'),
              SizedBox(height: 100,),
              Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async{
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  SakloloPage())
                          );
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

                                Text('Get Started',  style: TextStyle(color: Colors.white, letterSpacing: 1.0,
                                    fontFamily: "SanFrancisco", fontSize: 22, fontWeight: FontWeight.bold),
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
        ),

      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,

    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      // if (message != null) {
      //   Navigator.pushNamed(context, '/message',
      //       arguments: MessageArguments(message, true));
      // }
      print(message);
    });



    FirebaseMessaging.instance
        .getToken(
        vapidKey:
        'BGpdLRsMJKvFDD9odfPk92uBg-JbQbyoiZdah0XlUyrjG4SDgUsE1iC_kdRgt4Kn0CO7K3RTswPZt61NNuO0XoA')
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);

    FirebaseMessaging.instance.getToken().then((value){
      print("This is the token" + value);

    });


    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text(event.notification.body),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });


    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.subscribeToTopic('Toall');

  }

  void setToken(String token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
      print(_token);
    });
  }

  sendNotif() async{
    String token = 'key=AAAAA0STVGc:APA91bFfX2V8_7tNjAf8okElpIjlLMH29eK3oniGguGdUdmGBXZuogmRcu0O1kSgFfB3HC2OOlD6QfdTtZPNBdhyDHKEa8QAZ-yXk4dHxx1KikF1TT2hda_9LD7r-eYViZeJQGPqfW6S';
    Map<String, String> headers = {"Authorization": token,"Content-Type": "application/json"};
    Map map = {
      'data':{
        "to" : "/topics/Toall",
        "notification" : {
          "body" : "Body of Your Notification",
          "title": "Title of Your Notification"
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
