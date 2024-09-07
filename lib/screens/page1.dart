import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intgexample/screens/class.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<ListModel>> listmodel;

  @override
  void initState() {
    super.initState();
    listmodel = fetchListModels();
  }

  Future<List<ListModel>> fetchListModels() async {
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return ListModel.fromJsonList(jsonData);
    } else {
      throw Exception('Failed to load list');
    }
  }

  void editItem(ListModel item) {
    TextEditingController _idController = TextEditingController(text: item.id.toString());
    TextEditingController _titleController = TextEditingController(text: item.title);
    TextEditingController _bodyController = TextEditingController(text: item.body);
    TextEditingController _userIdController = TextEditingController(text: item.userId.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ID',
                ),
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: 'Body',
                ),
              ),
              TextField(
                controller: _userIdController,
                decoration: InputDecoration(
                  labelText: 'UserId',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  item.id = int.parse(_idController.text);
                  item.title = _titleController.text;
                  item.body = _bodyController.text;
                  item.userId = int.parse(_userIdController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void deleteItem(int id) {
    setState(() {
      listmodel = listmodel.then((items) => items.where((item) => item.id != id).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('datas'),
      ),
      body: Center(
        child: FutureBuilder<List<ListModel>>(
          future: listmodel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data found');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.id.toString()),
                        Text(item.userId.toString()),
                        Text(item.body),
                        Text("-------------------------------------------"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editItem(item);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteItem(item.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
