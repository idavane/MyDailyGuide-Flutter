class Todo {
  String title;
  bool complete;

  Todo({
    this.title,
    this.complete = false,
  });

  Todo.fromMap(Map map) :
      this.title = map['title'],
      this.complete = map['complete'];

  Map toMap(){
    return {
      'title': this.title,
      'complete': this.complete,
    };
  }
}