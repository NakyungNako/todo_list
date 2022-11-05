import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'model/todo_model.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key, required this.herotag, required this.onSave}) : super(key: key);

  final String herotag;
  final Function onSave;

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final dateinput = TextEditingController();
  final _controller = TextEditingController();
  final _descController = TextEditingController();

  late DateTime selectTime;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateinput.text = '';
    selectTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 30, mediaQueryData.viewInsets.bottom),
        child: Hero(
          tag: widget.herotag,
          child: Material(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'New Todo...',
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(color: Colors.black54,thickness: 0.2,),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        hintText: 'Write a note',
                        border: InputBorder.none,
                      ),
                      maxLines: 6,
                    ),
                    const Divider(color: Colors.black54,thickness: 0.2),
                    TextField(
                      readOnly: true,
                      controller: dateinput,
                      decoration: const InputDecoration(
                        hintText: 'Pick Date',
                      ),
                      onTap: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2027, 11, 5),
                            onConfirm: (date) {
                              setState(() {
                                dateinput.text = DateFormat('dd MMM yyyy - hh:mm aaa').format(date);
                                selectTime = date;
                              });
                            },
                            currentTime: DateTime.now(), locale: LocaleType.en
                        );
                      },
                    ),
                    ValueListenableBuilder(
                        valueListenable: _controller,
                        builder: (context, value, child) {
                          return ElevatedButton(
                              onPressed: value.toString().contains('┤├') ? null : () => {
                                widget.onSave(_controller.text,_descController.text,selectTime),
                                _controller.clear(),
                                _descController.clear(),
                                dateinput.clear(),
                              },
                              child: Text('Add')
                          );
                        }
                    ),
                    // TextButton(
                    //   onPressed: controller.toString().isNotEmpty ? onSave : null,
                    //   // style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.deepOrange.shade50)),
                    //   child: const Text('Add', style: TextStyle(fontSize: 16)),
                    // )
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
