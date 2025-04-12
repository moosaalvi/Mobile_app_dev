import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart'; // add this import

class OnlineApiPage extends StatefulWidget {
  const OnlineApiPage({super.key});

  @override
  State<OnlineApiPage> createState() => _OnlineApiPageState();
}

class _OnlineApiPageState extends State<OnlineApiPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();

  String? _selectedCourseName;
  String? _selectedSemester;
  String? _selectedCreditHours;

  bool _isSubmitting = false;
  bool _isFetching = false;
  bool _isSuccess = false;
  String _responseMessage = '';
  

  List<dynamic> _gradesData = [];
  List<String> _courseNames = [];

  final List<String> _semesterOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  ];
  final List<String> _creditHourOptions = ['1', '2', '3', '4'];

  final String _postUrl = 'https://devtechtop.com/management/public/api/grades';
  final String _getUrl =
      'https://devtechtop.com/management/public/api/select_data';
  final String _coursesUrl =
      'https://bgnuerp.online/api/get_courses?user_id=12122';

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final response = await http
          .get(Uri.parse(_coursesUrl))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            _courseNames =
                data
                    .map((course) => course['subject_name'].toString())
                    .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Failed to load course list: $e");
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _responseMessage = '';
    });

    try {
      final response = await http
          .post(
            Uri.parse(_postUrl),
            body: {
              'user_id': _userIdController.text.trim(),
              'course_name': _selectedCourseName!,
              'semester_no': _selectedSemester!,
              'credit_hours': _selectedCreditHours!,
              'marks': _marksController.text.trim(),
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        setState(() {
          _isSuccess = true;
          _responseMessage = 'Data Submitted Successfully!';

          // Add the new record to the gradesData list
          final newRecord = {
            'id': DateTime.now().millisecondsSinceEpoch, // Dummy ID for now
            'user_id': _userIdController.text.trim(),
            'course_name': _selectedCourseName!,
            'semester_no': _selectedSemester!,
            'credit_hours': _selectedCreditHours!,
            'marks': _marksController.text.trim(),
          };

          // Add new record at the top of the list
          _gradesData.insert(0, newRecord);
        });

        // Reset the form and inputs
        _formKey.currentState!.reset();
        _userIdController.clear();
        _marksController.clear();
        _selectedCourseName = null;
        _selectedSemester = null;
        _selectedCreditHours = null;
      } else {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _isSuccess = false;
          _responseMessage = jsonResponse['message'] ?? 'Submission failed.';
        });
      }
    } catch (e) {
      setState(() {
        _isSuccess = false;
        _responseMessage = 'Error: $e';
      });
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _fetchData() async {
    setState(() => _isFetching = true);

    try {
      final response = await http
          .get(Uri.parse(_getUrl))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          setState(() => _gradesData = jsonData);
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          setState(() => _gradesData = jsonData['data']);
        } else {
          setState(() {
            _responseMessage = 'Unexpected response format';
            _gradesData = [];
          });
        }
      } else {
        setState(() {
          _responseMessage = 'Failed to load data';
          _gradesData = [];
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: $e';
        _gradesData = [];
      });
    } finally {
      setState(() => _isFetching = false);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert into API'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _userIdController,
                        decoration: InputDecoration(
                          labelText: 'User ID',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) => value!.isEmpty ? 'Enter User ID' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownSearch<String>(
                        popupProps: const PopupProps.menu(showSearchBox: true),
                        items: _courseNames,
                        selectedItem: _selectedCourseName,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Select Course",
                            prefixIcon: const Icon(Icons.book),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() => _selectedCourseName = value);
                        },
                        validator: (value) => value == null ? 'Select a course' : null,
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedSemester,
                        decoration: InputDecoration(
                          labelText: 'Semester',
                          prefixIcon: const Icon(Icons.school),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _semesterOptions
                            .map((semester) => DropdownMenuItem(
                                  value: semester,
                                  child: Text('Semester $semester'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedSemester = value);
                        },
                        validator: (value) => value == null ? 'Select semester' : null,
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedCreditHours,
                        decoration: InputDecoration(
                          labelText: 'Credit Hours',
                          prefixIcon: const Icon(Icons.timer),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _creditHourOptions
                            .map((hours) => DropdownMenuItem(
                                  value: hours,
                                  child: Text('$hours Hours'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedCreditHours = value);
                        },
                        validator: (value) => value == null ? 'Select credit hours' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _marksController,
                        decoration: InputDecoration(
                          labelText: 'Marks',
                          prefixIcon: const Icon(Icons.grade),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty ? 'Enter marks' : null,
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isSubmitting ? null : _submitData,
                          child: _isSubmitting
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Submit', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Submitted Grades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _fetchData,
                ),
              ],
            ),
            const SizedBox(height: 10),

            _isFetching
                ? const Center(child: CircularProgressIndicator())
                : _gradesData.isEmpty
                    ? const Center(child: Text('No data found'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _gradesData.length,
                        itemBuilder: (context, index) {
                          final item = _gradesData[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(item['course_name'] ?? 'No Course'),
                              subtitle: Text('Marks: ${item['marks']} | Semester: ${item['semester_no']}'),
                              leading: const Icon(Icons.school),
                              trailing: Text('${item['credit_hours']} c-hrs'),
                            ),
                          );
                        },
                      ),

            const SizedBox(height: 20),
            if (_responseMessage.isNotEmpty)
              Center(
                child: Text(
                  _responseMessage,
                  style: TextStyle(
                    color: _isSuccess ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
