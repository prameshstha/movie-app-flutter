import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List trendingMovies = [];

  final String apiKey = 'b105fd2105b38ae32e9df54f88014765';
  final readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMTA1ZmQyMTA1YjM4YWUzMmU5ZGY1NGY4ODAxNDc2NSIsInN1YiI6IjYxYTg2MThiMjQ5NWFiMDAyYTBlY2EzOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HdZm11qeZu8FmLO9gA2xtzGn8LLDb6aGQzMvHKl8Mxs';

  Future<List<User>> getUserDate() async {
    var response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/top_rated?api_key=b105fd2105b38ae32e9df54f88014765"),
      // headers: {"key": apiKey}
    );
    print(response.body);
    var jsonData = jsonDecode(response.body);
    print(jsonData);
    List<User> users = [];
    for (var u in jsonData) {
      User user = User(u['name'], u['email'], u['username']);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Card(
          child: FutureBuilder(
            future: getUserDate(),
            builder: (context, AsyncSnapshot<List<User>> snapshot) {
              if (!snapshot.hasData) {
                return Text('no data');
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else
                // ignore: curly_braces_in_flow_control_structures
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(snapshot.data![i].name),
                    );
                  },
                );
              // By default, show a loading spinner.
            },
          ),
        ),
      ),
    );
  }
}

class User {
  final String name, email, username;
  User(this.name, this.email, this.username);
}
