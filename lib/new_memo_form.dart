import 'package:flutter/material.dart';
import 'package:memo_app/memo.dart';
import 'package:memo_app/databae_helper.dart';

class MemoForm extends StatelessWidget {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String content;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('MemoForm'),
        ),
        body: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Form(
              child: new Column(
                  children: [
                    new TextField(
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(labelText: 'First Name'),
                      onChanged: (val) => this.content = val,
                    ),
                    new Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: new RaisedButton(
                        onPressed: _submit,
                        child: new Text('Add memo!'),
                      ),
                    )
                  ],
              ),
            ),
        )
    );
  }

  void _submit() {
    var memo = Memo(content: this.content, finished: false);
    var dbHelper = DBHelper();
    dbHelper.saveMemo(memo);
  }
}

