import 'dart:convert';
import 'dart:io';

import 'package:async_json/book.dart';

/// 主入口：异步读取 data/books.json，解析为 List<Book>，
/// 输出 总数 / 各类目数量 / 借阅量 Top3。
/// 含异常处理：文件缺失友好提示、字段缺失默认值、finally 释放提示。
Future<void> main(List<String> arguments) async {
  final file = File('data/books.json');
  try {
    final content = await file.readAsString();
    final raw = jsonDecode(content) as List<dynamic>;
    final books = raw
        .map((e) => Book.fromJson(e as Map<String, dynamic>))
        .toList();

    print('共解析到 ${books.length} 本书');
    print('--------------------');

    // 各类目数量：使用 fold 聚合（不写 for 循环统计）。
    final categoryCount =
        books.fold<Map<String, int>>(<String, int>{}, (acc, b) {
      acc[b.category] = (acc[b.category] ?? 0) + 1;
      return acc;
    });
    print('各类目数量：');
    categoryCount.forEach((cat, n) => print('  $cat: $n 本'));
    print('--------------------');

    // 借阅量 Top3：复制后按 borrowCount 降序排序，取前 3。
    final top3 = [...books]
      ..sort((a, b) => b.borrowCount.compareTo(a.borrowCount));
    print('借阅量 Top3：');
    top3.take(3).forEach((b) => print('  ${b.title} - ${b.borrowCount} 次'));
  } on FileSystemException catch (e) {
    // 文件缺失：友好提示，不崩溃。
    print('数据文件缺失，请检查 data/books.json（详情：$e）');
  } catch (e) {
    // 其他异常（如 JSON 格式错误）。
    print('解析失败：$e');
  } finally {
    print('（程序结束，资源已释放）');
  }
}
