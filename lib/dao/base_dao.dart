import 'package:coba_shelf/db/base_db.dart';
import 'package:equatable/equatable.dart';

abstract class BaseDao {
  String get tableName => '';

  Future getAll();

  Future getById({required covariant id});

  Future insert({required covariant data});

  Future deleteById({required covariant id});

  Future updateById({required covariant id, required covariant data});
}

abstract class DriverHolder extends Equatable {
  final BaseDbDriver db;

  DriverHolder({required this.db});
}
