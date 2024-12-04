import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/enquiries.json');
  }

  static Future<List<Map<String, dynamic>>> readEnquiries() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(content));
    }
    return [];
  }

  static Future<void> saveEnquiry(Map<String, dynamic> enquiry) async {
    final file = await _getLocalFile();
    List<dynamic> existingData = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      existingData = jsonDecode(content);
    }

    existingData.add(enquiry);
    await file.writeAsString(jsonEncode(existingData));
  }
}
