import 'package:coba_shelf/db/base_db.dart';
import 'package:sqlite3/sqlite3.dart';

class SqliteDB implements BaseDbDriver {
  final Database db;

  @override
  final String table;

  SqliteDB({required this.db, required this.table});

  @override
  Future delete({covariant id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future insert({Map data}) {
    final query = db.execute('INSERT INTO $table values(?)',data.entries.map((e) => e.first.value));
  }

  @override
  Future select({
    List? columns,
    Map where,
  }) async {
    var selection = '*';
    var whereClause = '';

    if (columns != null) {
      selection = '';
      columns.forEach((element) => selection = '$selection, $element');
    }

    if(where != null ) {
      whereClause = 'WHERE ${where.entries.first.key}=${where.entries.first.value}'; 
    }

    final query = db.select('select $selection from $table');

    return query;
  }

  @override
  Future update({covariant id}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future execute(String query) {
    await db.execute(query);
  }

}
