abstract class BaseDbDriver {
  Future select({covariant arg});

  Future insert({covariant data});

  Future delete({covariant id});

  Future update({covariant id});
}
