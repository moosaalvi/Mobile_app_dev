import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/userModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<UserModel> studentList = [];
  bool isDataReady = false;
  List<String> courseNames = []; // List to hold course names
  String? selectedCourse; // To store selected course
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCourses();  // Fetch the courses when the screen is initialized
    loadSavedData();
  }

  // Fetch courses from the API and populate the dropdown
  Future<void> fetchCourses() async {
    try {
      final response = await http.get(Uri.parse('https://devtechtop.com/management/public/api/courses'));

      if (response.statusCode == 200) {
        print("Response body: ${response.body}"); // Log the response body for debugging

        var decoded = jsonDecode(response.body);
        var data = decoded['data']; // Make sure the key is correct

        if (data != null && data is List) {
          List<String> courses = [];
          for (var item in data) {
            courses.add(item['course_name'] ?? 'Unknown');  // Check the correct key name
          }

          setState(() {
            courseNames = courses;
            selectedCourse = courses.isNotEmpty ? courses[0] : null;  // Set default selected course if available
          });
        } else {
          print("No course data found.");
        }
      } else {
        print('Failed to load courses. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching courses: $e");
    }
  }

  // Fetch and load student data
  Future<void> retrieveAndSaveData() async {
    final response = await http.get(Uri.parse('https://devtechtop.com/management/public/api/select_data'));

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      var data = decoded['data'];

      List<UserModel> tempList = [];
      for (var item in data) {
        tempList.add(UserModel.fromJson(item as Map<String, dynamic>));
      }

      setState(() {
        studentList = tempList;
        isDataReady = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('storedStudents', jsonEncode(data));
    } else {
      print('Failed to load data. Status Code: ${response.statusCode}');
    }
  }

  // Clear saved student data
  Future<void> clearSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('storedStudents');
    setState(() {
      studentList.clear();
      isDataReady = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data cleared successfully!')),
    );
  }

  // Load saved student data from SharedPreferences
  Future<void> loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('storedStudents');
    if (savedData != null) {
      var data = jsonDecode(savedData);
      List<UserModel> tempList = [];
      for (var i in data) {
        tempList.add(UserModel.fromJson(i as Map<String, dynamic>));
      }

      setState(() {
        studentList = tempList;
        isDataReady = true;
      });
    }
  }

  // Delete a student from the list and update SharedPreferences
  void deleteStudent(int index) async {
    setState(() {
      studentList.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('storedStudents', jsonEncode(studentList.map((e) => e.toJson()).toList()));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student deleted successfully!')),
    );
  }

  // Form for adding a student
  void _showAddStudentForm() {
    final _formKey = GlobalKey<FormState>();
    String? userId, courseName, semesterNo, creditHours, marks;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Student"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _formField("User ID", (val) => userId = val),
                  _courseDropdown(), // Dropdown for courses
                  _formField("Semester No", (val) => semesterNo = val),
                  _formField("Credit Hours", (val) => creditHours = val),
                  _formField("Marks", (val) => marks = val),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Add"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Construct the URL with query parameters
                  var url = Uri.parse('https://devtechtop.com/management/public/api/grades')
                      .replace(queryParameters: {
                    'user_id': userId,
                    'course_name': courseName ?? '',
                    'semester_no': semesterNo,
                    'credit_hours': creditHours,
                    'marks': marks,
                  });

                  // Send GET request to add student
                  var response = await http.get(url);

                  // Decode the JSON response
                  var responseData = jsonDecode(response.body);
                  String message = responseData['message'];

                  Navigator.pop(context); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                  if (response.statusCode == 200) {
                    // Successfully added
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Student added successfully!")),
                    );
                  } else {
                    // Failed
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to add student!")),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Form field widget
  Widget _formField(String label, Function(String?) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }

  // Dropdown to select the course
  Widget _courseDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Course Name',
          border: OutlineInputBorder(),
        ),
        value: selectedCourse,
        items: courseNames.map((course) {
          return DropdownMenuItem<String>(
            value: course,
            child: Text(course),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCourse = value;
          });
        },
        onSaved: (value) {
          selectedCourse = value;
        },
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }

  // Search functionality
  void searchStudent(String query) {
    List<UserModel> filteredList = studentList.where((student) {
      return student.userId!.toLowerCase().contains(query.toLowerCase()) ||
             student.courseName!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      studentList = filteredList;
    });
  }

  // Sorting functionality
  void sortStudents(String sortOrder) {
    setState(() {
      if (sortOrder == 'Oldest') {
        studentList.sort((a, b) => a.userId!.compareTo(b.userId!)); // Oldest first
      } else if (sortOrder == 'Newest') {
        studentList.sort((a, b) => b.userId!.compareTo(a.userId!)); // Newest first
      }
    });
  }

  // Student card widget
  Widget studentCard(UserModel student, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course: ${student.courseName ?? "N/A"}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Semester: ${student.semesterNo ?? "N/A"}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Credit Hours: ${student.creditHours ?? "N/A"}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Marks: ${student.marks ?? "N/A"}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'User ID: ${student.userId ?? "N/A"}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  deleteStudent(index); // Call the delete function here
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Grades Viewer'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: retrieveAndSaveData,
                icon: const Icon(Icons.download),
                label: const Text("Load Records"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: clearSavedData,
                icon: const Icon(Icons.delete_forever),
                label: const Text("Clear Data"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search by ID or Course',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            ),
            onChanged: searchStudent,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => sortStudents('Oldest'),
                child: const Text('Oldest First'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => sortStudents('Newest'),
                child: const Text('Newest First'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Enrolled Students',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          isDataReady
              ? Expanded(
                  child: ListView.builder(
                    itemCount: studentList.length,
                    itemBuilder: (context, index) {
                      final student = studentList[index];
                      return studentCard(student, index); // Pass the index here
                    },
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'No records found.\nTap "Load Records" to fetch student data from API.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
        ],
      ),
    );
  }
}
