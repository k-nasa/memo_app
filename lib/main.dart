import 'package:flutter/material.dart';
import 'dart:async';
import 'package:memo_app/databae_helper.dart';
import 'package:memo_app/new_memo_form.dart';
import 'package:memo_app/memo.dart';

var dbHelper = new DBHelper();

void main() {
  runApp(
    new MaterialApp(
      title: 'hoge',
      routes: <String, WidgetBuilder> {
        '/': (_) => new Home(),
        '/new_memo': (_) => new MemoForm()
      },
    )
  );
}

class Home extends StatelessWidget {
  var _db = new DBHelper();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('HOME'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add_circle),
            onPressed: (){
              Navigator.of(context).pushNamed('/new_memo');
            },
          )
        ],
      ),
      body: new MemoScreen(),
    );
  }
}


class MemoScreen extends StatefulWidget {
  @override
  State createState() => new MemoScreenState();
}

Future<List<MemoMessage>> getMemoListWidget() async {
  dbHelper.getMemos().then((List<Memo> list) {
    if(list == [])  return [];
    List<MemoMessage> memoList = [];
    list.map((memo) {
      memoList.add(
          new MemoMessage(
              content: memo.content,
              finished: memo.finished
          ));
    });
    return memoList;
  });
}
// 仮実装
class MemoScreenState extends State<MemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        children: <Widget>[
          new Flexible(
            child: new FutureBuilder(
              future: getMemoListWidget(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => snapshot.data[index],
                    itemCount: snapshot.data.length,
                  );
                }else {
                  return new Container();
                }
              },
            ),
          ),
          new Divider(height: 2.0,) ,
        ],
      ),
    );
  }
}

// 仮実装
class MemoMessage extends StatelessWidget {
  MemoMessage({this.content, this.finished});

  String content;
  bool finished;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Text(content),
        new Text(finished.toString()),
      ],
    );
  }
}
