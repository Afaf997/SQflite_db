import 'package:flutter/material.dart';
import 'package:sql_application/database.dart';

class UpdateUser extends StatefulWidget {
  final int userId;
  const UpdateUser({
    required this.userId,
    super.key,
  });

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _agecontroller = TextEditingController();
  final _namecontroller = TextEditingController();

  void fetchData() async {
    Map<String, dynamic>? data = await DbHelper.getSingleData(widget.userId);
    if (data != null) {
      _namecontroller.text = data['name'];
      _agecontroller.text = data['age'].toString();
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void _updateData(BuildContext context) async {
    Map<String, dynamic> data = {
      'name': _namecontroller.text,
      'age': _agecontroller.text,
    };
    int id = await DbHelper.updateData(widget.userId, data);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _agecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                    _updateData(context);
                  });
                },
                child: const Text("Update User"))
          ],
        ),
      ),
    );
  }
}