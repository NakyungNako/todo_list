import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/add_todo.dart';
import 'package:to_do_list/hero_dialog_route.dart';
import 'package:to_do_list/model/todo_model.dart';
import 'package:to_do_list/pages/all_view.dart';
import 'package:to_do_list/pages/today_view.dart';
import 'package:to_do_list/pages/upcoming_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black26,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.black87)
            )
          )
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  final _controller = TextEditingController();
  final _descController = TextEditingController();
  late SharedPreferences prefs;
  List searchTodo = [];
  List toDos = [];
  List filterTodo = [];
  List entries = [
    [Icons.stacked_bar_chart, 'All'],
    [Icons.today, 'Today'],
    [Icons.fast_forward, 'Upcoming']
  ];

  setupTodoList() async {
    prefs = await SharedPreferences.getInstance();
    String? stringTodo = prefs.getString('todo');
    List todoList = jsonDecode(stringTodo!);
    for (var todo in todoList) {
      setState(() {
        toDos.add(Todo().fromJson(todo));
      });
    }
  }

  int currentIndex = 0;
  String pageName = 'All';

  void search(String keyword){
    List results = [];
    if(keyword.isEmpty){
      results = filterTodo;
    } else {
      results = filterTodo
          .where((item) => item.title
            .toLowerCase()
            .contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      searchTodo = results;
    });
  }

  void saveTodo(String title, String desc, DateTime time){
    setState(() {
      toDos.add(
          Todo(
              id: UniqueKey().hashCode,
              title: title,
              description: desc,
              date: time,
              status: false
          )
      );
      _controller.clear();
      _descController.clear();
    });
    updateFilter(toDos);
    updateSearch(toDos);
    localSave(toDos, prefs);
  }

  void updateFilter(List todoList){
    setState(() {
      if(pageName == 'Today'){
        filterTodo = todoList.where((element) => DateFormat.yMMMd().format(element.date) == DateFormat.yMMMd().format(DateTime.now())).toList();
      } else if(pageName == 'Upcoming'){
        filterTodo = todoList.where((element) => DateFormat.yMMMd().format(element.date) != DateFormat.yMMMd().format(DateTime.now())).toList();
      } else {
        filterTodo = todoList;
      }
    });
  }

  void updateSearch(List todoList){
    setState(() {
      if(pageName == 'Today'){
        searchTodo = todoList.where((element) => DateFormat.yMMMd().format(element.date) == DateFormat.yMMMd().format(DateTime.now())).toList();
      } else if(pageName == 'Upcoming'){
        searchTodo = todoList.where((element) => DateFormat.yMMMd().format(element.date) != DateFormat.yMMMd().format(DateTime.now())).toList();
      } else {
        searchTodo = todoList;
      }
    });
  }

  void localSave(List todoList, SharedPreferences pref){
    List items = todoList.map((e) => e.toJson()).toList();
    pref.setString('todo', jsonEncode(items));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupTodoList();
    searchTodo = toDos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(pageName),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20,
                ),
                prefixIconConstraints: BoxConstraints(
                  maxHeight: 20,
                  minWidth: 25,
                ),
                border: InputBorder.none,
                hintText: 'Search',
              ),
              onChanged: (value) => search(value),
            ),
          ),
          Expanded(child: AllTodo(searchTodoList: searchTodo, localSave: (todos) => localSave(todos, prefs), todoList: toDos, updateFilter: (todos) => updateFilter(todos),)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-todo-hero',
        onPressed: (){
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return AddTodo(
              herotag: 'add-todo-hero',
              onSave: (title, desc, time) => saveTodo(title,desc,time),
            );
          }));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: (){
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    return SizedBox(
                      height: 230,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: entries.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: (){
                              if(index == 1){
                                setState(() {
                                  filterTodo = toDos.where((element) => DateFormat.yMMMd().format(element.date) == DateFormat.yMMMd().format(DateTime.now())).toList();
                                  searchTodo = toDos.where((element) => DateFormat.yMMMd().format(element.date) == DateFormat.yMMMd().format(DateTime.now())).toList();
                                });
                              } else if (index == 2){
                                setState(() {
                                  filterTodo = toDos.where((element) => DateFormat.yMMMd().format(element.date) != DateFormat.yMMMd().format(DateTime.now())).toList();
                                  searchTodo = toDos.where((element) => DateFormat.yMMMd().format(element.date) != DateFormat.yMMMd().format(DateTime.now())).toList();
                                });
                              } else {
                                setState(() {
                                  filterTodo = toDos;
                                  searchTodo = toDos;
                                });
                              }
                              pageName = entries[index][1];
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 20,left: 10),
                                    child: Icon(entries[index][0], size: 30),
                                  ),
                                  Text(entries[index][1],style: const TextStyle(fontSize: 16),),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                      ),
                    );
                  }
              );
            }, icon: const Icon(Icons.menu)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.notifications))
          ],
        ),
      ),
    );
  }
}
