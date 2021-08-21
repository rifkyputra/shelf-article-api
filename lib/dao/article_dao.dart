import 'package:coba_shelf/dao/base_dao.dart';
import 'package:coba_shelf/db/base_db.dart';

class ArticleDao extends DriverHolder implements BaseDao {
  ArticleDao({required BaseDbDriver db}) : super(db: db);

  @override
  BaseDbDriver get db => super.db;

  @override
  String get tableName => 'article';

  @override
  Future deleteById({required int id}) async {
    return await db.delete(table: tableName, id: id);
  }

  @override
  Future getAll() async {
    final query = await db.select(table: tableName);

    return query.toList();
  }

  @override
  Future getById({required int id}) async {
    final query = await db.select(table: tableName, where: {'id': id});
    return query;
  }

  @override
  List<Object?> get props => [];

  @override
  Future updateById({required int id, required Map data}) async {
    await db.update(table: tableName, id: id, data: data);
  }

  @override
  Future insert({required data}) async {
    await db.insert(table: tableName, data: data);
  }
}
