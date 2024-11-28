import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;

// Function to load seminar data from an Excel file
Future<List<Map<String, String>>> loadSeminarData(String filePath) async {
  // Load the Excel file as bytes
  final ByteData data = await rootBundle.load(filePath); // Use rootBundle for assets
  final List<int> bytes = data.buffer.asUint8List();

  // Decode the Excel file
  final Excel excel = Excel.decodeBytes(bytes);

  // Extract data from the first sheet
  final Sheet? sheet = excel.tables[excel.tables.keys.first];
  if (sheet == null) {
    throw Exception("No sheet found in Excel file.");
  }

  // Parse rows into a list of maps
  final List<Map<String, String>> seminarData = [];
  for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
    final row = sheet.rows[rowIndex];

    // Map the row data (adjust indices based on your file's column structure)
    seminarData.add({
      'Title': row[0]?.value.toString() ?? '', // Seminar title in 1st column
      'Category': row[8]?.value.toString() ?? '', // Category in 9th column
    });
  }

  return seminarData;
}
