import 'package:frontend/model.dart';
import 'package:test/test.dart';

void main() {
  test('1. Create an expense should have expense data', () {
    final expense = Expense(
      id: '1',
      title: 'Dinner',
      amount: 50,
      category: ExpenseCategory.food,
      date: DateTime(2026, 8, 26),
    );

    expect(expense.id, '1');
    expect(expense.title, 'Dinner');
    expect(expense.amount, 50.0);
  });

  test('2. Get expense should return an expense', () {
    final expense = Expense(
      id: '1',
      title: 'Dinner',
      amount: 50,
      category: ExpenseCategory.food,
      date: DateTime(2026, 8, 26),
    );

    expect(expense.formattedDate, '2026-08-26');
  });
}
