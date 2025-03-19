import 'package:http/http.dart' as http;
import 'dart:convert';

class SheetService {
  // Replace with your actual web app URL and spreadsheet details.
  final String webAppUrl =
      "https://script.google.com/macros/s/AKfycbyOnjLoAY0ZmWRzl-9jEoa23v7y9OtWCerx3Wqto18LU63IRybLOI3QaL2tX4EzYd_Aog/exec";
  final String spreadsheetId = "1bnzFmFofgu9_Jt2OE_qZisPCvJYm7xWXk6WJpfP4qMA";
  final String sheetName = "cpysheet";

  /// Updates the sheet with provided values.
  Future<http.Response> updateSheet({
    required double bedWidth,
    required double bedLength,
    required double plantDistance,
  }) async {
    String webAppUrl2 =
        "https://script.google.com/macros/s/AKfycbzJkVr3D7SrqBBO_vmWFTI7yfEBUOuno1bzO12PhdgsC7WbZ7FDs1wCpVE3OJ_yb9HZ/exec";
    final uri = Uri.parse(webAppUrl2);
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
