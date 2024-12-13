import 'dart:io';

// If the stone is engraved with the number 0, it is replaced by a stone engraved with the number 1.
// If the stone is engraved with a number that has an even number of digits, it is replaced by two stones. The left half of the digits are engraved on the new left stone, and the right half of the digits are engraved on the new right stone. (The new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)
// If none of the other rules apply, the stone is replaced by a new stone; the old stone's number multiplied by 2024 is engraved on the new stone.

void main() async {
  try {
    var isExample = true;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    var stones = text.split(' ').map((s) => int.parse(s)).toList();
    var blinked = blink(stones);

    var blinksCounts = 75;

    for (var i = 0; i < blinksCounts - 1; i++) {
      print(i);
      blinked = blink(blinked);
      print(blinked.length);
    }

    var result = blinked.length;
    // print(blinked);
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

dynamic transformStone(int stone) {
  // 0 => 1
  if (stone == 0) return 1;
  int stoneLength = stone.toString().length;

  if (stoneLength.isOdd) return stone * 2024;

  // even digits => split
  if (stoneLength.isEven) {
    int partLength = (stoneLength / 2).floor();
    return [int.parse(stone.toString().substring(0, partLength)), int.parse(stone.toString().substring(partLength))];
  }
}

List<dynamic> blink(List<dynamic> stones) {
  return stones.map((s) => transformStone(s)).expand((s) {
    if (s is List) {
      return s; // If the element is a list, expand it
    } else {
      return [s]; // If it's not a list, keep it as a single-element list
    }
  }).toList();
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
