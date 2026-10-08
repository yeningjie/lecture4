/// Book 实体类：对应 books.json 中的一条图书记录。
class Book {
  final String id;
  final String title;
  final String category;
  final int borrowCount;

  Book({
    required this.id,
    required this.title,
    required this.category,
    required this.borrowCount,
  });

  /// 从 JSON Map 构造 Book（正向解析）。
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      borrowCount: json['borrowCount'] as int,
    );
  }

  /// 反向验证：把 Book 再序列化回 Map，确认字段完整。
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'borrowCount': borrowCount,
      };

  @override
  String toString() => 'Book($id, 《$title》, $category, 借阅$borrowCount)';
}
