import 'dart:convert';

import 'package:frontend/model.dart';
import 'package:http/http.dart' as http;

class Connector {
  static const String baseUrl = 'http://localhost:3000/expense';

  Future<List<Expense>> getExpense() async {
    try {
      final http.Response res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode != 200) {
        throw Exception('Failed to load expenses: ${res.statusCode}');
      }
      final dynamic decoded = jsonDecode(res.body);
      final List<dynamic> data = decoded is List ? decoded : const [];
      return data
          .map((json) => Expense.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Could not connect to the server.');
    }
  }


  // Add a new expense.
  Future<void> addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    DateTime? date,
  }) async {
    final String cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw Exception('Error: Invalid title');
    }
    if (amount <= 0) {
      throw Exception('Error: Invalid amount');
    }

    try {
      final headers = {'Content-Type': 'application/json'};
      final expense = Expense(
        id: '',
        title: cleanTitle,
        amount: amount,
        category: category,
        date: date ?? DateTime.now(),
      );
      final body = jsonEncode(expense.toJson());
      final http.Response res = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: body,
      );
      if (res.statusCode != 201) {
        throw Exception('Failed to add expense: ${res.statusCode}');
      }
    } catch (_) {
      throw Exception('Could not connect to the server.');
    }
  }
}
