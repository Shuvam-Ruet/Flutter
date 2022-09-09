import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:myapp/pages/income.dart';
//import 'package:myapp/pages/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class May extends StatefulWidget {
  @override
  _MayState createState() => _MayState();
}

class _MayState extends State<May> {
  int totalIncome = 0;
  totalmoney() async {
    int total = 0;
    var snapshot = await Firestore.instance.collection("Mayi").getDocuments();

    setState(() {
      if (snapshot == null) totalIncome = 0;
      snapshot.documents.forEach((doc) {
        total += int.parse(doc.data['income']);
      });
      totalIncome = total;
    });
  }

  void initState() {
    this.totalmoney();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Income in May"),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("Mayi").snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Loading"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (_, index) {
                DocumentSnapshot data = snapshot.data.documents[index];
                return Card(
                  child: ListTile(
                    leading: Text(data["income"],
                        style: TextStyle(color: Colors.green, fontSize: 40)),
                    title: Text(data["Source"],
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    subtitle: Text(data["DateTime"],
                        style: TextStyle(color: Colors.grey, fontSize: 20)),
                    trailing: Icon(Icons.money),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Container(
          color: Colors.grey[300],
          child: ListTile(
            title: Text('        Total Income In May',
                style: TextStyle(color: Colors.black, fontSize: 22)),
            subtitle: Text("                       ${totalIncome}",
                style: TextStyle(color: Colors.green, fontSize: 22)),
          )),
    );
  }
}
