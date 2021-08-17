import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:coba_shelf/middleware/auth.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'package:coba_shelf/const.dart' as constant;
import 'package:coba_shelf/services/users/login.dart';
import 'package:coba_shelf/services/users/register.dart';
import 'package:coba_shelf/services/users/user.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

const salt = constant.salt;
const secret = constant.secret;

void main(List<String> args) async {
  open.overrideFor(OperatingSystem.linux, _openOnWindows);
  final db = sqlite3.open('db.db');

  var app = Router();

  app.mount('/register/', RegisterApi(db: db).router);

  app.mount('/login/', LoginApi(db: db).router);

  app.mount('/users/', UsersApi().router);

  var appPipelined = Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(handleAuthentication(secret))
      .addHandler(app);

  var server = await io.serve(appPipelined, _hostname, 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}

DynamicLibrary _openOnWindows() {
  final libraryNextToScript = File('./sqlite3.dll');
  return DynamicLibrary.open(libraryNextToScript.path);
}

// TODO: Add Linux Support
// DynamicLibrary _openOnLinux() {

// }
