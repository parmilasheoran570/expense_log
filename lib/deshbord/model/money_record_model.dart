class MoneyRecord {
  int? id;
  String title;
  double amount;
  String category;
  int date;
  MoneyRecordType type;

  MoneyRecord({ this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.type = MoneyRecordType.expense,});

  factory MoneyRecord.fromJson(Map<String, dynamic> json) {
    return MoneyRecord(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: json['date'],
      type: MoneyRecordType.values.firstWhere(
            (e) => e.toString() == json["type"],
    orElse: ()=>MoneyRecordType.expense),
    );
  }
}
enum MoneyRecordType { income, expense, all }