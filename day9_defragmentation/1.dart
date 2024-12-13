import 'dart:io';

void main() async {
  try {
    var isExample = true;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    var result = 0;
    var digits = text.split('').map((d) => int.parse(d)).toList();
    var dataFields = [];

// 2333133121414131402
// 00...111...2...333.44.5555.6666.777.888899

// 1 Transform input into data repr.
    var currDataValue = 0;
    for (var i = 0; i < digits.length; i++) {
      var insertValue = i.isEven ? currDataValue : null;
      for (var j = 0; j < digits[i]; j++) {
        dataFields.add(insertValue);
      }
      if (i.isEven) {
        currDataValue++;
      }
    }

    File file3 = File('./parsed');
    await file3.writeAsString(dataFields.map((d) => d == null ? '.' : d).join(','));

// 2 Move data from back into null spaces
    List<int> outputData = [];
    var leftIndex = 0;
    var rightIndex = dataFields.length - 1;
    OuterLoop:
    while (dataFields[leftIndex] != null) {
      while (dataFields[leftIndex] != null) {
        outputData.add(dataFields[leftIndex]);
        leftIndex++;
        if (leftIndex + 1 == rightIndex) {
          break OuterLoop;
        }
      }

      while (dataFields[leftIndex] == null) {
        while (dataFields[rightIndex] == null) {
          rightIndex--;
          if (leftIndex + 1 == rightIndex) {
            break OuterLoop;
          }
        }

        outputData.add(dataFields[rightIndex]);
        leftIndex++;
        if (leftIndex + 1 == rightIndex) {
          break OuterLoop;
        }
        dataFields[rightIndex] = null;
        rightIndex--;
        if (leftIndex + 1 == rightIndex) {
          break OuterLoop;
        }
      }
    }

    while (dataFields[leftIndex] != null) {
      outputData.add(dataFields[leftIndex]);
      leftIndex++;
    }

    File file1 = File('./outputData');
    await file1.writeAsString(outputData.join(','));

    File file2 = File('./dataFields');
    await file2.writeAsString(dataFields.join(','));
// 3 Calculate checksum
    for (var i = 0; i < outputData.length; i++) {
      result += outputData[i] * i;
    }
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
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
