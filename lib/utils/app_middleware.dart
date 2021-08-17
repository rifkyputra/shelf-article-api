import 'dart:async';

import 'package:shelf/shelf.dart';

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
