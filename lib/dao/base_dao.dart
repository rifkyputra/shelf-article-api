import 'package:coba_shelf/db/base_db.dart';
import 'package:equatable/equatable.dart';

abstract class BaseDao {
  Future getAll();
  Future getById({covariant id});

  Future insert({covariant data});

  Future deleteById({covariant id});

  Future updateById({covariant id});
}

abstract class DriverHolder extends Equatable {
  final BaseDbDriver db;

  DriverHolder({required this.db});
}
