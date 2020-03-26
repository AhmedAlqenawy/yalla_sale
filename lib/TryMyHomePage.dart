import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grafpix/pixbuttons/medal.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RagabPage.dart';
import 'OriflamePage.dart';
import 'contfirebase.dart';
import 'fav.dart';
import 'loginpage.dart';

class Home2 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yalla Sale',
      theme: ThemeData.dark(),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: MyHomePage2(),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {
  QuerySnapshot content;
  Firecategory fshop = new Firecategory();
  QuerySnapshot contentproduct;
  Fireproduct fproduct = new Fireproduct();

  FirebaseUser user;
  getUserdata() async {
    FirebaseUser userdata = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userdata;
    });
    print(user.email);
  }

  @override
  void initState() {
    super.initState();
    getUserdata();

    fshop.getcategory().then((data) {
      setState(() {
        content = data;
      });
    });
    fproduct.getProduct().then((data) {
      setState(() {
        contentproduct = data;
      });
    });
  }

  Widget ShowShop() {
    if (content != null) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (BuildContext context, index) {
          return Container(
            child: Column(
              children: <Widget>[
                circleAvatar("images/elc.jpg"),
                Text('${content.documents[index].data['name']}'),
              ],
            ),
          );
        },
        itemCount: content.documents.length,
      );
    } else if (content != null && content.documents.length == 0) {
      return Text("No data Avaliable");
    } else {
      return Text("Please wait its looding...");
    }
  }

  //circleAvatar("images/elc.jpg"),
  //Text('${contentproduct.documents[index].data['name']}'),
  Widget ShowProduct() {
    if (contentproduct != null) {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: contentproduct.documents.length,
        itemBuilder: (BuildContext context, index) {
          return  SizedBox(
              height: 150,
              width: 120,
              child: Card(
                  elevation: 10.0,
                  child: Column(children: <Widget>[
                    circleAvatar("images/computer.jpg"),
                    Text('${contentproduct.documents[index].data['name']}'),
                    Text('${contentproduct.documents[index].data['price']}'),
                  ])),
            );
        },
      );
    } else if (contentproduct != null && contentproduct.documents.length == 0) {
      return Text("No data Avaliable");
    } else {
      return Text("Please wait its looding...");
    }
  }

  Widget ShowProduct1() {
    if (contentproduct != null) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (BuildContext context, index) {
          if (index % 4 == 0) {
            print(index);
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    width: 120,
                    child: Card(
                        elevation: 10.0,
                        child: Column(children: <Widget>[
                          circleAvatar("images/computer.jpg"),
                          Text("coomputer"),
                          Text("12.500"),
                        ])),
                  ),
                ]);
          } else {
            return SizedBox(
              height: 150,
              width: 120,
              child: Card(
                  elevation: 10.0,
                  child: Column(children: <Widget>[
                    Image.asset("images/computer.jpg"),
                    Text('${contentproduct.documents[index].data['name']}'),
                    Text('${contentproduct.documents[index].data['price']}'),
                  ])),
            );
          }
        },
        itemCount: contentproduct.documents.length,
      );
    } else if (contentproduct != null && contentproduct.documents.length == 0) {
      return Text("No data Avaliable");
    } else {
      return Text("Please wait its looding...");
    }
  }

  Color col = Colors.white;
  Color col2 = Colors.white;
  Color col3 = Colors.white;
  bool fav = false;
  Padding circleAvatar(String pic) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: CircleAvatar(
        backgroundImage: AssetImage("$pic"),
        radius: 40.0,
      ),
    );
  }

  Widget foodItem(
      {double imgWidth, onLike, onTapped, bool isProductPage = false}) {
    return Container(
      width: 180,
      height: 180,
      // color: Colors.red,
      margin: EdgeInsets.only(left: 20),
      child: Stack(
        children: <Widget>[
          Container(
              width: 180,
              height: 180,
              child: RaisedButton(
                  color: Colors.white,
                  elevation: (isProductPage) ? 20 : 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: onTapped,
                  child: Hero(
                      transitionOnUserGestures: true,
                      tag: "food.name",
                      child: Image.asset("images/project_logo.png",
                          width: (imgWidth != null) ? imgWidth : 100)))),
          Positioned(
            bottom: 100,
            right: 0,
            child: FlatButton(
              padding: EdgeInsets.all(20),
              shape: CircleBorder(),
              onPressed: onLike,
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: (!isProductPage)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("food.name"),
                      Text("food.price"),
                    ],
                  )
                : Text(' '),
          ),
          Positioned(
              top: 10,
              left: 10,
              child: (true != null)
                  ? Container(
                      padding: EdgeInsets.only(
                          top: 5, left: 10, right: 10, bottom: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(50)),
                      child: Text('-' + " 35 " + '%',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    )
                  : SizedBox(width: 0))
        ],
      ),
    );
  }

  var _rating = 4.0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: ShowProduct(),
      ),
    );
  }
}
