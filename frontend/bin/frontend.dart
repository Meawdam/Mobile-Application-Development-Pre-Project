import 'dart:io';

import 'package:frontend/logic.dart';
import 'package:frontend/model.dart';

void main() async {
  final connector = Connector();
  print('--- Welcome to the Dart Expense Console ---');
  String? input;

  while (input != '10') {
    showMenu();
    stdout.write('Select an option : ');
    input = stdin.readLineSync();

    switch (input) {
      case '1':
        await showExpense(connector);
        break;
      case '2':
        await addExpense(connector);
        break;
      case '3':
        break;
      case '4':
        break;
      case '5':
        break;
      case '6':
        break;
      case '7':
        try {
          final List<Expense> expenses = await connector.getTodayExpenses();

          print('\n--- Today Expenses ---');

          if (expenses.isEmpty) {
            print('No expenses today.');
          } else {
            for (var (index, expense) in expenses.indexed) {
              print('${index + 1}. $expense');
            }
          }
        } catch (e) {
          print('Error: $e');
        }
        break;
      case '8':
        await showTotalExpenses(connector);
        break;
      case '9':
        try {
          final Map<ExpenseCategory, double> summary = await connector
              .getExpenseSummaryByCategory();

          print('\n--- Expense Summary by Category ---');

          if (summary.isEmpty) {
            print('No expenses found.');
          } else {
            summary.forEach((category, total) {
              print('${category.icon} ${category.label}: $total');
            });
          }
        } catch (e) {
          print('Error: $e');
        }
        break;
      case '10':
        print('Good bye!');
        break;
      default:
        print('Invalid selection, please select only 1-10!');
    }
  }
}

void showMenu() {
  print('\n======== Menu ========');
  print('1. Show expenses');
  print('2. Add new expense');
  print('3. Edit expense');
  print('4. Delete expense');
  print('5. Search expense');
  print('6. Filter expense by category');
  print('7. Today expenses');
  print('8. Total expenses');
  print('9. Your own menu');
  print('10. Exit');
}

Future<void> addExpense(Connector connector) async {
  stdout.write('Enter Title: ');
  final title = stdin.readLineSync() ?? '';

  stdout.write('Enter Amount: ');
  final amount = double.tryParse(stdin.readLineSync() ?? '');
  if (amount == null) {
    print('Error: Invalid amount');
    return;
  }

  stdout.write(
    'Select Category (1:food, 2:transportation, 3:shopping, 4:others): ',
  );
  final categoryChoice = int.tryParse(stdin.readLineSync() ?? '');
  final category = categoryChoice == null
      ? null
      : ExpenseCategory.fromMenuChoice(categoryChoice);
  if (category == null) {
    print('Error: Invalid category');
    return;
  }

  stdout.write('Enter Date (YYYY-MM-DD) or press Enter for today: ');
  final dateInput = stdin.readLineSync() ?? '';
  final date = dateInput.isEmpty ? DateTime.now() : DateTime.tryParse(dateInput);
  if (date == null) {
    print('Error: Invalid date');
    return;
  }

  try {
    await connector.addExpense(
      title: title,
      amount: amount,
      category: category,
      date: date,
    );
    print('Expense added successfully!');
  } on Exception catch (e) {
    print('Error: $e');
  }
}

Future<void> showExpense(Connector connector) async {
  try {
    final List<Expense> expenses = await connector.getExpense();
    if (expenses.isEmpty) {
      print('\nNo expenses found.');
      return;
    }

    print('\n--- All Expenses ---');
    for (var (index, expense) in expenses.indexed) {
      print('${index + 1}. $expense');
    }
  } on Exception catch (e) {
    print('Error: $e');
  }
}

Future<void> showTotalExpenses(Connector connector) async {
  try {
    final expenses = await connector.getExpense();
    final total = connector.totalExpenses(expenses);
    print('\nTotal Expenses: ${total.toStringAsFixed(2)}');
  } on Exception catch (e) {
    print('Error: $e');
  }
}
