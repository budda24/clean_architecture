import 'package:clean_archtecture/core/usecases/usecase.dart';
import 'package:clean_archtecture/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_archtecture/feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_archtecture/feature/number_trivia/domain/usercases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia useCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });
  final tNumberTrivia = NumberTrivia(number: 1, text: "test");
  test(
    'description',
    () async {
//arrange
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));

//act
      final result = await useCase(NoParams());

//assert
      expect(result, Right(tNumberTrivia));
      verify((() => mockNumberTriviaRepository.getRandomNumberTrivia()));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
