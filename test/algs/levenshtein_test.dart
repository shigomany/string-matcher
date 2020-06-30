import 'package:stringmatcher/stringmatcher.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Levenshtein', () {

    var similarities = <String, StringMatcher>{
      'leven_char': StringMatcher(term: Term.char, algorithm: Levenshtein()),
      'leven_word': StringMatcher(term: Term.word, algorithm: Levenshtein(), separators: [' ', ',']),
      'leven_ngram2': StringMatcher(term: Term.ngram, algorithm: Levenshtein(), ngramValue: 2),
      'leven_ngram3': StringMatcher(term: Term.ngram, algorithm: Levenshtein(), ngramValue: 3),
    };

    test('Supports types test', () {
      try {
        similarities['leven_char'].similar(null, 'w1').ratio;
      } catch (e) {
        expect(e.runtimeType, UnsupportedError);
      }
    });

    group('Char', () {
      test('Similar ratio test', () {

        expect(similarities['leven_char'].similar('test1', 'test1').ratio, 1);
      });

      test('Empty values', () {


        expect(similarities['leven_char'].similar('', 't').ratio, 1);
      });
    });

    group('Word', () {
      test('Ratio test', () {

        expect(similarities['leven_word'].similar('word test', 'word test').ratio, 1);
      });
      test('Percent test', () {

        expect(similarities['leven_word'].similar('word test', 'word test').percent, 100);
      });

      test('Different characters', () {

        expect(similarities['leven_word'].similar('word,test', 'word test').percent, 100);
      });
    });

    group('Partial similar', () {
      var word = 'fuzzy';
      var listWords = <String>['anime', 'spider', 'dart_best_language', 'fuzzy'];

      test('Limit more than elements in list', () {
        expect(similarities['leven_char'].partialSimilarOne(
            word,
            listWords,
            (a, b) => a.ratio.compareTo(b.ratio),
            selector: (el) => el.ratio).item2,
            1);
      });

      test('Check limit', () {
        expect(similarities['leven_char'].partialSimilar(
            word,
            listWords,
                (a, b) => a.ratio.compareTo(b.ratio),
            selector: (el) => el.ratio,
            limit: 1),
            [Tuple2('fuzzy', 1.0)]);
      });

      // TODO: Testing for different terms: ngram and word. (partialSimilar/partialSimilarOne)
    });
  });
}