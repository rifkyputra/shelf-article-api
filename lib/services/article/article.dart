import 'dart:convert';
import 'dart:io';

import 'package:coba_shelf/dao/article_dao.dart';
import 'package:coba_shelf/db/base_db.dart';
import 'package:coba_shelf/middleware/auth.dart';
import 'package:coba_shelf/middleware/roles.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ArticleApi {
  final BaseDbDriver db;

  ArticleApi({required this.db});

  ArticleDao get articleDao => ArticleDao(db: db);

  Handler get route {
    final route = Router();

    route.get('/', _getAllArticleController);

    route.post('/', _createnewArticleController);

    route.patch('/', _editArticleController);

    route.delete('/<id>', _deleteArticleController);

    final pipeline = Pipeline()
        .addMiddleware(handleAuthorization())
        .addMiddleware(
          RolesMiddleware().as(roleAllowed: [Roles.User, Roles.Admin]),
        )
        .addHandler(route);

    return pipeline;
  }

  Future _getAllArticleController(Request request) async {
    final result = await articleDao.getAll();
    final articles = json.encode(result);

    final response = Response.ok(articles, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
    });

    return response;
  }

  Future<Response> _createnewArticleController(Request request) async {
    try {
      final result = await request.readAsString();
      final body = json.decode(result);

      final String? title = body['title'];
      final String? content = body['body'];
      final String? category = body['category'];

      await articleDao.insert(
        data: {
          'title': title,
          'body': content,
          'category': category,
        },
      );
    } catch (e, s) {
      //
      print(s);
    }

    return Response.ok('Success');
  }

  Future<Response> _editArticleController(Request request) async {
    try {
      final payload = await request.readAsString();

      final body = json.decode(payload);

      if (body['id'] == null) {
        return Response(HttpStatus.badRequest, body: 'id should not be null');
      }

      await articleDao.updateById(id: body['id'], data: body);
    } catch (e, s) {
      print(s);
      print(e);
      return Response.internalServerError();
    }

    return Response.ok('body');
  }

  Future<Response> _deleteArticleController(Request request) async {
    try {
      final id = request.params['id'];

      await articleDao.deleteById(id: int.parse(id ?? '-1'));
    } catch (e, s) {
      //
      print('$e, s');
      print(s);
      return Response.internalServerError();
    }

    return Response.ok('Delete Success');
  }
}
