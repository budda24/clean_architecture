import 'dart:convert';

import 'package:clean_archtecture/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('fromJson', () {
    test('should convert to valid model when the number is intiger', () {
      //arrange
      final expectedNumberTriviaJson =
          NumberTriviaModel(number: 1, text: '1 test');
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('intiger_number_trivia.json'));
      //act
      final numberTrivia = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(numberTrivia, expectedNumberTriviaJson);
    });
    test('should convert to valid model when the number is double', () {
      //arrange
      final expectedNumberTriviaJson =
          NumberTriviaModel(number: (1.0).toInt(), text: '1.0 test');
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('double_number_trivia.json'));
      //act
      final numberTrivia = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(numberTrivia, expectedNumberTriviaJson);
    });
  });

  group('toJson', () {
    test('should convert to valid json when number is intiger', () {
      //arrange
      final tNumberTrivia = NumberTriviaModel(number: 1, text: '1 test');
      final expectedNumberTriviaJson = {
        "text": '1 test',
        "number": 1,
      };
      //act
      final Map<String, dynamic> numberTriviaJson = tNumberTrivia.toJson();

      //assert
      expect(numberTriviaJson, expectedNumberTriviaJson);
    });
    test('should convert to valid json when number is double', () {
      //arrange
      final tNumberTrivia =
          NumberTriviaModel(number: (1.0).toInt(), text: '1.0 test');
      final tNumberTriviaJson = {
        "text": '1.0 test',
        "number": 1.0,
      };
      //act
      final Map<String, dynamic> numberTriviaJson = tNumberTrivia.toJson();

      //assert
      expect(numberTriviaJson, tNumberTriviaJson);
    });
  });
}
