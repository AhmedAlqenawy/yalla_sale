import 'package:flutter/material.dart';
class MyFav extends StatelessWidget {
  Widget card ;
  Widget card2 ;
  MyFav( this.card, this.card2);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fav',
      theme: ThemeData.dark(),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Fav( card ,card2),
    );
  }
}

class Fav extends StatefulWidget {
  Widget card ;
  Widget card2 ;
  Fav(this. card, this. card2);
  @override
  _FavState createState() => _FavState(card ,card2);
}

class _FavState extends State<Fav> {
   Widget card ;
   Widget card2;
  _FavState(this. card, this. card2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:AppBar(
      title: Text('Fav'),
    ) ,
      body: Column(
        children: <Widget>[
          card ,
        ],
      ),
    );
  }
}
