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
}
