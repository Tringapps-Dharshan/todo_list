// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var uuid = const Uuid();
  bool isClicked = false;
  bool isEditTask = false;
  int currentIndex = 0;
  List<Task> tasks = [];
  final _formKey = GlobalKey<FormState>();
  final subForm = GlobalKey<FormState>();
  final myController = TextEditingController();
  final mySubController = TextEditingController();
  @override
  void initState() {
    super.initState();
    myController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.deepPurple[50],
        child: ListView(
          children: const [
            DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/header.jpeg'),
                      fit: BoxFit.fill),
                ),
                child: Text('')),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Todo List'),
      ),
      body: tasks.isNotEmpty
          ? ListView(
              children: tasks
                  .map((e) => Card(
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: e.isEdit
                                  ? Form(
                                      key: subForm,
                                      child: TextFormField(
                                        controller: mySubController,
                                        decoration: const InputDecoration(
                                            icon: Icon(Icons.edit_note),
                                            hintText: 'EditTask',
                                            labelText:
                                                'Enter a valid task to edit'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a valid task';
                                          }
                                          return null;
                                        },
                                      ),
                                    )
                                  : Text(
                                      e.taskName,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic),
                                    ),
                            )),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: e.isEdit
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          if (subForm.currentState!
                                              .validate()) {
                                            setState(() {
                                              tasks[tasks.indexWhere((task) =>
                                                          task.id == e.id)]
                                                      .taskName =
                                                  mySubController.text;
                                              tasks[tasks.indexWhere((task) =>
                                                      task.id == e.id)]
                                                  .isEdit = false;
                                              isEditTask = false;
                                            });
                                          }
                                          mySubController.clear();
                                        },
                                      )
                                    : IconButton(
                                        disabledColor: Colors.grey,
                                        color: Colors.blueAccent,
                                        icon: const Icon(
                                          Icons.edit,
                                        ),
                                        onPressed: isEditTask
                                            ? null
                                            : () {
                                                setState(() {
                                                  tasks[tasks.indexWhere(
                                                          (task) =>
                                                              task.id == e.id)]
                                                      .isEdit = !e.isEdit;
                                                  mySubController.text =
                                                      e.taskName;
                                                  isEditTask = true;
                                                });
                                              },
                                      )),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: IconButton(
                                disabledColor: Colors.grey,
                                icon: const Icon(Icons.delete),
                                color: Colors.redAccent,
                                onPressed: !e.isEdit
                                    ? () {
                                        setState(() {
                                          tasks.removeWhere(
                                              (task) => task.id == e.id);
                                        });
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            )
          : const Center(
              child: Text('No task found'),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'All Tasks',
          )
        ],
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        selectedItemColor: Colors.deepPurple,
      ),
      floatingActionButton: Visibility(
        visible: !isEditTask,
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            setState(() {
              isClicked = true;
            });
            if (isClicked) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Add new task'),
                      content: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: myController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.add_task),
                                hintText: 'NewTask',
                                labelText: 'Enter a new task to add'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid task';
                              }
                              return null;
                            },
                          )),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isClicked = false;
                                  tasks.add(Task(
                                      id: uuid.v4(),
                                      taskName: myController.text,
                                      isEdit: false));
                                  myController.clear();
                                });
                                isClicked = false;
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Add'))
                      ],
                    );
                  });
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
      // floatingActionButton:
    );
  }
}

class Task {
  //modal class for Person object
  String id, taskName;
  bool isEdit;
  Task({
    required this.id,
    required this.taskName,
    required this.isEdit,
  });
}
