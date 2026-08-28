import 'dart:convert';

import 'package:frontend/model.dart';
import 'package:http/http.dart' as http;

class Connector {
  static const baseURL = "http://localhost:3000/expense";

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

  // 7. Today expenses
Future<List<Expense>> getTodayExpenses() async {
  try {
    final List<Expense> expenses = await getTasks();

    final DateTime today = DateTime.now();

    return expenses.where((expense) {
      return expense.date.year == today.year &&
          expense.date.month == today.month &&
          expense.date.day == today.day;
    }).toList();
  } catch (e) {
    throw Exception('Could not get today expenses.');
  }
}

// 9. Your own menu
// Summary expenses by category
Future<Map<ExpenseCategory, double>> getExpenseSummaryByCategory() async {
  try {
    final List<Expense> expenses = await getTasks();

    final Map<ExpenseCategory, double> summary = {};

    for (final expense in expenses) {
      summary[expense.category] =
          (summary[expense.category] ?? 0) + expense.amount;
    }

    return summary;
  } catch (e) {
    throw Exception('Could not get expense summary.');
  }
}
}
