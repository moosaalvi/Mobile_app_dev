import 'package:flutter/material.dart';

class GradeBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text(
            "Grade Book",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Student Grades",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.blueGrey.shade100),
                  children: [
                    tableCell("Subject", true),
                    tableCell("Grade", true),
                    tableCell("Marks", true),
                  ],
                ),
                tableRow("Mobile App Dev", "A", "83"),
                tableRow("AI", "A", "81"),
                tableRow("Database-System", "A", "80"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow tableRow(String subject, String grade, String marks) {
    return TableRow(
      children: [
        tableCell(subject, false),
        tableCell(grade, false),
        tableCell(marks, false),
      ],
    );
  }

  Widget tableCell(String text, bool isHeader) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}