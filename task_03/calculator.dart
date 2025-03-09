import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  double result = 0;
  TextEditingController num1Controller = TextEditingController();
  TextEditingController num2Controller = TextEditingController();
  String operation = 'Add';

  void calculate() {
    double num1 = double.tryParse(num1Controller.text) ?? 0;
    double num2 = double.tryParse(num2Controller.text) ?? 0;

    setState(() {
      switch (operation) {
        case 'Add':
          result = num1 + num2;
          break;
        case 'Subtract':
          result = num1 - num2;
          break;
        case 'Multiply':
          result = num1 * num2;
          break;
        case 'Divide':
          result = num2 != 0 ? num1 / num2 : 0;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Calculator", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Result: $result", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                _buildTextField(num1Controller, "Enter first number"),
                _buildTextField(num2Controller, "Enter second number"),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: operation,
                  onChanged: (newValue) {
                    setState(() {
                      operation = newValue!;
                    });
                  },
                  items: ["Add", "Subtract", "Multiply", "Divide"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: calculate,
                  child: Text("Calculate"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
