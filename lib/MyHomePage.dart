import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RagabPage.dart';
import 'OriflamePage.dart';
import 'contfirebase.dart';
import 'fav.dart';
import 'loginpage.dart';
class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yalla Sale',
      theme: ThemeData.dark(),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  QuerySnapshot content;
  QuerySnapshot contentproduct;
  Firecategory fcategory =new Firecategory();
  Fireproduct fproduct =new Fireproduct();
  FirebaseUser user;
  getUserdata() async{
    FirebaseUser userdata=await FirebaseAuth.instance.currentUser();
    setState((){
      user=userdata;
    });
    print(user.email);
  }
  @override
  void initState(){
    super.initState();
    getUserdata();

    fcategory.getcategory().then((data){
      setState(() {
        content = data;
      });
    });
    fproduct.getProduct().then((data){
      setState(() {
        contentproduct = data;
      });
    });

  }

  Widget Showcategory(){
    if(content!=null)
    {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(5.0),
        itemBuilder:(BuildContext context,index ){
          return Container(
            child: Column(
              children: <Widget>[
                circleAvatar("images/elc.jpg"),
                Text('${content.documents[index].data['name']}'),
              ],
            ),

          );
        }
        ,itemCount: content.documents.length,

      );
    }
    else if(content!=null&& content.documents.length==0){
      return Text("No data Avaliable");
    }
    else{
      return Text("Please wait its looding...");
    }

  }
  Widget ShowProduct() {
    if (contentproduct != null) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: contentproduct.documents.length,
        itemBuilder: (BuildContext context, index) {
          return  SizedBox(
            //height: 150,
            //width: 120,
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



  Color col= Colors.white ;
  Color col2= Colors.white ;
  Color col3= Colors.white ;
  bool fav =false;
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
                      child: Text('-' +" 35 " + '%',
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
          drawer: Drawer(
            elevation: 15,
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.greenAccent,
                          Colors.lightGreenAccent,
                        ],
                      ),
                      color: Colors.red[100],
                      image: DecorationImage(
                        image: AssetImage("images/project_logo.png"),
                      )),
                ),
                ListTile(
                  title: Text(
                    "Profile",
                    style: TextStyle(fontSize: 20),
                  ),
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
                ListTile(
                  title: Text("Notification", style: TextStyle(fontSize: 20)),
                  leading: Icon(Icons.notifications,
                      color: Colors.orangeAccent, size: 35),
                ),
                InkWell(
                  onTap: (){
                    if(fav == true){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyFav(card("images/Awlad_Ragab_logo.jpg","اولاد رجب "),card("images/oriflame_logo.jpg","ORIFLAME"))
                      ) );
                    }
                    else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyFav( Center(child: Text("NO Fav" ,style:TextStyle(fontSize: 20),)),Center(child: Text("YET" ,style:TextStyle(fontSize: 20),)), )));
                    }

                  },
                  child: ListTile(
                    title: Text("My Faviorate", style: TextStyle(fontSize: 20)),
                    leading: Icon(Icons.favorite, color: Colors.red, size: 35),
                  ),
                ),
                ListTile(
                  title: Text("Rate App", style: TextStyle(fontSize: 20)),
                  leading: Icon(Icons.star,
                      color: Colors.yellowAccent[200], size: 35),
                ),
                ListTile(
                  title: Text("About", style: TextStyle(fontSize: 20)),
                  leading:
                      Icon(Icons.info_outline, color: Colors.black54, size: 35),
                ),
                ListTile(
                  title: Text("Join Us", style: TextStyle(fontSize: 20)),
                  leading: Icon(Icons.contact_mail,
                      color: Colors.green[500], size: 35),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>LoginPage() ),);
                  },
                  child: ListTile(

                    title: Text("Log Out", style: TextStyle(fontSize: 20)),
                    leading: Icon(Icons.lock, color: Colors.black, size: 35),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text("Yalla Sale"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Row(
                    children: <Widget>[Icon(Icons.home,color:Colors.lightGreenAccent[400]), Text("Home")],
                  ),
                ),
                Tab(
                  child: Row(
                    children: <Widget>[Icon(Icons.shop_two,color:Colors.tealAccent), Text("Shop")],
                  ),
                ),
                Tab(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.whatshot,color:Colors.deepOrange ,),
                      Text("Best offers")
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[
            SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(
                  height: 150.0,
                  child: Showcategory(),
                ),
                Container(
                  height: 500,
                  child:ShowProduct(),
                ),


              ]),
            ),
            GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 14.0 / 20.0,
              children: <Widget>[
                Card(
                      child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OriflamePage()));
                          },
                          child:  Image.asset(
                          "images/oriflame_logo.jpg",
                        ),
                       ),
                         GestureDetector(
                          onDoubleTap: (){
                            setState(() {
                              fav=true;
                              col3=Colors.red;
                            });

                          },
                             child:Column(
                            children: <Widget>[
                              Text(
                                "ORIFLAME",
                                style: TextStyle(fontSize: 20),
                              ),
                              Icon(Icons.favorite ,color: col3),
                            ],
                          )

                         ),
                      ],
                    ),
                  ),

                card("images/Awlad_Ragab_logo.jpg","اولاد رجب") ,
                card2("images/alkot.jpg","القط") ,
                card2("images/citycreb.jpg","استي كريب") ,
                card2("images/comma.png","comma") ,
                card2("images/elmedan.jpg","كشري الميدان") ,
                card2("images/MB.jpg","MB") ,
                card2("images/amhassan.jpg","zigzag") ,
                card2("images/citycreb.jpg","استي كريب") ,
                card2("images/Awlad_Ragab_logo.jpg","اولاد رجب") ,
                card2("images/alkot.jpg","القط") ,
                card2("images/comma.png","comma") ,




              ],
            ),
            ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 100, bottom: 100),
                            padding: EdgeInsets.only(top: 100, bottom: 50),
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("غساله",style: TextStyle(color: Colors.black,fontSize: 30)),
                                Text("\$1500",style: TextStyle(color: Colors.black,fontSize: 20)),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 20),
                                  child: SmoothStarRating(
                                    allowHalfRating: false,
                                    onRatingChanged: (v) {
                                      setState(() {
                                        _rating = v;
                                      });
                                    },
                                    starCount: 5,
                                    rating: _rating,
                                    size: 27.0,
                                    color: Colors.orange,
                                    borderColor: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                      color: Color.fromRGBO(0, 0, 0, .05))
                                ]),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 200,
                            height: 160,
                            child: foodItem(
                                isProductPage: true,
                                onTapped: () {},
                                imgWidth: 250,
                                onLike: () {}),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 100, bottom: 100),
                            padding: EdgeInsets.only(top: 100, bottom: 50),
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("غساله",style: TextStyle(color: Colors.black,fontSize: 30)),
                                Text("\$1500",style: TextStyle(color: Colors.black,fontSize: 20)),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 20),
                                  child: SmoothStarRating(
                                    allowHalfRating: false,
                                    onRatingChanged: (v) {
                                      setState(() {
                                        _rating = v;
                                      });
                                    },
                                    starCount: 5,
                                    rating: _rating,
                                    size: 27.0,
                                    color: Colors.orange,
                                    borderColor: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                      color: Color.fromRGBO(0, 0, 0, .05))
                                ]),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 200,
                            height: 160,
                            child: foodItem(
                                isProductPage: true,
                                onTapped: () {},
                                imgWidth: 250,
                                onLike: () {}),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 100, bottom: 100),
                            padding: EdgeInsets.only(top: 100, bottom: 50),
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("غساله",style: TextStyle(color: Colors.black,fontSize: 30)),
                                Text("\$1500",style: TextStyle(color: Colors.black,fontSize: 20)),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 20),
                                  child: SmoothStarRating(
                                    allowHalfRating: false,
                                    onRatingChanged: (v) {
                                      setState(() {
                                        _rating = v;
                                      });
                                    },
                                    starCount: 5,
                                    rating: _rating,
                                    size: 27.0,
                                    color: Colors.orange,
                                    borderColor: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                      color: Color.fromRGBO(0, 0, 0, .05))
                                ]),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 200,
                            height: 160,
                            child: foodItem(
                                isProductPage: true,
                                onTapped: () {},
                                imgWidth: 250,
                                onLike: () {}),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 100, bottom: 100),
                            padding: EdgeInsets.only(top: 100, bottom: 50),
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("غساله",style: TextStyle(color: Colors.black,fontSize: 30)),
                                Text("\$1500",style: TextStyle(color: Colors.black,fontSize: 20)),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 20),
                                  child: SmoothStarRating(
                                    allowHalfRating: false,
                                    onRatingChanged: (v) {
                                      setState(() {
                                        _rating = v;
                                      });
                                    },
                                    starCount: 5,
                                    rating: _rating,
                                    size: 27.0,
                                    color: Colors.orange,
                                    borderColor: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                      color: Color.fromRGBO(0, 0, 0, .05))
                                ]),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 200,
                            height: 160,
                            child: foodItem(
                                isProductPage: true,
                                onTapped: () {},
                                imgWidth: 250,
                                onLike: () {}),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 100, bottom: 100),
                            padding: EdgeInsets.only(top: 100, bottom: 50),
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("غساله",style: TextStyle(color: Colors.black,fontSize: 30)),
                                Text("\$1500",style: TextStyle(color: Colors.black,fontSize: 20)),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 20),
                                  child: SmoothStarRating(
                                    allowHalfRating: false,
                                    onRatingChanged: (v) {
                                      setState(() {
                                        _rating = v;
                                      });
                                    },
                                    starCount: 5,
                                    rating: _rating,
                                    size: 27.0,
                                    color: Colors.orange,
                                    borderColor: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                      color: Color.fromRGBO(0, 0, 0, .05))
                                ]),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 200,
                            height: 160,
                            child: foodItem(
                                isProductPage: true,
                                onTapped: () {},
                                imgWidth: 250,
                                onLike: () {}),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 100, bottom: 100),
                            padding: EdgeInsets.only(top: 100, bottom: 50),
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("غساله",style: TextStyle(color: Colors.black,fontSize: 30)),
                                Text("\$1500",style: TextStyle(color: Colors.black,fontSize: 20)),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 20),
                                  child: SmoothStarRating(
                                    allowHalfRating: false,
                                    onRatingChanged: (v) {
                                      setState(() {
                                        _rating = v;
                                      });
                                    },
                                    starCount: 5,
                                    rating: _rating,
                                    size: 27.0,
                                    color: Colors.orange,
                                    borderColor: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                      color: Color.fromRGBO(0, 0, 0, .05))
                                ]),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 200,
                            height: 160,
                            child: foodItem(
                                isProductPage: true,
                                onTapped: () {},
                                imgWidth: 250,
                                onLike: () {}),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),



              ],
            )
          ])),
    );
  }



  Widget card (String img ,String text ){
    return Card (
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RagabPage()));
            },
            child: Image.asset( img ),
          ),
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                fav = true;
                col=Colors.red;
              });

            },
            child: Column(
              children: <Widget>[
                Text(
                  text ,
                  style: TextStyle(fontSize: 20),
                ),
                Icon(Icons.favorite,color: col,),
              ],
            ),

          )
        ],
      ),
    );
  }
  Widget card2 (String img ,String text ){
    return Card (
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RagabPage()));
            },
            child: Image.asset( img ),
          ),
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                fav = true;
                col2=Colors.red;
              });

            },
            child: Column(
              children: <Widget>[
                Text(
                  text ,
                  style: TextStyle(fontSize: 20),
                ),
                Icon(Icons.favorite,color: col2,),
              ],
            ),

          )
        ],
      ),
    );
  }
}
