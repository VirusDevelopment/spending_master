import 'package:expencetracker/models/expenceModel.dart';
import 'package:expencetracker/utils/database_helper.dart';
import 'package:expencetracker/UIpages/expenceUI.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expencetracker/widgets/drawer.dart';
import 'package:sqflite/sqflite.dart';

class HomePageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePageUI> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ExpenceModel> expenceLists;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (expenceLists == null) {
      expenceLists = List<ExpenceModel>();
      getExpenceListElement();
    }
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Home Virus"), backgroundColor: Colors.orange),
      drawer: new Mydrawer(),
      body: _getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToExpencePage(
              context, new ExpenceModel(DateTime.now().toString(), "",1, ""));
        },
        child: Icon(Icons.add),
        tooltip: "Add new Expence",
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  String getpaymentModeText(int cats) {
    switch (cats) {
      case 1:
        return 'Cash';
        break;
      case 2:
        return 'Credit Card';
        break;
      case 3:
        return 'Debit Card';
        break;
      default:
        return "";
    }
  }

  void _delete(BuildContext context, ExpenceModel _expence) async {
    int result = await databaseHelper.deleteexpenceMap(_expence.id);
    if (result != 0) {
      _showMySnackbar(context, "Expence Deleted Successfully");
      getExpenceListElement();
    }
  }

  void getExpenceListElement() async {
    debugPrint("List getExpenceListElement");
    final Future<Database> dbfuture = databaseHelper.initializeDatabase();
    dbfuture.then((database) {
      Future<List<ExpenceModel>> expenceList = databaseHelper.getexpenceList();
      expenceList.then((expence) {
        setState(() {
          this.expenceLists = expence;
          this.count = expence.length;
        });
      });
    });
  }

  Widget _getListView() {
    var listview = Card(
        color: Colors.white,
        elevation: 6,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
if(index < this.expenceLists.length){
              return ListTile(
                leading: Icon(FontAwesomeIcons.moneyBillWave,
                    color: Colors.lightGreen),
                title: Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: getpaymentModeText(this.expenceLists[index].paymentMode),
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "   -   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: this.expenceLists[index].amount),
                        ],
                      ),
                    )
                  ],
                ),
                subtitle:
                    Text(this.expenceLists[index].expencedatetime.toString()),
                trailing: GestureDetector(
                    child: Icon(Icons.delete, color: Colors.grey),
                    onTap: () {
                      _delete(context, this.expenceLists[index]);
                    }),
                onTap: () {
                  _navigateToExpencePage(context, this.expenceLists[index]);
                },
              );
            }
          },
        ));
    return listview;
  }

  void _navigateToExpencePage(
      BuildContext context, ExpenceModel paramValue) async {
    var result = Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => ExpenceEntryUI(paramValue)));
    if (result == true) {
      getExpenceListElement();
    }
  }

  void _showMessage(BuildContext context, String title, String message) {
    var dialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void _showMySnackbar(BuildContext context, String message) {
    var snackbar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
          _showMessage(context, message, message);
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
