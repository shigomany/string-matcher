import 'package:stringmatcher/src/extends.dart';
import 'package:stringmatcher/stringmatcher.dart';

import 'package:test/test.dart';


void main() {
  group('Algorithms', () {
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

//        test('Empty values', () {
//
//          expect(similarities['leven_word'].similar('', 't').ratio, 1);
//        });
      });


    });
  });

  group('Extension methods', () {

    group('Select many', () {
      test('Select: elements % n != 0', () {
        var sList = ['a', 'b', 'c'];
        expect(sList.selectMany(2).toList(), [['a', 'b'], ['c']]);
      });

      test('Select elements more then n', () {
        var sList = ['a', 'b', 'c'];
        try {
          sList.selectMany(666).toList();
        } catch (e) {
          expect(e.runtimeType, ArgumentError);
        }
      });
    });

    group('Split Many', () {
      test('Empty elements', () {
        var splitters = <String>[' ', ','];
        var source = ' a b, c'; // 5 elements

        expect(source.splitMany(splitters), ['', 'a', 'b', '', 'c']);
      });

      test('Empty string', () {
        var splitters = <String>[' ', ','];
        var source = ''; // 0 elements

        expect(source.splitMany(splitters), <String>[]);
      });

      test('Not found matches', () {
        var splitters = <String>[' ', ','];
        var source = 'abcd'; // 0 elements

        expect(source.splitMany(splitters), <String>[]);
      });

      test('Last empty string', () {
        var splitters = <String>[' ', ','];
        var source = 'a b,'; // 3 elements

        expect(source.splitMany(splitters), ['a', 'b', '']);
      });
    });

    group('Ngram Split', () {
      test('Simple Test', () {
        var splitters = <String>[' ', ','];
        var source = 'a b c'; // 2 elements

        expect(source.ngramSplit(splitters, 2), ['a b', 'b c']);
      });

      test('Simple Test 3 ngram', () {
        var splitters = <String>[' ', ','];
        var source = 'a b c d'; // 2 elements

        expect(source.ngramSplit(splitters, 3), ['a b c', 'b c d']);
      });

      test('One element in 3 ngram', () {
        var splitters = <String>[' ', ','];
        var source = 'a b c'; // 1 element

        expect(source.ngramSplit(splitters, 3), ['a b c']);
      });

      test('Replace Signs on space', () {
        var splitters = <String>[' ', ','];
        var source = 'a b,c'; // 2 elements

        expect(source.ngramSplit(splitters, 2, true), ['a b', 'b c']);
      });
    });
  });


}
