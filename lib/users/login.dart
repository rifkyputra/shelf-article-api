import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:coba_shelf/const.dart' as constant;

class LoginApi {
  final Database db;

  LoginApi({
    required this.db,
  });

  Router get router {
    final route = Router();

    route.post('/', loginController);

    return route;
  }

  Future loginController(Request request) async {
    final rawBody = await request.readAsString();
    final body = jsonDecode(rawBody);

    final email = (body['email'])?.toString().trim() ?? '';
    final password = body['password']?.toString().trim() ?? '';

    if (password.isEmpty || email.isEmpty) {
      return Response(HttpStatus.badRequest,
          body: 'email or password can\'t be empty');
    }

    final query = db.select(
        'select email, password, role from users where email=(?)', [email]);

    if (query.isEmpty) {
      return Response(HttpStatus.badRequest, body: 'not registered');
    }

    JwtClaim claimSet;
    String? token;
    int role = query.first['role'];

    final passwordFromQuery = query.first['password'];

    final decryptedPassword = Hmac(sha256, utf8.encode(password))
        .convert(utf8.encode(constant.salt))
        .toString();

    if (decryptedPassword != passwordFromQuery) {
      return Response.forbidden(
          'from db : $passwordFromQuery , from input : $decryptedPassword');
    }

    try {
      claimSet = JwtClaim(
        maxAge: Duration(days: 7),
        payload: {'role': role},
      );
      token = issueJwtHS256(claimSet, constant.secret);
    } catch (e) {
      //
    }
    if (token == null) {
      return Response.internalServerError();
    }

    final responseBody = Response.ok(
      json.encode({
        'token': token,
      }),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
      },
    );

    return responseBody;
  }
}
