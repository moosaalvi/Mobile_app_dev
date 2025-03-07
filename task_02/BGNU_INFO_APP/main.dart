import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/BGNU_logo.png',
                    height: 40,
                  ),
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
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.black),
              onPressed: () {
                
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
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
                leading: Icon(Icons.home),
                title: Text("Home"),
                onTap: () {
                  
                },
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text("Courses"),
                onTap: () {
                 
                },
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text("Faculty"),
                onTap: () {
                  
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_mail),
                title: Text("Contact Us"),
                onTap: () {
                  
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Baba Guru Nanak University (BGNU) is a Public sector university located in District Nankana Sahib, in the Punjab region of Pakistan. It plans to facilitate between 10,000 to 15,000 students from all over the world at the university. The foundation stone of the university was laid on October 28, 2019 ahead of 550th of Guru Nanak Gurpurab by the Prime Minister of Pakistan.\n\n"
                  "On July 2, 2020, Government of Punjab has formally passed Baba Guru Nanak University Nankana Sahib Act 2020 (X of 2020). The plan behind the establishment of this university is to be modeled along the lines of world-renowned universities with a focus on languages and Punjab Studies offering faculties in \"Medicine\", \"Pharmacy\", \"Engineering\", \"Computer Science\", \"Languages\", \"Music\" and \"Social Sciences\".\n\n"
                  "The initial cost of Rs. 6 billion has already been allocated in the budget for this project to be spent in three phases on construction of Baba Guru Nanak University Nankana Sahib. The development work of Phase-I has already been started by the Communication and Works Department of Government of Punjab.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/university.jpg',
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
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
      ),
    );
  }
}
