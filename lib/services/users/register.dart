import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:coba_shelf/const.dart' as constant;

class RegisterApi {
  final Database db;

  RegisterApi({required this.db});

  Router get router {
    final route = Router();

    route.post('/', _registerController);

    return route;
  }

  Future _registerController(Request request) async {
    final rawBody = await request.readAsString();
    final body = jsonDecode(rawBody);

    final email = body['email']?.toString().trim() ?? '';
    final password = body['password']?.toString().trim() ?? '';

    if (email.isEmpty || password.isEmpty) {
      return Response(
        HttpStatus.badRequest,
        body: 'Email and or password can\'t be empty',
      );
    }
    final userExist =
        db.select('select email from users where email=(?)', [email]);

    if (userExist.isNotEmpty) {
      return Response(HttpStatus.badRequest, body: 'Email already registered');
    }

    final hmacSha256 = Hmac(sha256, utf8.encode(password));

    final salt = utf8.encode(constant.salt);

    final digestPassword = hmacSha256.convert(salt);

    try {
      db.execute(
        'insert into users (email, password) values(?,?)',
        [email, digestPassword.toString()],
      );
    } catch (e) {
      return Response.internalServerError(body: e);

      ///
    }

    return Response.ok('Registration Success');
  }
}
