import 'package:http/http.dart' as http;
import 'dart:convert';

class SheetService {
  final String webAppUrl =
      "https://script.google.com/macros/s/AKfycbxn0Y4b4zFBsP9kLrx09Yv1Nh5u8cJmTR6n3UxyAsC9doUjMfUTDQzTYrZGDkZgzUxU/exec";
  final String spreadsheetId =
      "1bnzFmFofgu9_Jt2OE_qZisPCvJYm7xWXk6WJpfP4qMA";
  final String sheetName = "cpysheet";

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
}
