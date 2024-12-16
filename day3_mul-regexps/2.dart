import 'dart:io';

void main() async {
  try {
    // const filePath = './example-2.txt';
    const filePath = './problem-2.txt';
    var file = File(filePath);
    var text = await file.readAsString();
    var result = 0;

    var doPartsRegExp = RegExp(r"(?:do\(\)|^)(.*?)(?:don't\(\)|$)");
    var doPartsMatches = doPartsRegExp.allMatches(text);

    for (var doPartMatch in doPartsMatches) {
      var doPart = doPartMatch.group(1);
      if (doPart is String) {
        var mulRegExp = RegExp(r'mul\(\d{1,3},\d{1,3}\)');
        var mulMatches = mulRegExp.allMatches(doPart);

        for (var mulMatch in mulMatches) {
          var mul = mulMatch.group(0);
          if (mul is String) {
            var numbersRegExp = RegExp(r'\d{1,3}');
            var numbersMatches = numbersRegExp.allMatches(mul);
            var numbers = numbersMatches.toList();
            var leftNumber = numbers[0].group(0);
            var rightNumber = numbers[1].group(0);

            if (leftNumber is String && rightNumber is String) {
              var currentMul = int.parse(leftNumber) * int.parse(rightNumber);
              result += currentMul;
            }
          }
        }
      }
    }

    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}
