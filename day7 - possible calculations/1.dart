import 'dart:io';

void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;

    var lines = text.split('\n');
    var parts = lines
        .map((line) => line.split(': ').toList())
        .map((partitionedLine) => {
              'desiredValue': int.parse(partitionedLine[0]),
              'elements': partitionedLine[1]
                  .split(' ')
                  .map((num) => int.parse(num))
                  .toList()
            })
        .toList();
    var result = 0;
    var signsCombinations = generatePossibleSingsCombinations(13, ['+', '*']);

    for (var i = 0; i < parts.length; i++) {
      var currentResult = checkIfCanBeCalculated(
          parts[i]["desiredValue"] as int,
          parts[i]['elements'] as List<int>,
          signsCombinations);
      if (currentResult != null) {
        result += currentResult;
      }
    }

    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

int? checkIfCanBeCalculated(
    int desiredValue, List<int> elements, List<String> signsCombinations) {
  for (var i = 0; i < signsCombinations.length; i++) {
    var value = calculate(elements, signsCombinations[i], desiredValue);
    if (value == desiredValue) {
      return desiredValue;
    }
  }

  return null;
}

int? calculate(List<int> elements, String signs, int desiredValue) {
  var signsList = signs.split('');
  var currentValue = elements[0];
  for (var i = 1; i < elements.length; i++) {
    if (signsList[i - 1] == '+') {
      currentValue += elements[i];
    } else {
      currentValue *= elements[i];
    }
    if (currentValue > desiredValue) {
      return null;
    }
  }
  if (currentValue == desiredValue) {
    return currentValue;
  }
  return null;
}

List<String> generatePossibleSingsCombinations(
    int length, List<String> inputSigns) {
  if (length == 0) {
    return inputSigns;
  }
  var doubledSigns = inputSigns + inputSigns;
  for (var i = 0; i < doubledSigns.length; i++) {
    if (i < doubledSigns.length / 2) {
      doubledSigns[i] += '+';
    } else {
      doubledSigns[i] += '*';
    }
  }
  return generatePossibleSingsCombinations(length - 1, doubledSigns);
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
