import 'package:expencetracker/models/expenceModel.dart';
import 'package:flutter/material.dart';
import 'package:expencetracker/UIpages/expenceUI.dart';
import 'package:expencetracker/UIpages/HomeUI.dart';

class Mydrawer extends StatefulWidget {
  @override
  _MydrawerState createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new Container(
            color: Colors.orange,
            child: new Column(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: new Text('Rakesh'),
                  accountEmail: new Text('rakeisharam@gmail.com'),
                  currentAccountPicture: new CircleAvatar(
                      backgroundImage: new NetworkImage(
                          'https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto/gigs/98381915/original/9a98da91fcc1709763e92016d13756af640abcb7/design-minimalist-flat-line-vector-avatar-of-you.jpg')),
                )
              ],
            ),
          ),
          Divider(height: 10.0, color: Theme.of(context).primaryColor),
          new Container(
            color: Colors.orange,
            child: new Column(
                children: <Widget>[
                                 ListTile(
                  leading: new Icon(Icons.info),
                  title: new Text('Home'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>  HomePageUI()));
                  }),
                  Divider(height: 10.0, color: Theme.of(context).primaryColor),
                   ListTile(
                  leading: new Icon(Icons.info),
                  title: new Text('Expence'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>  ExpenceEntryUI(new ExpenceModel(DateTime.now() .toString(), "",1, ""))));
                  })
                ]
            ),
          ),
        ],
      ),
    );
  }
}
