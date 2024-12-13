import 'dart:io';

void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    var result = 0;

    var parts = text.split('\n\n');
    var rules = parts[0]
        .split('\n')
        .map((rule) => rule.split('|'))
        .map((numbers) => numbers.map((n) => int.parse(n)).toList())
        .toList();

    Map<int, Set<int>> followingMap =
        new Map(); // Map of what should be after the number
    Map<int, Set<int>> preceedingMap =
        new Map(); // Map of what should be before the number

    rules.forEach((rule) {
      if (followingMap[rule[0]] == null) {
        followingMap[rule[0]] = {};
      }
      if (preceedingMap[rule[1]] == null) {
        preceedingMap[rule[1]] = {};
      }
      followingMap[rule[0]]?.add(rule[1]);
      preceedingMap[rule[1]]?.add(rule[0]);
    });

    var prints = parts[1]
        .split('\n')
        .map((print) => print.split(','))
        .map((numbers) => numbers.map((n) => int.parse(n)).toList())
        .toList();

    // print(rules);
    // print(prints);
    // print(followingMap);
    // print(preceedingMap);

    var correctPrints = prints.where(
        (print) => correctOrderPrint(print, followingMap, preceedingMap));

    result = correctPrints
        .map(keepMiddleNumber)
        .reduce((value, element) => value + element);
    print(correctPrints);
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

bool correctOrderPrint(List<int> print, Map<int, Set<int>> followingMap,
    Map<int, Set<int>> preceedingMap) {
  for (var i = 0; i < print.length; i++) {
    var currentPage = print[i];
    var currentPrecedes = preceedingMap[currentPage];
    var currentFollowers = followingMap[currentPage];
    for (var j = 0; j < print.length; j++) {
      if (j != i && currentPrecedes != null && currentFollowers != null) {
        var currentMap = j < i ? currentPrecedes : currentFollowers;
        var currentChecked = print[j];
        if (!currentMap.contains(currentChecked)) {
          return false;
        }
      }
    }
  }
  return true;
}

int keepMiddleNumber(List<int> numbers) {
  return numbers[(numbers.length / 2).floor()];
}

Future<String> loadExample() async {
  const filePath = './example-1.txt';
  return await loadFile(filePath);
}

Future<String> loadProblem() async {
  const filePath = './problem-1.txt';
  return await loadFile(filePath);
}

Future<String> loadFile(filePath) async {
  try {
    var file = File(filePath);
    var text = await file.readAsString();
    return text;
  } catch (e) {
    print('Error reading file: $e');
  }

  return "";
}
