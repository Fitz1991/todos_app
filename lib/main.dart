import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/dimka/AndroidStudioProjects/todos_app/lib/model/todo.dart';
import 'block/todo_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage('Статусы заданий'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  String title;
  int pageNo = 1;
  int maxPage = 10;

  MyHomePage(this.title);

  TodoBlock todoBlock = TodoBlock();
  List<Todo> _todos;
  ScrollController _scrollController = ScrollController();

  Widget _headerWidget(title) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _taskWidget(int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(_todos[index].title, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _statusWidget(int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text((_todos[index].completed) ? 'Выполнено' : 'Не выполнено',
            textAlign: TextAlign.center),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    todoBlock.getTodos.add(pageNo);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if ((pageNo + 1) < maxPage) {
          pageNo++;
          todoBlock.getTodos.add(pageNo);
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Container(
          child: StreamBuilder(
            stream: todoBlock.todosStream,
            initialData: [],
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  print('Loading...');
                  return const Text('Loading...');
                default:
                  if (snapshot.data.isEmpty) {
                    return const Text('Нет данных');
                  }
                  _todos = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _headerWidget('Задание'),
                            _headerWidget('Статус')
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _todos.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  _taskWidget(index),
                                  _statusWidget(index),
                                ],
                              );
                            },
                            controller: _scrollController,
                          ),
                        )
                      ],
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
