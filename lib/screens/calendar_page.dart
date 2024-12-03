

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:excel/excel.dart'; // For reading Excel files
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Map<String, String>> _seminarDetails = [];

  @override
  void initState() {
    super.initState();
    loadSeminarData();
  }

  Future<void> loadSeminarData() async {
    try {
      final bytes = await rootBundle.load('assets/Updated_Cleaned_Final_Table.xlsx');
      final excel = Excel.decodeBytes(bytes.buffer.asUint8List());

      List<Map<String, String>> data = [];

      final String sheetName = excel.tables.keys.first;
      final sheet = excel.tables[sheetName];

      if (sheet != null) {
        final headers = sheet.rows.first.map((e) => e?.value?.toString()).toList();
        for (int i = 1; i < sheet.rows.length; i++) {
          final row = sheet.rows[i];
          final Map<String, String> rowData = {};
          for (int j = 0; j < headers.length; j++) {
            rowData[headers[j] ?? ''] = row[j]?.value?.toString() ?? '';
          }
          data.add(rowData);
        }
      }

      setState(() {
        _seminarDetails = data;
      });
    } catch (e) {
      print("Error reading Excel file: $e");
    }
  }

  List<Map<String, String>> getSeminarsForDate(DateTime date) {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return _seminarDetails.where((seminar) {
      final dateStr = seminar['Date'];
      if (dateStr != null) {
        try {
          final parsedDate = DateFormat('MMMM d yyyy').parse(dateStr);
          final String formattedSeminarDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          return formattedSeminarDate == formattedDate;
        } catch (e) {
          print('Error parsing seminar date: $e');
          return false;
        }
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final seminarsForSelectedDate = getSeminarsForDate(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seminar Calendar',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF222222), // Dark background for AppBar
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Calendar Widget
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent.shade200,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                weekendTextStyle: const TextStyle(color: Colors.redAccent),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: const TextStyle(color: Colors.white),
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seminars for Selected Date
            Expanded(
              child: seminarsForSelectedDate.isEmpty
                  ? Center(
                child: Text(
                  'No seminars for the selected date.',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                  ),
                ),
              )
                  : Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: seminarsForSelectedDate.length,
                  itemBuilder: (context, index) {
                    final seminar = seminarsForSelectedDate[index];
                    return Container(
                      decoration: BoxDecoration(
                        // Gradient background similar to your requested style
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            seminar['Title of the Seminar'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white, // White text for visibility
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Presenter: ${seminar['Presenter']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // White text for visibility
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Time: ${seminar['Time']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // White text for visibility
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Location: ${seminar['Location']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // White text for visibility
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            seminar['Abstract'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white, // White text for visibility
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

