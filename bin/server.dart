import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:coba_shelf/const.dart' as constant;
import 'package:coba_shelf/users/login.dart';
import 'package:coba_shelf/users/register.dart';
import 'package:coba_shelf/users/user.dart';
import 'package:coba_shelf/utils/auth.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

const salt = constant.salt;
const secret = constant.secret;

void main(List<String> args) async {
  // var handler = const shelf.Pipeline()
  //     .addMiddleware(shelf.logRequests())
  //     .addHandler(_echoRequest);
  // Hive.init('.');

  // var box = await Hive.openBox('test');

  // await Hive.openBox('test');
  open.overrideFor(OperatingSystem.linux, _openOnWindows);
  final db = sqlite3.open('db.db');

  var app = Router();

  final Handler ameno = (Request request) {
    return Response.ok('ga usah ngadi ngadi');
  };

  var needToken = createMiddleware(
    requestHandler: (Request req) {
      if (req.headers['Authorization'] != null) {
        return null;
      }

      return Response.forbidden('forbidden');
    },
    responseHandler: (Response response) {
      return Response.ok('GWS');
    },
    errorHandler: (e, stackTrace) {
      return Response.forbidden('body');
    },
  );

  var handler = shelf.Pipeline().addMiddleware(needToken).addHandler(ameno);

  app.get('/admin', handler);

  app.get('/hello/<name>', (Request request, String name) {
    db.execute('INSERT into person (name, level) values (?,?)', [name, 0]);
    return Response.ok('Hello, $name');
  });

  app.post('/todo', (Request request) async {
    final body = await request.readAsString();

    final Map mapBody = await jsonDecode(body);

    String? name;
    String? category;
    var updatedAt = DateTime.now().millisecondsSinceEpoch;
    var createdAt = DateTime.now().millisecondsSinceEpoch;

    for (var item in mapBody.entries) {
      if (item.key == 'name') {
        name = item.value;
      }

      if (item.key == 'category') {
        category = item.value;
      }
    }

    db.execute(
        'INSERT into todo (name, category, updated_at, created_at) values (?,?,?,?)',
        [name, category, updatedAt, createdAt]);

    return Response.ok('isinya :  $body');
  });

  app.get('/todo', (Request request) {
    var query = db.select('select * from todo');

    return Response.ok('${query.rows.map((e) => e[1]).toList()}');
  });

  app.get('/hello', (Request request) {
    var name = db.select('select * from person');

    return Response.ok(
      '${name.rows}',
    );
  });

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

shelf.Response _echoRequest(shelf.Request request) =>
    shelf.Response.ok('Request for "${request.url}"');
