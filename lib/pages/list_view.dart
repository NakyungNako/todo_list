import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/model/todo_model.dart';
import 'package:to_do_list/widgets/todo_tile.dart';

import '../services/local_notification_service.dart';

class ListTodoView extends StatefulWidget {
  const ListTodoView({Key? key, required this.searchTodoList, required this.localSave, required this.todoList, required this.updateFilter, required this.service}) : super(key: key);

  final List searchTodoList;
  final List todoList;
  final Function localSave;
  final Function updateFilter;
  final LocalNotificationService service;

  @override
  State<ListTodoView> createState() => _ListTodoViewState();
}

class _ListTodoViewState extends State<ListTodoView> {
  late List temp;

  void checkTodo(bool? value, element){
    setState(() {
      element.status = !element.status;
    });
  }

  deleteTodo(element, index){
    dynamic item = element;
    int? position;
    setState(() {
      widget.searchTodoList.removeWhere((todo) => todo == element);
      if(widget.searchTodoList.length == widget.todoList.length){
        position = index;
      } else {
        position = widget.todoList.indexOf(item);
      }
      widget.todoList.removeWhere((todo) => todo == item);
      widget.service.cancelNotification(id: element.id);
    });
    widget.localSave(widget.todoList);
    widget.updateFilter(widget.todoList);
    return [item, position];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    temp = widget.todoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: widget.searchTodoList.isNotEmpty
            ? GroupedListView(
              elements: widget.searchTodoList,
              groupBy: (element) => DateFormat('dd MMM').format(element.date),
                groupSeparatorBuilder: (String groupByValue) =>
                    Container(
                      margin: const EdgeInsets.all(15),
                        child: Text(
                          groupByValue,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
              itemComparator: (item1, item2) => item1.date.compareTo(item2.date),
              separator: const Divider(color: Colors.black54,indent: 20,endIndent: 20),
              indexedItemBuilder: (context, element, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    if(direction == DismissDirection.startToEnd){
                      var deletedTodo = deleteTodo(element, index);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: const Text("Completed"),
                            action: SnackBarAction(
                                label: "undo",
                                onPressed: () async {
                                  setState(() {
                                    if(widget.searchTodoList.length == widget.todoList.length){
                                      widget.todoList.insert(deletedTodo[1], deletedTodo[0]);
                                    } else {
                                      widget.searchTodoList.insert(index, deletedTodo[0]);
                                      widget.todoList.insert(deletedTodo[1], deletedTodo[0]);
                                    }
                                  });
                                  widget.localSave(widget.todoList);
                                  widget.updateFilter(widget.todoList);
                                  if(((deletedTodo[0].date.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch)/1000).floor() > 600) {
                                    await widget.service.showScheduledNotification(
                                      id: deletedTodo[0].id,
                                      title: '10 minutes left for you TODO',
                                      body: deletedTodo[0].title,
                                      seconds: (((deletedTodo[0]
                                          .date.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch) / 1000) - 600)
                                          .floor(),
                                    );
                                  }
                                }
                            ),
                          )
                      );
                    } else {
                      deleteTodo(element,index);
                    }
                  },
                  confirmDismiss: (direction) async {
                    if(direction == DismissDirection.endToStart){
                      bool dismiss = false;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Are you sure deleting this item?"),
                              actions: [
                                TextButton(
                                    onPressed: (){
                                      dismiss = true;
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete")),
                                TextButton(
                                    onPressed: (){
                                      dismiss = false;
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel")),
                              ],
                            );
                          },
                      );
                      return dismiss;
                    }
                    return true;
                  },
                  child: TodoTile(
                    removeFunction: (value) => checkTodo(value, element),
                    todo: element,
                  ),
                );
              },
            )
            : const Center(child: Text("NOTHING HERE!"))
      ),
    );
  }
}
