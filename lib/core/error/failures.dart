import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  @override
  List<Object> get props => [];
}

class ServerFaliure extends Failure {}

class CacheFaliure extends Failure {}
