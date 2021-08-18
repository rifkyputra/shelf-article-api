import 'package:coba_shelf/dao/base_dao.dart';
import 'package:coba_shelf/db/base_db.dart';

class UserDao extends DriverHolder implements BaseDao {
  UserDao({required BaseDbDriver db}) : super(db: db);

  static const tableName = 'users';

  @override
  BaseDbDriver get db => super.db;

  @override
  Future deleteById({covariant id}) {
    throw UnimplementedError();
  }

  @override
  Future getAll() async {
    final query = await db.select();

    if (query == null || query.isNotEmpty) {
      return [];
    }

    return query;
  }

  @override
  Future getById({covariant id}) {
    throw UnimplementedError();
  }

  @override
  Future insert({covariant data}) {
    throw UnimplementedError();
  }

  @override
  Future updateById({covariant id}) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [db];
}
