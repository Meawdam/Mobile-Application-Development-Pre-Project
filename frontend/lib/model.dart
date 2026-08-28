enum ExpenseCategory {
  food('food', '🍔'),
  transportation('transportation', '🚗'),
  shopping('shopping', '🛍️'),
  others('others', '📦');

  const ExpenseCategory(this.label, this.icon);

  final String label;
  final String icon;

  static ExpenseCategory? fromMenuChoice(int choice) {
    if (choice < 1 || choice > values.length) return null;
    return values[choice - 1];
  }

  static ExpenseCategory fromLabel(String value) {
    final cleanValue = value.trim().toLowerCase();
    return ExpenseCategory.values.firstWhere(
      (category) =>
          category.label == cleanValue || category.icon == value.trim(),
      orElse: () => ExpenseCategory.others,
    );
  }
}

class Expense {
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;

  String get formattedDate {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  @override
  String toString() => '$title | $amount | ${category.icon} | $formattedDate';

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'category': category.label,
    'date': formattedDate,
  };

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? ''}',
      amount: switch (json['amount']) {
        num amount => amount.toDouble(),
        _ => double.tryParse('${json['amount'] ?? ''}') ?? 0,
      },
      category: ExpenseCategory.fromLabel('${json['category'] ?? 'others'}'),
      date: DateTime.tryParse('${json['date'] ?? ''}') ?? DateTime.now(),
    );
  }
}
