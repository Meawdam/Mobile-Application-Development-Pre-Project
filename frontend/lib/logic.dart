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
        Uri.parse('$baseUrl/$id'),
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
        Uri.parse('$baseUrl?category=${category.label}'),
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

  double totalExpenses(List<Expense> expenses) {
    return expenses.fold(0.0, (total, expense) => total + expense.amount);
  }

  Future<Expense> searchExpenseByIndex(int index) async {
    final expenses = await getExpense();
    if (index < 1 || index > expenses.length) {
      throw Exception('Index out of range');
    }
    return expenses[index - 1];
  }

  Future<void> deleteExpenseByIndex(int index) async {
    final expense = await searchExpenseByIndex(index);

    try {
      final http.Response res = await http.delete(
        Uri.parse('$baseUrl/${expense.id}'),
      );
      if (res.statusCode != 200) {
        throw Exception('Failed to delete expense: ${res.statusCode}');
      }
    } catch (_) {
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
