import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.brown,
);

const String namaDefault = "Rahmatteo";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Simple Chat",
      theme:
          defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : androidTheme,
      home: new Chat(),
    );
  }
}

class Chat extends StatefulWidget {
  @override
  State createState() => new ChatWindow();
}

class ChatWindow extends State<Chat> with TickerProviderStateMixin {
//  AnimationController _controller;
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(namaDefault + " Chat "),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
            reverse: true,
            padding: new EdgeInsets.all(6.0),
          )),
          new Divider(height: 1.0),
          new Container(
            child: _buildComposer(),
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          )
        ],
      ),
    );
  }

  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textEditingController,
                onChanged: (String txt) {
                  setState(() {
                    _isWriting = txt.length > 0;
                  });
                },
                onSubmitted: _submitMsg,
                decoration: new InputDecoration.collapsed(
                    hintText: "Masukin Pesan Yang Dikirim"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 3.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                        child: new Text("Submit"),
                        onPressed: _isWriting
                            ? () => _submitMsg(_textEditingController.text)
                            : null)
                    : new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: _isWriting
                            ? () => _submitMsg(_textEditingController.text)
                            : null))
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? new BoxDecoration(
                border: new Border(top: new BorderSide(color: Colors.brown)))
            : null,
      ),
    );
  }

  void _submitMsg(String txt) {
    _textEditingController.clear();
    setState(() {
      _isWriting = false;
    });

    Msg msg = new Msg(
        txt: txt,
        animationController: new AnimationController(
            vsync: this, duration: new Duration(milliseconds: 100)));
    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  final String txt;

  final AnimationController animationController;

  Msg({this.txt, this.animationController});

  @override
  Widget build(BuildContext context) {
    DateTime nows = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(nows);

    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0,
//          margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 9.0),
              child: new CircleAvatar(child: new Text(namaDefault[0])),
            ),
            new Expanded(
                child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                        new Text(namaDefault,style: Theme.of(context).textTheme.subhead),
                Container(
                  margin: EdgeInsets.only(right: 50),
                  child: Card(
                    color: Colors.brown[100],
                    child: new Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              child: new Text(txt)),
                          Container(
                              margin: EdgeInsets.only(top: 8),
                              alignment: Alignment.bottomRight,
                              child: new Text(
                                formattedDate,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.brown[300]),
                              ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
