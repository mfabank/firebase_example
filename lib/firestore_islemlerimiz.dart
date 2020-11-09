import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_example/yenisayfa.dart';
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
              onPressed: _veriSilme,
            ),
            RaisedButton(
              child: Text("Veri Oku"),
              color: Colors.blueGrey,
              onPressed: _veriGetir,
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

      if (haberVerileri.exists) {
        var mevcutPara = haberVerileri.data()["para"];

        if (haberVerileri.data()["para"] > 100) {
          duzeltilecekVeri.update(haberlerRef, {"para": mevcutPara - 100});
          duzeltilecekVeri.update(_firestore.doc("users/sehirler"),
              {"para": FieldValue.increment(100)});
        } else {
          debugPrint("Yetersiz Bakiye !!");
        }
      } else {
        debugPrint("Haberler boş");
      }
    });
  }

  void _veriSilme() {
    /*_firestore.doc("users/haberler").delete().then((value) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("İşlem Başarılı"),
              content: Text("İlgili kullanıcı bilgileri silindi"),
              backgroundColor: Colors.deepOrangeAccent,
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Tamam")),
              ],
            );
          });
    });*/
    _firestore.doc("users/haberler").update({"para" : FieldValue.delete()});
  }

  Future _veriGetir() async{
    DocumentSnapshot veriGetir = await _firestore.doc("users/haberler").get();

    DocumentReference veriDinle = _firestore.collection("users").doc("haberler");
    veriDinle.snapshots().listen((event) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => YeniSayfa(veri: event)));

    });



  }
}
