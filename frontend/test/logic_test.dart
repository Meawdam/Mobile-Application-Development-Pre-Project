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

  test('6.1 Edit expense partially should only update provided fields', () async {
    final Connector connector = Connector();

    // ดึงข้อมูลเดิมของ id: '1'
    final initialExpenses = await connector.getExpense();
    final initialItem = initialExpenses.firstWhere((e) => e.id == '1');

    // อัปเดตเฉพาะชื่อ (title) อย่างเดียว
    await connector.editTask('1', newTitle: 'Partial Title Update');

    final updatedExpenses = await connector.getExpense();
    final updatedItem = updatedExpenses.firstWhere((e) => e.id == '1');

    expect(updatedItem.title, 'Partial Title Update');
    expect(updatedItem.amount, initialItem.amount);
    expect(updatedItem.category, initialItem.category);

    // คืนค่าเดิม
    await connector.editTask('1', newTitle: initialItem.title);
  });

  test('6.2 Edit non-existing expense should throw exception', () async {
    final Connector connector = Connector();

    expect(
      () async => await connector.editTask('non-existing-id-999', newTitle: 'Invalid'),
      throwsA(isA<Exception>()),
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

  test('7.1 Filter expenses for category without matches should return empty list or valid list', () async {
    final Connector connector = Connector();
    final List<Expense> results = await connector.filterExpenses(ExpenseCategory.others);

    expect(results, isA<List<Expense>>());
    for (final item in results) {
      expect(item.category, ExpenseCategory.others);
    }
  });

  test('7.2 ExpenseCategory fromMenuChoice should map correctly and return null for invalid choices', () {
    expect(ExpenseCategory.fromMenuChoice(1), ExpenseCategory.food);
    expect(ExpenseCategory.fromMenuChoice(2), ExpenseCategory.transportation);
    expect(ExpenseCategory.fromMenuChoice(3), ExpenseCategory.shopping);
    expect(ExpenseCategory.fromMenuChoice(4), ExpenseCategory.others);
    expect(ExpenseCategory.fromMenuChoice(0), isNull);
    expect(ExpenseCategory.fromMenuChoice(5), isNull);
    expect(ExpenseCategory.fromMenuChoice(-1), isNull);
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
