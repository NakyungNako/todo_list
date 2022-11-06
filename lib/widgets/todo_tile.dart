import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/model/todo_model.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final Function(bool?)? removeFunction;

  const TodoTile({Key? key, required this.removeFunction, required this.todo,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){},
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
    );
  }
}
