import 'package:coba_shelf/db/base_db.dart';
import 'package:sqlite3/sqlite3.dart';

class SqliteDB implements BaseDbDriver {
  final Database db;

  SqliteDB({required this.db});

  @override
  Future delete({required String table, covariant id}) async {
    db.execute('Delete from $table where id=$id');

    return 1;
  }

  @override
  Future<int> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    final dataValues = <Object>[];
    final dataKeys = <String>[];
    for (var map in data.entries) {
      if (map.value == null) {
        continue;
      }

      dataKeys.add(map.key);
      if (map.value is String) {
        dataValues.add('"${map.value}"');
      } else {
        dataValues.add(map.value);
      }
    }

    final statement =
        'INSERT INTO $table(${dataKeys.join(', ')}) VALUES(${dataValues.join(', ')})';

    db.execute(statement);

    return 1;
  }

  @override
  Future<ResultSet> select({
    required String table,
    List? columns,
    Map? where,
  }) async {
    var selection = '*';
    var whereClause = '';

    if (columns != null) {
      selection = '';
      selection = columns.join(',');
    }

    if (where != null) {
      whereClause =
          'WHERE ${where.entries.first.key}=\'${where.entries.first.value}\'';
    }

    final statement = 'select $selection from $table $whereClause';

    final query = db.select(statement);

    return query;
  }

  @override
  Future update({
    required String table,
    required int id,
    required Map data,
  }) async {
    final updatedSet = <String>[];

    for (var e in data.entries) {
      dynamic val;

      if (e.value is String) {
        val = "'${e.value}'";
      } else {
        val = e.value;
      }

      final unit = '${e.key}=$val';
      updatedSet.add(unit);
    }

    final stringifySet = updatedSet.join(', ');

    final statement = 'UPDATE $table SET $stringifySet WHERE id=$id';

    print(statement);

    db.execute(statement);

    return 1;
  }

  Future execute(String query) async {
    return db.execute(query);
  }
}
