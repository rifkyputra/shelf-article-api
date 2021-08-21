import 'package:coba_shelf/dao/base_dao.dart';
import 'package:coba_shelf/db/base_db.dart';
import 'package:sqlite3/sqlite3.dart';

class UserDao extends DriverHolder implements BaseDao {
  UserDao({required BaseDbDriver db}) : super(db: db);

  @override
  String get tableName => 'users';

  @override
  BaseDbDriver get db => super.db;

  @override
  Future deleteById({covariant id}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Object>> getAll() async {
    final ResultSet query = await db.select(table: tableName);

    if (query.isEmpty) {
      return [];
    }

    return query.toList();
  }

  @override
  Future getById({covariant id}) {
    throw UnimplementedError();
  }

  @override
  Future insert({required Map<String, dynamic> data}) async {
    await db.insert(table: tableName, data: data);
  }

  @override
  Future updateById({covariant id, data}) async {
    await db.update(table: tableName, id: id, data: data);
  }

  Future getByEmail({required email, List? columns}) async {
    final ResultSet query = await db.select(
      table: tableName,
      where: {'email': email},
      columns: columns,
    );

    return query;
  }

  @override
  List<Object?> get props => [db];
}
