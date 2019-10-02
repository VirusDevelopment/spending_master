class ExpenceModel{
  int _id;
  String _expencedatetime;
  String _category;
  int _paymentMode;
  String _amount;

  ExpenceModel(this._expencedatetime,this._category,this._paymentMode,this._amount);
  ExpenceModel.withID(this._id);
  int get id => _id ;
  String get expencedatetime => _expencedatetime ;
  int get paymentMode => _paymentMode ;
  String get category => _category ;
  String get amount => _amount ;

  set expencedatetime(String newexpencedatetime){
    if(newexpencedatetime != null){
      this._expencedatetime = newexpencedatetime;
    }
  }

  set category(String newcategory){
    if(newcategory != null){
      this._category = newcategory;
    }
  }

  set paymentMode(int newpaymentMode){
    if(newpaymentMode != null){
      this._paymentMode = newpaymentMode;
    }
  }


  set amount(String newamount){
    if(newamount != null || newamount != "" ){
      this._amount = newamount;
    }
  }
  Map<String,dynamic> toMap( ){
    var map = Map<String,dynamic>();
    if(id != null){
      map['id'] = _id;
    }
    map['expencedatetime'] = _expencedatetime;
    map['paymentMode'] = _paymentMode;
    map['category'] = _category;
    map['amount'] = _amount;
    return map;
  }

   ExpenceModel.fromMapObject(Map<String,dynamic>map){
      this._id = map['id'];
      this._expencedatetime = map['expencedatetime'];
      this._paymentMode = map['paymentMode'];
      this._category = map['category'];
      this._amount = map['amount'];
   }

 }
