import 'dart:math';

import 'package:common/get_webpage.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:lottery/settings.dart';

class Lottery extends ChangeNotifier {
  List<int> history = [];
  List<List<int>> luckyNumbers = [];
  List<List<int>> winList = [];

  Lottery() {
    _getHistory().then(
      (value) {
        getLuckyNumbers();
      },
    );
  }

  Future<void> getLuckyNumbers() async {
    luckyNumbers.clear();
    do {
      List<int> randomNumbers = [];
      do {
        final randomNumber = history[Random().nextInt(history.length)];

        if (!randomNumbers.contains(randomNumber) &&
            !luckyNumbers
                .expand((element) => element)
                .toList()
                .contains(randomNumber)) {
          randomNumbers.add(randomNumber);
        }
        randomNumbers.sort();
      } while (randomNumbers.length < 6);
      final int sum = randomNumbers.reduce(
        (value, element) => value + element,
      );
      if (!winList.contains(randomNumbers) && sum > 81 && sum < 191) {
        luckyNumbers.add(randomNumbers);
      }
    } while (luckyNumbers.length < 5);

    notifyListeners();
  }

  Future<void> _getLuckyNumbers() async {
    luckyNumbers.clear();
    do {
      List<int> randomNumbers = [];
      do {
        final randomNumber = history[Random().nextInt(history.length)];

        if (!randomNumbers.contains(randomNumber) &&
            !luckyNumbers
                .expand((element) => element)
                .toList()
                .contains(randomNumber)) {
          randomNumbers.add(randomNumber);
        }
        randomNumbers.sort();
      } while (randomNumbers.length < 6);
      if (!winList.contains(randomNumbers)) {
        luckyNumbers.add(randomNumbers);
      }
    } while (luckyNumbers.length < 5);

    notifyListeners();
  }

  Future<void> _getHistory() async {
    final documentLastTurn = await GetWeb.getDocument(pageLastTurn);
    final lastTurn = documentLastTurn
            .querySelector(selectorLastTurn)
            ?.text
            .replaceAll(RegExp(r'\D'), '') ??
        '-1';

    final documentHistory =
        await GetWeb.getDocument(pageHistoryBase + lastTurn);
    final List<dom.Element> elements =
        documentHistory.querySelectorAll(selectorHistory);
    for (final element in elements) {
      var numbers = element.text.split(RegExp(r'\n')).sublist(3, 9);
      for (var number in numbers) {
        history.add(int.parse(number.replaceAll(RegExp(r'\D'), '')));
      }
    }
    winList = _divideList(history);
  }

  List<List<int>> _divideList(List<int> list) {
    return List.generate(list.length ~/ nLottery, (i) {
      var temp = list.sublist(nLottery * i,
          nLottery * (i + 1) <= list.length ? (i + 1) * nLottery : null);
      temp.sort();
      return temp;
    });
  }
}
