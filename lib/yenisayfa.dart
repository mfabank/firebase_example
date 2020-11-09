import 'package:flutter/cupertino.dart';
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
      appBar: AppBar(
        title: Text("Veri Tabanı verileri"),
        centerTitle: true,
        backgroundColor:Colors.blueGrey,
      ),
      body: Container(

            child: ListView.builder(itemCount: 1,itemBuilder: (context, index) {
              return Card(
                color: Colors.blueGrey,
                shadowColor: Colors.red,
                child: ListTile(
                  title: Text(widget.veri.data()['haber basligi']),
                  subtitle: Text(widget.veri.data()["para"].toString()),
                  trailing: Icon(Icons.done),
                ),
              );
            },),


      ),
    );
  }
}
