import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Firecategory {
  bool auth() {
    return FirebaseAuth.instance.currentUser() != null ? true : false;
  }

  Future<void> CreateOrAddcategory(data) async{
    if(auth()){
      Firestore.instance.collection('category').add(data);
    }
  }
  getcategory() async{
    return await  Firestore.instance.collection('category').getDocuments();
  }


}
class Fireproduct {
  bool auth() {
    return FirebaseAuth.instance.currentUser() != null ? true : false;
  }


  Future<void> CreateOrAddSroduct(data) async{
    if(auth()){
      Firestore.instance.collection('shop').add(data);
    }
  }

  getProduct() async{
    return await  Firestore.instance.collection('product').getDocuments();
  }

}