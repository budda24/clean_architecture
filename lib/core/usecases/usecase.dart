import '../error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

// Parameters have to be put into a container object so that they can be
// included in this abstract base class method definition.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
