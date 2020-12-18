import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'file:///C:/Users/dimka/AndroidStudioProjects/todos_app/lib/model/todo.dart';
import 'package:http/http.dart' as http;

class TodoBlock{
  List<Todo> _todos = [];

  String apiUrl = 'https://jsonplaceholder.typicode.com/todos?_page=1&_limit=30';

  TodoBlock(){
    _actionController.stream.listen(_getTodos);
  }

  final _todosSubject = BehaviorSubject<List<Todo>>();
  Stream get todosStream => _todosSubject.stream;
  Sink get _todosSink => _todosSubject.sink;

  StreamController _actionController = StreamController();
  StreamSink get getTodos => _actionController.sink;

  _getTodos(data) async {
    var response = await http.get(apiUrl);
    if(response.statusCode == 200){
      apiUrl = "https://jsonplaceholder.typicode.com/todos?_page=$data&_limit=30";
      _todos.addAll((json.decode(response.body) as List).map((i) =>
          Todo.fromJson(i)).toList()) ;
      _todosSink.add(_todos);
    } else{
      throw Exception();
    }
  }

  void dispose(){
    _todosSubject.close();
    _actionController.close();
  }
}