import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YeniSayfa extends StatefulWidget {

  DocumentSnapshot veri;

  YeniSayfa({this.veri});


  @override
  _YeniSayfaState createState() => _YeniSayfaState();
}

class _YeniSayfaState extends State<YeniSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(widget.veri.data()["haber basligi"]),
            Text(widget.veri.data()["para"].toString()),
          ],
        ),
      ),
    );
  }
}
