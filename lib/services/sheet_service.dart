import 'package:http/http.dart' as http;
import 'dart:convert';

class SheetService {
  // Replace with your actual web app URL and spreadsheet details.
  final String webAppUrl =
      "https://script.google.com/macros/s/AKfycbwPIGvx0mtl1YVChJPfaDDsocPyeSV4lZ6AbCGzwbEJyr4_cME9AZBfogh8q4ho9JN7/exec";
  final String spreadsheetId = "1bnzFmFofgu9_Jt2OE_qZisPCvJYm7xWXk6WJpfP4qMA";
  final String sheetName = "cpysheet";

  /// Updates the sheet with provided values.
  Future<http.Response> updateSheet({
    required double bedWidth,
    required double bedLength,
    required double plantDistance,
  }) async {
    final uri = Uri.parse(webAppUrl);
    final payload = json.encode({
      'spreadsheetId': spreadsheetId,
      'sheetName': sheetName,
      'bedWidth': bedWidth,
      'bedLength': bedLength,
      'plantDistance': plantDistance,
    });
    return await http.post(uri, body: payload);
  }

  /// Fetches the sheet data. Assumes the API returns a JSON with keys "B14", "K14", etc.
  Future<Map<String, dynamic>> getSheetData() async {
    final uri = Uri.parse(webAppUrl).replace(queryParameters: {
      'spreadsheetId': spreadsheetId,
      'sheetName': sheetName,
    });
    final response = await http.get(uri);
    print("response is ${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch sheet data");
    }
  }
}
