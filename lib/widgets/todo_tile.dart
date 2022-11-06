import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/model/todo_model.dart';
import 'package:to_do_list/pages/todo_detail.dart';
import 'package:to_do_list/widgets/custom_rect_tween.dart';
import 'package:to_do_list/widgets/hero_dialog_route.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final Function(bool?)? removeFunction;

  const TodoTile({Key? key, required this.removeFunction, required this.todo,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
            HeroDialogRoute(
                builder: (context) => TodoDetail(todo: todo)
            )
        );
      },
      child: Hero(
        tag: 'todo-tag-${todo.id}',
        createRectTween: (begin,end){
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Material(
          child: ListTile(
            leading: Checkbox(
              value: todo.status,
              shape: const CircleBorder(),
              onChanged: removeFunction,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title.toString(),
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy - hh:mm aaa').format(todo.date as DateTime),
                  style: const TextStyle(color: Colors.green),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
