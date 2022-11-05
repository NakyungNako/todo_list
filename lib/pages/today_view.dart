import 'package:flutter/material.dart';
import 'package:to_do_list/todo_tile.dart';

class Today extends StatefulWidget {
  const Today({Key? key, required this.todoList}) : super(key: key);

  final List todoList;

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  void removeTodo(bool? value, int index){
    _key.currentState!.removeItem(index, (context, animation) =>
      FadeTransition(
        opacity: animation,
        child: Text("hello"),
      ),
      duration: const Duration(milliseconds: 300),
    );
    widget.todoList.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _key,
      initialItemCount: widget.todoList.length,
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          key: UniqueKey(),
          opacity: animation,
          child: Text("hello"),
        );
      },
    );
  }
}
