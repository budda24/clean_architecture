import 'package:clean_archtecture/feature/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  @override
  final String text;
  @override
  final int number;

  NumberTriviaModel({
    required this.number,
    required this.text,
  }) : super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) =>
      NumberTriviaModel(
        text: json["text"],
        number: (json["number"] as num).toInt(),
      );
  Map<String, dynamic> toJson() {
    return {"text": text, "number": number.toInt()};
  }
}

/* abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
 */
