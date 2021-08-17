import 'dart:async';

import 'package:coba_shelf/utils/roles.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';

Middleware authMiddleware(String key) {
  final middleware = AppMiddleware(
    transform: (Request request) {
      final bearer = request.headers['Authorization'];
      String token;
      JwtClaim? jwt;

      if (bearer != null && bearer.startsWith('Bearer ')) {
        token = bearer.replaceAll('Bearer ', '');
        try {
          jwt = verifyJwtHS256Signature(token, key);
        } on JwtException {
          //
        }
      }
      if (jwt == null) {
        //
      }

      if (jwt!.expiry!.millisecondsSinceEpoch <
          DateTime.now().millisecondsSinceEpoch) {}

      return request.change(
        context: {'token': jwt},
      );
    },
  );

  return middleware.use;
}

Middleware handleAuthentication(String key) {
  return (Handler handler) {
    return (Request request) {
      final bearer = request.headers['Authorization'];
      String token;
      JwtClaim? jwt;

      if (bearer != null && bearer.startsWith('Bearer ')) {
        token = bearer.replaceAll('Bearer ', '');
        try {
          jwt = verifyJwtHS256Signature(token, key);
        } on JwtException {
          //
        }
      }

      final role = RolesExtension.getRole(jwt?.payload['role'] ?? 0);

      final appendJwtToken = request.change(
        context: {
          'token': jwt,
          'role': role,
        },
      );

      return Future.sync(() => handler(appendJwtToken));
    };
  };
}

Middleware handleAuthorization() {
  final middleware = AppMiddleware(
    requestHandler: (Request request) {
      if (request.context['token'] == null) {
        return Response.forbidden('Not Allowed');
      }

      return null;
    },
  );

  return middleware.use;
}

class AppMiddleware {
  final Request Function(Request)? transform;

  final FutureOr<Response>? Function(Request)? requestHandler;
  final FutureOr<Response> Function(Response)? responseHandler;
  FutureOr<Response> Function(dynamic error)? errorHandler;

  AppMiddleware({
    this.transform,
    this.requestHandler,
    this.responseHandler,
    this.errorHandler,
  });

  Middleware get use => (Handler handle) {
        return (Request request) async {
          Response? response;

          try {
            if (transform != null) {
              request = transform!(request);
            }

            final innerHandler = requestHandler ?? (request) => null;

            response = await innerHandler(request);

            response ??= await handle(request);
          } on HijackException {
            rethrow;
          } catch (e) {
            return errorHandler!(e);
          }

          return response;
        };
      };
}
