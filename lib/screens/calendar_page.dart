// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// class CalendarPage extends StatefulWidget {
//   const CalendarPage({super.key});
//
//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }
//
// class _CalendarPageState extends State<CalendarPage> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _selectedDay = DateTime.now();
//   DateTime _focusedDay = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TableCalendar(
//               firstDay: DateTime.utc(2020, 1, 1),
//               lastDay: DateTime.utc(2030, 12, 31),
//               focusedDay: _focusedDay,
//               calendarFormat: _calendarFormat,
//               selectedDayPredicate: (day) {
//                 return isSameDay(_selectedDay, day);
//               },
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               },
//               onFormatChanged: (format) {
//                 if (_calendarFormat != format) {
//                   setState(() {
//                     _calendarFormat = format;
//                   });
//                 }
//               },
//               onPageChanged: (focusedDay) {
//                 _focusedDay = focusedDay;
//               },
//               calendarStyle: CalendarStyle(
//                 todayDecoration: BoxDecoration(
//                   color: Colors.blueAccent,
//                   shape: BoxShape.circle,
//                 ),
//                 selectedDecoration: BoxDecoration(
//                   color: Colors.deepPurple,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               headerStyle: HeaderStyle(
//                 formatButtonVisible: true,
//                 titleCentered: true,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:excel/excel.dart'; // For reading Excel files
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:intl/intl.dart';
//
// class CalendarPage extends StatefulWidget {
//   const CalendarPage({super.key});
//
//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }
//
// class _CalendarPageState extends State<CalendarPage> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _selectedDay = DateTime.now();
//   DateTime _focusedDay = DateTime.now();
//   List<Map<String, String>> _seminarDetails = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadSeminarData();
//   }
//
//
//   Future<void> loadSeminarData() async {
//     try {
//       // Load the Excel file as bytes
//       final bytes = await rootBundle.load('assets/Cleaned_Final_Table.xlsx');
//       final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
//
//       List<Map<String, String>> data = [];
//
//       // Read data from the first sheet
//       final String sheetName = excel.tables.keys.first;
//       final sheet = excel.tables[sheetName];
//
//       if (sheet != null) {
//         final headers = sheet.rows.first.map((e) => e?.value?.toString()).toList();
//         for (int i = 1; i < sheet.rows.length; i++) {
//           final row = sheet.rows[i];
//           final Map<String, String> rowData = {};
//           for (int j = 0; j < headers.length; j++) {
//             rowData[headers[j] ?? ''] = row[j]?.value?.toString() ?? '';
//           }
//           data.add(rowData);
//         }
//       }
//
//       setState(() {
//         _seminarDetails = data;
//         print('data $data');
//       });
//     } catch (e) {
//       print("Error reading Excel file: $e");
//     }
//   }
//
//
//
//   List<Map<String, String>> getSeminarsForDate(DateTime date) {
//     // Format the selected date into yyyy-MM-dd
//     final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
//     print('formattedDate: $formattedDate');
//
//     return _seminarDetails.where((seminar) {
//       final dateStr = seminar['Date']; // The seminar date is in the format 'MMMM d yyyy'
//       if (dateStr != null) {
//         try {
//           // Parse the seminar date from "Month day, year" format (e.g., "October 1 2024")
//           final parsedDate = DateFormat('MMMM d yyyy').parse(dateStr);
//
//           // Format the parsed seminar date into yyyy-MM-dd for comparison
//           final String formattedSeminarDate = DateFormat('yyyy-MM-dd').format(parsedDate);
//
//
//           // Compare the formatted dates
//           return formattedSeminarDate == formattedDate;
//         } catch (e) {
//           print('Error parsing seminar date: $e');
//           return false; // If there's an error parsing the seminar date, exclude it
//         }
//       }
//       return false;
//     }).toList();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final seminarsForSelectedDate = getSeminarsForDate(_selectedDay);
//    print("seminarsForSelectedDate $seminarsForSelectedDate");
//     return Scaffold(
//       appBar: AppBar(title: const Text('Seminar Calendar')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TableCalendar(
//               firstDay: DateTime.utc(2020, 1, 1),
//               lastDay: DateTime.utc(2030, 12, 31),
//               focusedDay: _focusedDay,
//               calendarFormat: _calendarFormat,
//               selectedDayPredicate: (day) {
//                 return isSameDay(_selectedDay, day);
//               },
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               },
//               onFormatChanged: (format) {
//                 if (_calendarFormat != format) {
//                   setState(() {
//                     _calendarFormat = format;
//                   });
//                 }
//               },
//               onPageChanged: (focusedDay) {
//                 _focusedDay = focusedDay;
//               },
//               calendarStyle: const CalendarStyle(
//                 todayDecoration: BoxDecoration(
//                   color: Colors.blueAccent,
//                   shape: BoxShape.circle,
//                 ),
//                 selectedDecoration: BoxDecoration(
//                   color: Colors.deepPurple,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               headerStyle: const HeaderStyle(
//                 formatButtonVisible: true,
//                 titleCentered: true,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: seminarsForSelectedDate.isEmpty
//                   ? const Center(child: Text('No seminars for the selected date.'))
//                   : ListView.builder(
//                 itemCount: seminarsForSelectedDate.length,
//                 itemBuilder: (context, index) {
//                   final seminar = seminarsForSelectedDate[index];
//                   return Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Title: ${seminar['Title of the Seminar']}',
//                               style: const TextStyle(fontWeight: FontWeight.bold)),
//                           Text('Presenter: ${seminar['Presenter']}'),
//                           Text('Time: ${seminar['Time']}'),
//                           Text('Date: ${seminar['Date']}'),
//                           Text('Location: ${seminar['Location']}'),
//                           Text('Abstract: ${seminar['Abstract']}'),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

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
      // Load the Excel file as bytes
      final bytes = await rootBundle.load('assets/Cleaned_Final_Table.xlsx');
      final excel = Excel.decodeBytes(bytes.buffer.asUint8List());

      List<Map<String, String>> data = [];

      // Read data from the first sheet
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
        print('data $data');
      });
    } catch (e) {
      print("Error reading Excel file: $e");
    }
  }

  List<Map<String, String>> getSeminarsForDate(DateTime date) {
    // Format the selected date into yyyy-MM-dd
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    print('formattedDate: $formattedDate');

    return _seminarDetails.where((seminar) {
      final dateStr = seminar['Date']; // The seminar date is in the format 'MMMM d yyyy'
      if (dateStr != null) {
        try {
          // Parse the seminar date from "Month day, year" format (e.g., "October 1 2024")
          final parsedDate = DateFormat('MMMM d yyyy').parse(dateStr);

          // Format the parsed seminar date into yyyy-MM-dd for comparison
          final String formattedSeminarDate = DateFormat('yyyy-MM-dd').format(parsedDate);

          // Compare the formatted dates
          return formattedSeminarDate == formattedDate;
        } catch (e) {
          print('Error parsing seminar date: $e');
          return false; // If there's an error parsing the seminar date, exclude it
        }
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final seminarsForSelectedDate = getSeminarsForDate(_selectedDay);
    print("seminarsForSelectedDate $seminarsForSelectedDate");

    return Scaffold(
      appBar: AppBar(title: const Text('Seminar Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: seminarsForSelectedDate.isEmpty
                  ? const Center(child: Text('No seminars for the selected date.'))
                  : Scrollbar(
                thumbVisibility: true, // This ensures the scrollbar is always visible when needed
                child: ListView.builder(
                  itemCount: seminarsForSelectedDate.length,
                  itemBuilder: (context, index) {
                    final seminar = seminarsForSelectedDate[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title: ${seminar['Title of the Seminar']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Presenter: ${seminar['Presenter']}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Time: ${seminar['Time']}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Location: ${seminar['Location']}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Abstract: ${seminar['Abstract']}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blueGrey),
                            ),
                          ],
                        ),
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
