import 'dart:convert';
import 'dart:io';

import 'package:android_component/quiz/question.dart';
import 'package:android_component/quiz/quiz.dart';

class QuizReader {

  static QuizType parseQuizType(String quizTypeString) {
    switch (quizTypeString) {
      case 'Animal':
        return QuizType.animal;
      case 'Vegetable':
        return QuizType.vegetables;
      case 'Fruit':
        return QuizType.fruits;
      case 'Capital':
        return QuizType.capital;
      case 'Maths':
        return QuizType.maths;
      // Add more cases as needed
      default:
        throw ArgumentError('Invalid quiz type string: $quizTypeString');
    }
  }

  static Quiz readJson(String filePath) {
    try {
      final file = File(filePath);
      final jsonString = file.readAsStringSync();

      final jsonMap = json.decode(jsonString);

      final QuizType quizType = parseQuizType(jsonMap['type']);

      // Parse questions from JSON map
      final List<Question> questions = (jsonMap['questions'] as List<dynamic>)
          .map((questionJson) => Question(
                text: questionJson['question'],
                options: List<String>.from(questionJson['options']),
                correctAnswer: questionJson['correctAnswer'],
              ))
          .toList();

      // Create and return Quiz object
      return Quiz(type: quizType, questions: questions);
    } catch (e) {
      // ignore: avoid_print
      print('Error reading JSON file: $e');
      rethrow; // Re-throw the exception for handling at the caller's level
    }
  }
}