import 'dart:convert';

import 'package:frontend/model.dart';
import 'package:http/http.dart' as http;

class Connector {
  static const baseURL = "http://localhost:3000/expenses";

  Future<List<Expense>> getTasks() async {
    try {
      final http.Response res = await http.get(Uri.parse(baseURL));
      if (res.statusCode != 200) {
        throw Exception('Failed to load tasks: ${res.statusCode}');
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
// edit
  Future<void> editTask(String id, {String? title, double? amount, ExpenseCategory? category, DateTime? date}) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final Map<String, dynamic> updateData = {};
      if (title != null && title.isNotEmpty) {
        updateData['title'] = title;
      }
      if (amount != null) {
        updateData['amount'] = amount;
      }
      if (category != null) {
        updateData['category'] = category.label;
      }
      if (date != null) {
        updateData['date'] =
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }

      final response = await http.patch(
        Uri.parse('$baseURL/$id'),
        headers: headers,
        body: jsonEncode(updateData),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to update expense: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating expense: $e');
    }
  }

  // Filter expense by category
  Future<List<Expense>> filterByCategory(ExpenseCategory category) async {
    try {
      final http.Response res = await http.get(
        Uri.parse('$baseURL?category=${category.label}'),
      );
      if (res.statusCode != 200) {
        throw Exception('Failed to load expenses: ${res.statusCode}');
      }
      final dynamic decoded = jsonDecode(res.body);
      final List<dynamic> data = decoded is List ? decoded : const [];
      return data
          .map((json) => Expense.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Could not connect to the server or filter expenses.');
    }
  }
}