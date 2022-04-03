import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sakloloresident/homepage/saklolopage.dart';
import 'package:hive/hive.dart';
import 'package:sakloloresident/main.dart';

class HomePage extends StatefulWidget {
  String uid;
  HomePage(this.uid);
  @override
  _HomePageState createState() => _HomePageState(this.uid);
}

class _HomePageState extends State<HomePage> {
  String uid;
  _HomePageState(this.uid);

  String _token;
  Stream<String> _tokenStream;

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
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text("Notification"),
      //         content: Text(event.notification.body),
      //         actions: [
      //           TextButton(
      //             child: Text("Ok"),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           )
      //         ],
      //       );
      //     });
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
                          Icon(FontAwesome.user_circle_o, color: Colors.white,size: 30,),
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
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        height:  MediaQuery.of(context).size.width / 2 - 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          color: Colors.black.withOpacity(.2),
                        ),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    SakloloPage('Request Medical Assistance'))
                            );
                          },
                          child: Container(
                            width: 10,
                            height: 10,
                            padding: EdgeInsets.fromLTRB(30, 30, 30, 20),
                            child: Image.asset('assets/images/med.png'),
                          ),
                        ),


                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        height:  MediaQuery.of(context).size.width / 2 - 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          color: Colors.black.withOpacity(.2),
                        ),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    SakloloPage('Request Fire Truck'))
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Image.asset('assets/images/fire.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        height:  MediaQuery.of(context).size.width / 2 - 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          color: Colors.black.withOpacity(.2),
                        ),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    SakloloPage('Request Ambulance'))
                            );
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            child: Image.asset('assets/images/ambul.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        height:  MediaQuery.of(context).size.width / 2 - 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          color: Colors.black.withOpacity(.2),
                        ),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    SakloloPage('Request Police Response'))
                            );
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            child: Image.asset('assets/images/pulis.png'),
                          ),
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
    );
  }
}
