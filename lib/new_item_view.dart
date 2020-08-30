import 'package:flutter/material.dart';

//Create a new Item
class NewItemView extends StatefulWidget {
  final String title;

  NewItemView({this.title});

  @override
  _NewItemViewState createState() => _NewItemViewState();
}

class _NewItemViewState extends State<NewItemView> {
  TextEditingController textFieldController;

  @override
  void initState() {
    textFieldController = TextEditingController(text: widget.title);
    super.initState();
  }

  //View Property
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textFieldController,
              onEditingComplete: () => add(),
            ),
            FlatButton(
                onPressed: () => add(),
                child: Text(
                  'Add',
                  style: TextStyle(color: Theme.of(context).accentColor),
                )
            )
          ],
        ),
      ),
    );
  }

  void add(){
    if(textFieldController.text.isNotEmpty)
    Navigator.of(context).pop(textFieldController.text);
  }
}
