abstract class BaseDbDriver {
  Future select({
    required covariant table,
    covariant columns,
    covariant where,
  });

  Future insert({
    required covariant table,
    required covariant data,
  });

  Future delete({
    required covariant table,
    covariant id,
  });

  Future update({
    required covariant table,
    required covariant id,
    required covariant data,
  });
}
