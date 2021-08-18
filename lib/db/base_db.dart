abstract class BaseDbDriver {
  String? get table => null;

  Future select({covariant columns});

  Future selectWhere({covariant arg});

  Future insert({covariant data});

  Future delete({covariant id});

  Future update({covariant id});
}
