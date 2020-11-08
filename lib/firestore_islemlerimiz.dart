import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CloudFirestore extends StatefulWidget {
  @override
  _CloudFirestoreState createState() => _CloudFirestoreState();
}

class _CloudFirestoreState extends State<CloudFirestore> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Firestore Örnekleri"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              child: Text("Veri Ekle"),
              color: Colors.deepPurpleAccent,
              onPressed: _veriEkle,
            ),
            RaisedButton(
              child: Text("Veri Güncelleme/Dengeleme"),
              color: Colors.amberAccent,
              onPressed: _veriDengele,
            ),
            RaisedButton(
              child: Text("Veri Silme"),
              color: Colors.blueGrey,
              //onPressed: _veriDengele,
            ),
          ],
        ),
      ),
    );
  }

  void _veriEkle() {
    Map<String, dynamic> veriYaz = Map();

    veriYaz["haber basligi"] = "spor";
    veriYaz["para"] = 1000;

    _firestore
        .collection("users")
        .doc("haberler")
        .set(veriYaz)
        .then((value) => debugPrint("Eklendi"));
    _firestore
        .collection("users")
        .doc("sehirler")
        .set(veriYaz)
        .then((value) => debugPrint("Eklendi"));
  }

  void _veriDengele() {
    final DocumentReference haberlerRef = _firestore.doc("users/haberler");
    _firestore.runTransaction((duzeltilecekVeri) async {
      DocumentSnapshot haberVerileri = await haberlerRef.get();

      if (haberVerileri.exists){

        var mevcutPara = haberVerileri.data()["para"];

        if(haberVerileri.data()["para"]>100){

          duzeltilecekVeri.update(haberlerRef, {"para" : mevcutPara-100});
          duzeltilecekVeri.update(_firestore.doc("users/sehirler"), {"para" : FieldValue.increment(100)});
        }
        else{
          debugPrint("Yetersiz Bakiye !!");
        }


      }
      else
        {
          debugPrint("Haberler boş");
        }
    });
  }
}
