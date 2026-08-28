import 'package:frontend/logic.dart';
import 'package:frontend/model.dart';
import 'package:test/test.dart';

void main() {
  test('1. Show expenses should return expenses', () async {
    final connector = Connector();
    final expenses = await connector.getExpense();

    expect(expenses, isNotEmpty);
  });

  test('2. Add new expense should add an expense', () async {
    final connector = Connector();
    await connector.addExpense(
      title: 'Game items',
      amount: 99,
      category: ExpenseCategory.others,
      date: DateTime(2026, 8, 28),
    );

    final expenses = await connector.getExpense();
    expect(expenses.last.title, 'Game items');
  });

  test('3. Edit expense should update an expense', () async {
    final connector = Connector();
    final expense = (await connector.getExpense()).first;

    await connector.editTask(expense.id, newTitle: 'Updated expense');
    final updatedExpense = (await connector.getExpense()).firstWhere(
      (item) => item.id == expense.id,
    );
    expect(updatedExpense.title, 'Updated expense');

    await connector.editTask(expense.id, newTitle: expense.title);
  });

  test('4. Delete expense should remove an expense by index', () async {
    final connector = Connector();
    final beforeDelete = await connector.getExpense();

    await connector.addExpense(
      title: 'Delete test expense',
      amount: 1,
      category: ExpenseCategory.others,
      date: DateTime(2026, 8, 28),
    );
    final afterAdd = await connector.getExpense();
    await connector.deleteExpenseByIndex(afterAdd.length);

    expect((await connector.getExpense()).length, beforeDelete.length);
  });

  test('5. Search expense should return an expense by index', () async {
    final connector = Connector();
    final expense = await connector.searchExpenseByIndex(1);

    expect(expense, isA<Expense>());
  });

  test('6. Filter expense by category should return matching expenses', () async {
    final connector = Connector();
    final expenses = await connector.filterExpenses(ExpenseCategory.food);

    for (final expense in expenses) {
      expect(expense.category, ExpenseCategory.food);
    }
  });

  test('7. Today expenses should only return today expenses', () async {
    final connector = Connector();
    final expenses = await connector.getTodayExpenses();
    final today = DateTime.now();

    for (final expense in expenses) {
      expect(expense.date.year, today.year);
      expect(expense.date.month, today.month);
      expect(expense.date.day, today.day);
    }
  });

  test('8. Total expenses should return the correct amount', () {
    final connector = Connector();
    final expenses = [
      Expense(
        id: '1',
        title: 'Dinner',
        amount: 50,
        category: ExpenseCategory.food,
        date: DateTime(2026, 8, 26),
      ),
      Expense(
        id: '2',
        title: 'Shoes',
        amount: 200,
        category: ExpenseCategory.shopping,
        date: DateTime(2026, 8, 26),
      ),
      Expense(
        id: '3',
        title: 'Game items',
        amount: 134,
        category: ExpenseCategory.others,
        date: DateTime(2026, 8, 28),
      ),
    ];

    expect(connector.totalExpenses(expenses), 384.0);
  });

  test('9. Average in a day should return the correct amount', () {
    final connector = Connector();
    final expenses = [
      Expense(
        id: '1',
        title: 'Shoes',
        amount: 200,
        category: ExpenseCategory.shopping,
        date: DateTime(2026, 8, 26),
      ),
      Expense(
        id: '2',
        title: 'Game items',
        amount: 99,
        category: ExpenseCategory.others,
        date: DateTime(2026, 8, 26),
      ),
    ];

    expect(connector.averageExpensesInDay(expenses), 149.5);
  });
}
