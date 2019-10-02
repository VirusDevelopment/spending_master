import 'package:expencetracker/models/expenceModel.dart';
import 'package:expencetracker/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expencetracker/widgets/drawer.dart';

class ExpenceEntryUI extends StatefulWidget {
  final TextEditingController controller = new TextEditingController();
  final String name;
  final String id;
  final ExpenceModel dtsource;
  ExpenceEntryUI(this.dtsource, {Key key, this.name = 'unnamed', this.id})
      : super(key: key) {
    controller.text = '';
  }

  @override
  State<StatefulWidget> createState() {
    return new _ExpenceEntry(dtsource);
  }
}

class _ExpenceEntry extends State<ExpenceEntryUI> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  String titleName;
  ExpenceModel dtsource;
  _ExpenceEntry(this.dtsource) {
    if (dtsource.id == null) {
      titleName = "Add Expence Entry";
    } else {
      titleName = "Edit Expence Entry";
    }
  }
  Map<String, dynamic> formData;
  var _paymentModeList = ["Cash", "Credit Card", "Debit Card"];
  GlobalKey<FormState> _formkeyvalue = new GlobalKey<FormState>();
  GlobalKey<FormState> _formkeyvalue1 = new GlobalKey<FormState>();
  TextEditingController dateInputController = new TextEditingController(
      text:
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
  TextEditingController amounttext = new TextEditingController();
  TextEditingController categorytext = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    amounttext.text = dtsource.amount;
    categorytext.text = dtsource.category;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(titleName),
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _navigatetoBack(context);
            },
          ),
        ),
/* ---------------- Drawer Start ---------------------- */
        drawer: new Mydrawer(),
/* ---------------- Drawer End ---------------------- */
        body: new Form(
          child: new ListView(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[
/* ---------------- DateTime Picker Start ---------------------- */
              Container(
                padding: EdgeInsets.only(left: 0, right: 32.0, top: 8.0),
                child: new Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          _showDatePicker(this.dtsource.expencedatetime);
                        },
                        child: Icon(Icons.date_range),
                      ),
                    ),
                    Container(
                      child: new Flexible(
                          child: new TextField(
                              onTap: () {
                                _showDatePicker(this.dtsource.expencedatetime);
                                return false;
                              },
                              focusNode: NoKeyboardEditableTextFocusNode(),
                              decoration: InputDecoration(
                                  hintText: "Date",
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 10.0, 10.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                              maxLines: 1,
                              controller: dateInputController)),
                    ),
                  ],
                ),
              ),
/* ---------------- DateTime Picker End ---------------------- */
              Divider(height: 10.0, color: Theme.of(context).primaryColor),
/* ---------------- TextFiels Category Start ---------------------- */
              TextFormField(
                  key: _formkeyvalue1,
                  keyboardType: TextInputType.text,
                  validator: (String value) {
                    return value.isEmpty ? "Please Category" : null;
                  },
                  onFieldSubmitted: (String value) {
                    setState(() {
                      this.dtsource.category = value;
                    });
                  },
                  controller: categorytext,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    icon: Icon(FontAwesomeIcons.moneyBillWave,color: Colors.lightGreen),
                    hintText: 'Enter Category',
                    labelText: 'Category',
                    errorStyle: TextStyle(color: Colors.redAccent, decorationColor: Colors.red),
                    contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )),
/* ---------------- TextFiels Category End ---------------------- */
              Divider(height: 10.0, color: Theme.of(context).primaryColor),
/* ---------------- DropDownList PaymentMode Start ---------------------- */
              Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(Icons.account_balance),
                ),
                DropdownButton<String>(
                    hint: Text("Select Payment Mode"),
                    elevation: 6,
                    items: _paymentModeList.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem));
                    }).toList(),
                    value: getpaymentModeText(),
                    onChanged: (String value) {
                      if (value == "" || value == null) {
                        return 'Please enter some text';
                      } else {
                        setState(() {
                          updatepaymentModeText(value);
                        });
                        return null;
                      }
                    })
              ]),
/* ---------------- DropDownList PaymentMode End ---------------------- */
              Divider(height: 10.0, color: Theme.of(context).primaryColor),
/* ---------------- TextFiels Amount Start ---------------------- */
              TextFormField(
                  key: _formkeyvalue,
                  keyboardType: TextInputType.number,
                  validator: (String value) {
                    return value.isEmpty ? "Please enter amount" : null;
                  },
                  onFieldSubmitted: (String value) {
                    setState(() {
                      this.dtsource.amount = value;
                    });
                  },
                  controller: amounttext,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    icon: Icon(FontAwesomeIcons.moneyCheck,
                        color: Colors.lightGreen),
                    hintText: 'Enter Expence',
                    labelText: 'Expence',
                    errorStyle: TextStyle(
                        color: Colors.redAccent, decorationColor: Colors.red),
                    contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )),
/* ---------------- TextFiels Amount End ---------------------- */
              Divider(height: 10.0, color: Theme.of(context).primaryColor),
/* ---------------- Save/ Delete button Start ---------------------- */
              Center(
                      child: Row(children: <Widget>[
                    MaterialButton(
                      minWidth: 95,
                      height: 42.0,
                      onPressed: () {
                        setState(() {
                          _save(context);
                        });
                      },
                      color: Colors.orangeAccent,
                      child:
                          Text("Save", style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: MaterialButton(
                        minWidth: 95,
                        height: 42.0,
                        onPressed: () {
                          setState(() {
                            _delete(context);
                          });
                        },
                        color: Colors.orangeAccent,
                        child: Text("Delete",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ])),
/* ---------------- Save/ Delete button Start ---------------------- */
            ],
          ),
        ));
  }

  void _save(BuildContext context) async {
    _navigatetoBack(context);
    if (this.dtsource.id == null) {
      var result = await databaseHelper.insertexpenceMap(this.dtsource);
      if (result != 0) {
        _showMySnackbar(context,
            result != 0 ? "Saved Successfully" : "Some Problem occured");
      }
    } else {
      var result = await databaseHelper.updateexpenceMap(this.dtsource);
      _showMySnackbar(context,
          result != 0 ? "Updated Successfully" : "Some Problem occured");
    }
  }

  void _delete(BuildContext context) async {
    _navigatetoBack(context);
    if (this.dtsource.id == null) {
      return;
    } else {
      var result = await databaseHelper.deleteexpenceMap(this.dtsource.id);
      _showMySnackbar(
          context, result != 0 ? "Deleted Successfully" : "No Record Deleted");
    }
  }

  String getpaymentModeText() {
    switch (this.dtsource.paymentMode) {
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

  void updatepaymentModeText(String cats) {
    switch (cats) {
      case 'Cash':
        this.dtsource.paymentMode = 1;
        break;
      case 'Credit Card':
        this.dtsource.paymentMode = 2;
        break;
      case 'Debit Card':
        this.dtsource.paymentMode = 3;
        break;
      default:
        this.dtsource.paymentMode = 0;
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

  void _navigatetoBack(BuildContext context) {
    Navigator.pop(context, true);
  }

  Future<Null> _showDatePicker(String dt) async {
    final int year = int.parse(dt.split("/")[2]);
    final int month = int.parse(dt.split("/")[1]);
    final int day = int.parse(dt.split("/")[0]);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(year, month, day),
        firstDate: DateTime(DateTime.now().year - 1, 1),
        lastDate: DateTime(DateTime.now().year, 12));

    if (picked != null) {
      setState(() {
        this.dtsource.expencedatetime =
            "${picked.day}/${picked.month}/${picked.year}";
        dateInputController = new TextEditingController(
            text: "${picked.day}/${picked.month}/${picked.year}");
      });
    }
  }
}

class NoKeyboardEditableTextFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    // prevents keyboard from showing on first focus
    return false;
  }
}
