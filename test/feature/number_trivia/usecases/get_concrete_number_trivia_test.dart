import 'package:clean_archtecture/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_archtecture/feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_archtecture/feature/number_trivia/domain/usercases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

//setup method runs first in test and here we initialize all objects.
void main() {
  late GetConcreteNumberTrivia useCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });
  const tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'text');
  test('should get trivia for the number from the repository', () async {
    //arrange
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => Right(tNumberTrivia));
    //act
    final result = await useCase(Params(number: 1));
    //assert
    expect(result, Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
