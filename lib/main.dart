import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sakloloresident/RescuerHome/rescuehomepage.dart';
import 'package:sakloloresident/homepage/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saklolo Resident',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Saklolo Resident App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final txtName = TextEditingController();
  final txtAdd = TextEditingController();
  final txtBdate = TextEditingController();
  final txtGender = TextEditingController();
  final txtEmail = TextEditingController();
  final txtContact = TextEditingController();

  final resUser = TextEditingController();
  final resPass = TextEditingController();
  bool loading = false;
  String usertype = 'none';


  requestPermissions() async {
    if (await Permission.storage.request().isGranted) {

    }

// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [

      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
  }


  @override
  void initState() {

    super.initState();


    usertype = 'none';
    requestPermissions();
    _initHive();
  }

  Future _initHive() async {

    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    checkinout();
  }

  checkinout()async{
    await Hive.openBox('Mybox');
    var box = Hive.box('Mybox');
    var uid = box.get('name');
    var mtype = box.get('type');
    print('Name: $uid');
    if(uid == '' || uid == null){
      setState(() {
        loading = true;
      });
    }else{
      if(mtype == 'resident'){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>
                HomePage(uid))
        );
      }else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>
                RescuerHomePage())
        );
      }

    }
  }

  bodypage(){
    if(usertype == 'none'){
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      color: Colors.transparent,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        child: Image.asset('assets/images/saklolowhite.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  GestureDetector(
                    onTap: () async{
                     setState(() {
                       usertype = 'resident';
                     });
                    },
                    child: Container(
                        width: 256,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22.0),),
                          color: Colors.white,
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

                            Text('Resident',  style: TextStyle(color: Colors.red, letterSpacing: 1.0,
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
            SizedBox(height: 20,),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async{
                      setState(() {
                        usertype = 'rescuer';
                      });

                    },
                    child: Container(
                        width: 256,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22.0),),
                          color: Colors.white,
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

                            Text('Rescuer',  style: TextStyle(color: Colors.red, letterSpacing: 1.0,
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
          ],
        ),
      );
    }else if(usertype == 'resident'){
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 30,),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                color: Colors.transparent,
              ),
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/saklolowhite.png'),
                ),
              ),
            ),
            Text('Register', style: TextStyle(color: Colors.white, fontSize: 25),),
            SizedBox(height: 15,),
            Container(
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
                controller: txtName,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name',
                  contentPadding: EdgeInsets.all(10),
                ),
                style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
              ),
            ),
            SizedBox(height: 5,),
            Container(
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
                controller: txtAdd,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Address',
                  contentPadding: EdgeInsets.all(10),
                ),
                style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
              ),
            ),
            SizedBox(height: 5,),
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
                      controller: txtBdate,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Birthday',
                        contentPadding: EdgeInsets.all(10),
                      ),
                      style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
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
                      controller: txtGender,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Gender',
                        contentPadding: EdgeInsets.all(10),
                      ),
                      style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Container(
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
                controller: txtEmail,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',
                  contentPadding: EdgeInsets.all(10),
                ),
                style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
              ),
            ),
            SizedBox(height: 5,),
            Container(
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
                controller: txtContact,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Contact No.',
                  contentPadding: EdgeInsets.all(10),
                ),
                style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Icon(Icons.camera_alt, color: Colors.white, size: 50,),
                  SizedBox(width: 10,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 10,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.add, color: Colors.white, size: 35,),
                ],
              ),
            )
          ],
        ),
      );
    }else{
      return Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //SizedBox(height: 50,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                color: Colors.transparent,
              ),
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/saklolowhite.png'),
                ),
              ),
            ),
            Text('Sign in', style: TextStyle(color: Colors.white, fontSize: 25),),
            SizedBox(height: 15,),
            Container(
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
                controller: resUser,

                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Username',
                  contentPadding: EdgeInsets.all(10),
                ),
                style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
              ),
            ),
            SizedBox(height: 15,),
            Container(
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
                controller: resPass,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Password',
                  contentPadding: EdgeInsets.all(10),
                ),
                style: TextStyle(color: Colors.black, letterSpacing: 1.0, fontSize: 16),
              ),
            ),
            SizedBox(height: 5,),

          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: loading == false ?  Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Text('loading ... ',style: TextStyle(color: Colors.white),),
          ),
        ):Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Container(
            child: Column(
              children: [
                Visibility(
                  visible: usertype == 'none' ? false:true,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              usertype = 'none';
                            });
                          },
                          child: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
                        ),
                      ],
                    ),
                  ),
                ),
                bodypage(),
              ],
            ),
          )
        ),
      ),
      floatingActionButton: Visibility(
        visible: loading,
        child: floatbtn(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  floatbtn(){
    if(usertype == 'none'){
      return Container();
    }else if(usertype == 'resident'){
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async{
                pasteCollection();
                //getRouteCopy();

              },
              child: Container(
                  width: 256,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22.0),),
                    color: Colors.white,
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

                      Text('Submit',  style: TextStyle(color: Colors.red, letterSpacing: 1.0,
                          fontFamily: "SanFrancisco", fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                    ],
                  )
              ),
            )
          ],
        ),
      );
    }else{
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async{

                loginrescuer();
              },
              child: Container(
                  width: 256,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22.0),),
                    color: Colors.white,
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

                      Text('Submit',  style: TextStyle(color: Colors.red, letterSpacing: 1.0,
                          fontFamily: "SanFrancisco", fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                    ],
                  )
              ),
            )
          ],
        ),
      );
    }
  }

  loginrescuer()async{
    String username = resUser.text;
    String userpass = resPass.text;
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('rescuer')
        .where('userName',isEqualTo: username)
        .where('userPassword',isEqualTo: userpass)
        .get();

    final List < DocumentSnapshot > documents = result.docs;
    print(documents.length);
    if(documents.length > 0){
      await FirebaseFirestore.instance
          .collection('rescuer')
          .where('userName',isEqualTo: username)
          .where('userPassword',isEqualTo: userpass)
          .get()
          .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc)async{
      //  await Hive.openBox('Mybox');
        print(doc.id);
        var box = Hive.box('Mybox');

        box.put('uid', doc.id);
        box.put('name',doc['name']);
        box.put('address', '');
        box.put('email', '');
        box.put('contact', doc['contact']);
        box.put('type', 'rescuer');
        box.put('typeres', doc['type']);


        })
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>
              RescuerHomePage())
      );
    }
  }

  getRouteCopy() async{

    await FirebaseFirestore.instance
        .collection('sample')
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        print(doc.id);
      })
    });

  }


  pasteCollection()async{


    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .add({
      'Name': txtName.text,
      'Address': txtAdd.text,
      'Bdate': txtBdate.text,
      'Gender': txtGender.text,
      'Email': txtEmail.text,
      'Contact': txtContact.text
    }).then((value)async{
      await Hive.openBox('Mybox');
      var box = Hive.box('Mybox');

      box.put('uid', value.id);
      box.put('name', txtName.text);
      box.put('address', txtAdd.text);
      box.put('email', txtEmail.text);
      box.put('contact', txtContact.text);
      box.put('type', 'resident');
      box.put('typeres', '');

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>
              HomePage(value.id))
      );
    });
  }
}
