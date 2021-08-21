import 'dart:convert';
import 'dart:io';

import 'package:coba_shelf/dao/user_dao.dart';
import 'package:coba_shelf/db/base_db.dart';
import 'package:coba_shelf/middleware/auth.dart';
import 'package:coba_shelf/middleware/roles.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UsersApi {
  final BaseDbDriver db;

  UsersApi({required this.db});
  Handler get router {
    final route = Router();

    route.get('/', _userGetAllController);

    var pipeline = Pipeline()
        .addMiddleware(handleAuthorization())
        .addMiddleware(RolesMiddleware().as(roleAllowed: [Roles.Admin]))
        .addHandler(route);

    return pipeline;
  }

  Future _userGetAllController(Request request) async {
    final users = await UserDao(db: db).getAll();

    final response = json.encode(users);

    return Response.ok(response, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
    });
  }
}
