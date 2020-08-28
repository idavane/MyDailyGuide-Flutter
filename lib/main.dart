import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mydailyguide/new_item_view.dart';
import 'package:mydailyguide/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> list = List<Todo>();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences()async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyDailyGuide'),
        centerTitle: true,
      ),
      body: list.isNotEmpty ? buildBody() : buildEmptyBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => goToNewItemView(),
      ),
    );
  }

  Widget buildBody(){
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return buildItem(list[index]);
      },
    );
  }

  Widget buildEmptyBody(){
    return Center(
      child: Text('No Tasks'),
    );
  }

  Widget buildItem(Todo item){
    return Dismissible(
      key: Key(item.hashCode.toString()),
      onDismissed: (direction) => removeItem(item),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red[600],
        child: Icon(Icons.delete, color: Colors.white,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 25.0),
      ),
      child: buildListTile(item),
    );
  }

  Widget buildListTile(Todo item){
    return ListTile(
      title: Text(item.title),
      trailing: Checkbox(value: item.complete, onChanged: null),
      onTap: () => setCompleteness(item),
      onLongPress: () => goToEditItemView(item),
    );
  }

  void goToNewItemView(){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context){
          return NewItemView();
        }
    )).then((title){
      if(title != null) addTodo(Todo(title: title));
    });
  }

  void goToEditItemView(Todo item){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context){
          return NewItemView(title: item.title,);
        }
    )).then((title){
      if(title != null) editTodo(item, title);
    });
  }

  void setCompleteness(Todo item){
    setState(() {
      item.complete = !item.complete;
    });
    saveData();
  }

  void removeItem(Todo item){
    list.remove(item);
    if(list.isEmpty) setState(() {});
    saveData();
  }

  void addTodo(Todo item){
    list.add(item);
    saveData();
  }

  void editTodo(Todo item, String title){
    item.title = title;
    saveData();
  }

  void saveData(){
    List<String> spList = list.map((item) => jsonEncode(item.toMap())).toList();
    sharedPreferences.setStringList('list', spList);
  }

  void loadData(){
    List<String> spList = sharedPreferences.getStringList('list');
    list = spList.map((item) => Todo.fromMap(jsonDecode(item))).toList();
    setState(() {});
  }
}
