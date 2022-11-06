import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/todo_model.dart';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  const TodoDetail({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoDetail> createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  final _dateController = TextEditingController();
  final _controller = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text = widget.todo.title!;
    _descController.text = widget.todo.description!;
    _dateController.text = DateFormat('dd MMM yyyy - hh:mm aaa').format(widget.todo.date as DateTime);
  }


  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Center(
      child: Padding(
          padding: EdgeInsets.fromLTRB(30, 30, 30, mediaQueryData.viewInsets.bottom),
          child: Hero(
            tag: 'todo-tag-${widget.todo.id}',
            child: Material(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        readOnly: true,
                        controller: _controller,
                        style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w300),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                      const Divider(color: Colors.black54,thickness: 0.2,),
                      TextField(
                        readOnly: true,
                        controller: _descController,
                        decoration: InputDecoration(
                          hintText: 'No Description',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        maxLines: 6,
                      ),
                      const Divider(color: Colors.black54,thickness: 0.2),
                      TextField(
                        readOnly: true,
                        controller: _dateController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}
