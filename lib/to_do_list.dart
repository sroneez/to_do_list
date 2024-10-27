import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'todo.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({
    super.key,
  });

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();
  Priority _selectedPriority = Priority.low;
  String _title = '';
  String _description = '';

  final List<Todo> todos = [];

  @override
  Widget build(BuildContext context) {
    bool iskeyboardVisible = MediaQuery.of(context).viewInsets.bottom !=0;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
          centerTitle: true,
          backgroundColor: Colors.grey[200],
        ),
        body: Container(
          color: iskeyboardVisible ? Colors.red: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(!iskeyboardVisible)
                Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                      itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(

                         title: Text(todos[index].title),
                         subtitle: Text(todos[index].description),
                         trailing: Text(todos[index].priority.title),
                          tileColor: todos[index].priority.color.withOpacity(.8),
                        ),
                      );
                      }
                  ),
                ),
                Form(
                    key: _formGlobalKey,
                    child: Column(
                      children: [
                        TextFormField(
                          maxLength: 20,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'You must enter a value for the title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _title = value!;
                          },
                        ),
                        TextFormField(
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Todo List'),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 5) {
                              return 'Enter a description at least 5 chars long';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _description = value!;
                          },
                        ),
                        DropdownButtonFormField(
                            value: _selectedPriority,
                            items: Priority.values.map((p) {
                              return DropdownMenuItem(
                                child: Text(p.title),
                                value: p,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value!;
                              });
                            }),
                        ElevatedButton(
                            onPressed: () {
                              if (_formGlobalKey.currentState!.validate()) {
                                _formGlobalKey.currentState!.save();

                                setState(() {
                                  todos.add(Todo(
                                      title: _title,
                                      description: _description,
                                      priority: _selectedPriority));
                                });
                              }
                            },
                            child: const Text('Add'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ))
                        )
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
