import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<User>> _getUsers() async {
    var data = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    var jsonData = json.decode(data.body);
    List<User> users = [];
    for (var u in jsonData) {
      User user =
          User(u["albumId"], u["id"], u["title"], u["url"], u["thumbnailUrl"]);
      users.add(user);
    }

    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int id) {
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data[id].url),
                        ),
                        title: Text(snapshot.data[id].title),
                      ),
                      Divider(
                        height: 0.1,
                      )
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}

class User {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  User(this.albumId, this.id, this.title, this.url, this.thumbnailUrl);
}
