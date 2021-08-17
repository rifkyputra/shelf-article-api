import 'package:coba_shelf/db/base_db.dart';
import 'package:sqlite3/sqlite3.dart';

class SqliteDB implements BaseDbDriver {
  final Database db;

  SqliteDB(this.db);

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
  Future select({covariant arg}) {
    // TODO: implement select
    throw UnimplementedError();
  }

  @override
  Future update({covariant id}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future execute() {
    throw UnimplementedError();
  }
}
