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
    // edit expense
  Future<void> editTask(
    String id, {
    String? newTitle,
    double? newAmount,
    ExpenseCategory? newCategory,
    DateTime? newDate,
  }) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final Map<String, dynamic> updateData = {};

      if (newTitle != null && newTitle.isNotEmpty) {
        updateData['title'] = newTitle;
      }
      if (newAmount != null) {
        updateData['amount'] = newAmount;
      }
      if (newCategory != null) {
        updateData['category'] = newCategory.label;
      }
      if (newDate != null) {
        updateData['date'] =
            '${newDate.year.toString().padLeft(4, '0')}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}';
      }

      final body = jsonEncode(updateData);
      final response = await http.patch(
        Uri.parse('$baseURL/$id'),
        headers: headers,
        body: body,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to edit task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  // Filter expense by category
  Future<List<Expense>> filterExpenses(ExpenseCategory category) async {
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