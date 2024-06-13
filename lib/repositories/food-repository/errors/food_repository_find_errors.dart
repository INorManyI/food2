// ignore_for_file: constant_identifier_names

import 'package:lab_food_2/errors.dart';

/// A subsystem for reading errors that may occur
/// during an attempt to retrieve a list of foods that matches the query
/// from food repository.
class FoodRepositoryFindErrors extends Errors
{
  static const int INTERNET_CONNECTION_MISSING = 1;
  static const int INTERNAL = 1 << 1;

  /// Checks if ocurred an error because the internet connection is missing
  bool isInternetConnectionMissing()
  {
    return has(INTERNET_CONNECTION_MISSING);
  }

  /// Checks if ocurred an internal error
  bool isInternalErrorOccurred()
  {
    return has(INTERNAL);
  }
}
