import 'calculator.dart';
import 'gradebook.dart';
import 'add_users.dart';
import 'listview_vertical.dart';
import 'listvoew_horizontal.dart';
import 'jason.dart';
import 'academic_record.dart';
import 'add_academic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          children: [
            Image.asset('assets/BGNU_logo.png', height: 40),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Baba Guru Nanak University",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Nankana Sahib",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/BGNU_logo.png', height: 60),
                  SizedBox(height: 10),
                  Text(
                    "BGNU Navigation",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text("Calculator"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculatorPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.grade),
              title: Text("Grade Book"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GradeBookPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.input),
              title: Text("Add User"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Registered Users"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisteredUsersPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.view_array),
              title: Text("ListView Vertical"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListViewVertical(),
                  ), // ✅ Corrected
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.view_carousel),
              title: Text("Horizontal ListView"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListViewHorizontal(),
                  ), // ✅ Navigate to Horizontal ListView
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.data_usage),
              title: Text("JSON Data"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JsonDataScreen(),
                  ), // ✅ Navigate to JSON Data Screen
                );
              },
            ),
             ListTile(
              leading: Icon(Icons.school),
              title: Text("Academic Record"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(), // The Academic Record page
                  ),
                );
              },
            ),
              ListTile(
              leading: Icon(Icons.book),
              title: Text("Add record"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnlineApiPage(), // The Academic Record page
                  ),
                );
              },
            ),
           
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Baba Guru Nanak University (BGNU) is a Public sector university located in District Nankana Sahib...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/university.jpg',
                  width: 300,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "© 2025 BGNU. Nankana Sahib.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

// 🚀 REGISTERED USERS PAGE
class RegisteredUsersPage extends StatefulWidget {
  @override
  _RegisteredUsersPageState createState() => _RegisteredUsersPageState();
}

class _RegisteredUsersPageState extends State<RegisteredUsersPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('users');
    if (data != null) {
      setState(() {
        users = List<Map<String, dynamic>>.from(jsonDecode(data));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Registered Users"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child:
            users.isEmpty
                ? Center(
                  child: Text(
                    "No registered users yet.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                )
                : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _buildUserCard(users[index]);
                  },
                ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(4, 4)),
          BoxShadow(color: Colors.white, blurRadius: 8, offset: Offset(-4, -4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 5),
              Text(
                user['phone'],
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
          Icon(
            Icons.circle,
            color: user['isActive'] ? Colors.green : Colors.red,
            size: 20,
          ),
        ],
      ),
    );
  }
}
