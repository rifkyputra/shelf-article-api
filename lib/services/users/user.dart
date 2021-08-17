import 'package:coba_shelf/middleware/auth.dart';
import 'package:coba_shelf/middleware/roles.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UsersApi {
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
    return Response.ok('Get All');
  }
}
