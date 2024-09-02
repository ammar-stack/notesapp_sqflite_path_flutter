import 'package:flutter/material.dart';
import 'package:todo_notesapp_sqflite_flutter/models/task.dart';
import 'package:todo_notesapp_sqflite_flutter/services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService =
      DatabaseService.instance; //getting access to the class
  String? _task = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _taskList(),
      appBar: AppBar(
        title: const Text("To Do App", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text("Add Task"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _task = value;
                            });
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Add Task'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder()),
                              onPressed: () {
                                if (_task == null || _task == "")
                                  return; //return if task is empty
                                _databaseService.addTask(_task!);
                                setState(() {
                                  _task = null;
                                });

                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _taskList() {
    return FutureBuilder(
        future: _databaseService.getTask(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                //using model
                Task task = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.green.shade100,
                    child: ListTile(
                      shape:const RoundedRectangleBorder(),
                      selectedTileColor: Colors.orange.shade100,
                      onLongPress: (){
                        _databaseService.deleteTask(task.id);
                        setState(() {
                          
                        });
                      },
                      title: Text(task.content),
                      trailing: Checkbox(value: task.status == 1, onChanged: (value){
                        _databaseService.updateTaskStatus(task.id, value == true ? 1 : 0);
                        setState(() {
                          
                        });
                      }),
                    ),
                  ),
                );
              });
        });
  }
}
