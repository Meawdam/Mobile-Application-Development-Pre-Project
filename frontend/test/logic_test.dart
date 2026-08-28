import 'package:frontend/logic.dart';
import 'package:frontend/model.dart';
import 'package:test/test.dart';

void main() {
  test('1. Get expense should return an expense', () async {
    final Connector connector = Connector();
    final List<Expense> data = await connector.getExpense();

    expect(data[0].id, '1');
    expect(data[0].title, 'Dinner');
    expect(data[0].amount, 50.0);
    expect(data[0].category, ExpenseCategory.food);
  });

  test('2. Add expense should have a new expense', () async {
    final Connector connector = Connector();
    await connector.addExpense(
      title: 'Game items',
      amount: 99,
      category: ExpenseCategory.others,
      date: DateTime(2026, 8, 28),
    );

    final List<Expense> data = await connector.getExpense();
    expect(data.last.title, 'Game items');
    expect(data.last.amount, 99.0);
    expect(data.last.category, ExpenseCategory.others);
  });

    test('3. Total expenses should return the correct amount', () {
    final Connector connector = Connector();

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

    final double total = expenses.fold(
      0,
      (sum, expense) => sum + expense.amount,
    );

    expect(total, 384.0);
  });

  // 7. Today expenses
  test('7. Get today expenses should return today expenses', () async {
    final Connector connector = Connector();

    final List<Expense> expenses =
        await connector.getTodayExpenses();

    final DateTime today = DateTime.now();

    for (final expense in expenses) {
      expect(expense.date.year, today.year);
      expect(expense.date.month, today.month);
      expect(expense.date.day, today.day);
    }
  });

  // 9. Evaluate expenses by selected date
  test(
    '9. Get expenses by selected date should return correct expenses',
    () async {
      final Connector connector = Connector();

      final DateTime selectedDate = DateTime(2026, 8, 28);

      final List<Expense> expenses =
          await connector.getExpensesByDate(selectedDate);

      for (final expense in expenses) {
        expect(expense.date.year, selectedDate.year);
        expect(expense.date.month, selectedDate.month);
        expect(expense.date.day, selectedDate.day);
      }
    },
  );
}