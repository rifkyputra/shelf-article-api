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
  Future insert({covariant data}) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future select({
    List? columns,
  }) async {
    var selection = '*';

    if (columns != null) {
      selection = '';
      columns.forEach((element) => selection = '$selection, $element');
    }

    final query = db.select('select $selection from $table');

    return query;
  }

  @override
  Future update({covariant id}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future execute() {
    throw UnimplementedError();
  }

  @override
  Future selectWhere({covariant arg}) {
    // TODO: implement selectWhere
    throw UnimplementedError();
  }
}
