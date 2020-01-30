import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String url = 'http://userapi.tk/';

  List contactList;

  @override
  void initState() {
    super.initState();
    getContactList();
  }

  Future getContactList() async
  {
    var response = await http.get(Uri.encodeFull(url));

    setState(() {
      var converted = json.decode(response.body);
      contactList = converted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact app"),
      ),
      body: 
        contactList == null
        ? Center(
          child: CircularProgressIndicator(),
        )
        : ListView.builder(
        itemCount: contactList.length,
        itemBuilder: (_, index) => Dismissible(
          key: UniqueKey(),
        
          direction: DismissDirection.horizontal,
          onDismissed: (direction) async
          {
            
            if (direction == DismissDirection.startToEnd) 
            {
              // left to right drag
              await launch("tel:${this.contactList[index]['Mobile']}");
              setState(() {});
            }
            else if (direction == DismissDirection.endToStart)
            {
              // right to left drag
              await launch("sms:${this.contactList[index]['Mobile']}");
              setState(() {});
            }
          },
          background: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(15),
            color: Colors.green,
            child: Icon(
              Icons.call,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(15),
            color: Colors.blue,
            child: Icon(
              Icons.message,
              color: Colors.white,
            ),
          ),
          child: Card(
            child: ListTile(
              title: Text(contactList[index]['Name']),
              subtitle: Text(contactList[index]['Mobile']),
            ),
          ),
        ),
      ),
    );
  }
}