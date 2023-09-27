import 'package:flutter/material.dart';
import 'package:sql_application/database.dart';
import 'package:sql_application/updateUser.dart';

// import 'package:sqflite_test/dbhelper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _agecontroller = TextEditingController();
  final _namecontroller = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

  saveData() async {
    final name = _namecontroller.text;
    final age = int.tryParse(_agecontroller.text) ?? 0;
    int insertId = await DbHelper.insertUser(name, age);
    // ignore: avoid_print
    print(insertId);

    List<Map<String, dynamic>> updateData = await DbHelper.getData();
    setState(() {
      dataList = updateData;
    });
    _namecontroller.text = '';
    _agecontroller.text = '';
  }

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  void _getUsers() async {
    List<Map<String, dynamic>> userLIst = await DbHelper.getData();
    setState(() {
      dataList = userLIst;
    });
  }

  void _delete(int docId) async {
    int id = await DbHelper.deleteData(docId);
    List<Map<String, dynamic>> updateData = await DbHelper.getData();
    setState(() {
      dataList = updateData;
    });
  }

  @override
  void dispose() {
    _agecontroller.dispose();
    _namecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _namecontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Name',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _agecontroller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Age',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        saveData();
                      });
                    },
                    child: const Text("save"))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Name : ${dataList[index]['name']}',
                    ),
                    subtitle: Text(
                      'Age : ${dataList[index]['age'].toString()}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateUser(userId: dataList[index]['id']),
                                )).then((result) {
                              if (result == true) {
                                fetchData();
                              }
                            });
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _delete(dataList[index]['id']);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchData() async {
    List<Map<String, dynamic>> fetchData = await DbHelper.getData();
    setState(() {
      dataList = fetchData;
    });
  }
}