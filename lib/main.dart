import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User List',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'User List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<User>> _getUusers() async{
    var data = await http.get("https://jsonplaceholder.typicode.com/users");
    var jsonData = json.decode(data.body);
    List<User> users =[];
    for(var u in jsonData){
      User user = User(u["id"], u["name"], u["username"], u["email"], u["phone"]);
      users.add(user);
    }

    print(users.length);

    return users;


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUusers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){

            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text('Loading'),
                ),
              );
            }else{
              return ListView.builder(

                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(

                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].email),

                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage(snapshot.data[index])));
                        },
                        leading: CircleAvatar(
                          backgroundImage: AssetImage ("assets/images/account.png"
                          ),
                        ));

                  }
              );
            }



          },
        ),
      ),

    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;
  DetailPage(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        ),
        //Text(user.name),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[

                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text("Name"),
                  subtitle: Text(user.name),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("UserName"),
                  subtitle: Text(user.username),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text("Email"),
                  subtitle: Text(user.email),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("Phone Number"),
                  subtitle: Text(user.phone),
                ),
              ],

            ))
    );
  }
}

class User{
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;



  User(this.id,this.name,this.username,this.email,this.phone);
}