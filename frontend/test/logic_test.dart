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

    expect(connector.totalExpenses(expenses), 384.0);
  });

  test('4. Search expense by index should return an expense', () async {
    final Connector connector = Connector();
    final Expense expense = await connector.searchExpenseByIndex(1);

    expect(expense.id, '1');
    expect(expense.title, 'Dinner');
  });

  test('5. Delete expense by index should remove an expense', () async {
    final Connector connector = Connector();
    final beforeDelete = await connector.getExpense();

    await connector.addExpense(
      title: 'Delete test expense',
      amount: 1,
      category: ExpenseCategory.others,
      date: DateTime(2026, 8, 28),
    );
    final afterAdd = await connector.getExpense();
    await connector.deleteExpenseByIndex(afterAdd.length);
    final afterDelete = await connector.getExpense();

    expect(afterDelete.length, beforeDelete.length);
  });

  test('6. Edit expense should update fields correctly', () async {
    final Connector connector = Connector();

    // ทดสอบแก้ไขรายการ id: '1'
    await connector.editTask(
      '1',
      newTitle: 'Dinner Buffet',
      newAmount: 299.0,
      newCategory: ExpenseCategory.food,
      newDate: DateTime(2026, 8, 28),
    );

    final expenses = await connector.getExpense();
    final edited = expenses.firstWhere((e) => e.id == '1');

    expect(edited.title, 'Dinner Buffet');
    expect(edited.amount, 299.0);
    expect(edited.category, ExpenseCategory.food);

    // คืนค่าเดิมกลับไป
    await connector.editTask(
      '1',
      newTitle: 'Dinner',
      newAmount: 50.0,
      newCategory: ExpenseCategory.food,
      newDate: DateTime(2026, 8, 28),
    );
  });

  test('7. Filter expenses by category should return only matching category', () async {
    final Connector connector = Connector();
    final List<Expense> foodExpenses = await connector.filterExpenses(ExpenseCategory.food);

    expect(foodExpenses.isNotEmpty, true);
    for (final item in foodExpenses) {
      expect(item.category, ExpenseCategory.food);
    }
  });
}
