import 'package:coba_shelf/utils/app_middleware.dart';
import 'package:shelf/shelf.dart';

enum Roles {
  Admin,
  User,
  Guest,
}

extension RolesExtension on Roles {
  int get roleId {
    switch (this) {
      case Roles.Admin:
        return 1;
      case Roles.User:
        return 2;
      default:
        return 0;
    }
  }

  static Roles getRole(int num) {
    switch (num) {
      case 1:
        return Roles.Admin;
      case 2:
        return Roles.User;
      default:
        return Roles.Guest;
    }
  }
}

class RolesMiddleware {
  Middleware as({
    List<Roles>? roleAllowed,
  }) {
    final middleware = AppMiddleware(
      requestHandler: (Request request) {
        final role = request.context['role'] as Roles;

        final hasRole = roleAllowed?.any((element) => element == role) ?? true;

        if (hasRole == false) return Response.forbidden('role not allowed');

        return null;
      },
    );

    return middleware.use;
  }
}
