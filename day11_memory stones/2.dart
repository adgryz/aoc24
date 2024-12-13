import 'dart:io';

// If the stone is engraved with the number 0, it is replaced by a stone engraved with the number 1.
// If the stone is engraved with a number that has an even number of digits, it is replaced by two stones. The left half of the digits are engraved on the new left stone, and the right half of the digits are engraved on the new right stone. (The new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)
// If none of the other rules apply, the stone is replaced by a new stone; the old stone's number multiplied by 2024 is engraved on the new stone.

// Dziel i zwycięzaj - mozemy rozbic problem na wynik per stone - dla jednego nie jestem w stanie 50 iteracji zrobic :/
// Mozemy tez zrobic mape, zeby miec od razu wynik bez ifowania - i tak liczba na zabije
// Mozemy tez

// Divide & Conquer -> X
// MapCaching -> X
// Function that calculates number of stones after 75 calculations -> ? raczej imposibru z powodu dlugosci liczb

// lets break it to three 25 iterations

var sameStonesCount = {};
void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    Map<int, int> stonesMap = {};
    text.split(' ').forEach((s) {
      var parsed = int.parse(s);
      stonesMap[parsed] ??= 0;
      stonesMap[parsed] = (stonesMap[parsed] as int) + 1;
    });

    var blinksCounts = 75;
    for (var i = 0; i < blinksCounts; i++) {
      stonesMap = blink(stonesMap);
    }

    print(stonesMap.length);
    var result = 0;
    stonesMap.forEach((value, count) {
      result += count;
    });

    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

Map<int, int> blink(Map<int, int> stones) {
  Map<int, int> newStonesMap = {};

  stones.forEach((value, count) {
    if (value == 0) {
      newStonesMap[1] = (newStonesMap[1] ?? 0) + count; // we get the same number of 1 stones as 0 stones
      return;
    }
    int stoneLength = value.toString().length;

    if (stoneLength.isOdd) {
      newStonesMap[value * 2024] =
          (newStonesMap[value * 2024] ?? 0) + count; // we get the same number of 2024*X stones as X stones
      return;
    }

    // even digits => split
    if (stoneLength.isEven) {
      int partLength = (stoneLength / 2).floor();
      int firstNewStone = int.parse(value.toString().substring(0, partLength));
      int secondNewStone = int.parse(value.toString().substring(partLength));

      newStonesMap[firstNewStone] = (newStonesMap[firstNewStone] ?? 0) + count;
      ; // we get the same number of 'left' stones as X stones
      newStonesMap[secondNewStone] = (newStonesMap[secondNewStone] ?? 0) + count;
      ; // we get the same number of 'right' stones as X stones
      return;
    }
  });
  return newStonesMap;
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
