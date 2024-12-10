import 'dart:io';

class Block {
  int? value;
  int len;

  Block(this.value, this.len);

  @override
  String toString() => '($value x $len)';
}

void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    var result = 0;
    var digits = text.split('').map((d) => int.parse(d)).toList();
    var dataFields = [];
    List<Block> dataBlocks = [];
//digits = 2333133121414131402
//dataFields = 00...111...2...333.44.5555.6666.777.888899 (null instead .)
//dataBlocks = {value: 2, len:2}, {value: null, len: 3}

// 1 Transform input into data repr.
    var currDataValue = 0;
    for (var i = 0; i < digits.length; i++) {
      var insertValue = i.isEven ? currDataValue : null;
      for (var j = 0; j < digits[i]; j++) {
        dataFields.add(insertValue);
      }
      if (i.isEven) {
        dataBlocks.add(Block(currDataValue, digits[i]));
        currDataValue++;
      } else {
        dataBlocks.add(Block(null, digits[i]));
      }
    }

// 00...111...2...333.44.5555.6666.777.888899
// 0099.111...2...333.44.5555.6666.777.8888..
// 0099.1117772...333.44.5555.6666.....8888..
// 0099.111777244.333....5555.6666.....8888..
// 00992111777.44.333....5555.6666.....8888..

// 2 Move data from back into null spaces
    for (var j = dataBlocks.length - 1; j > 0; j--) {
      for (var i = 0; i < j; i++) {
        // REWRITE
        if (dataBlocks[j].value != null && dataBlocks[i].value == null && dataBlocks[j].len == dataBlocks[i].len) {
          // print('Rewrite ' + dataBlocks[j].toString());
          dataBlocks[i].value = dataBlocks[j].value;
          dataBlocks[j].value = null;
          break;
        }
        // PART FILLIN
        if (dataBlocks[j].value != null && dataBlocks[i].value == null && dataBlocks[j].len < dataBlocks[i].len) {
          // print('Part fillin ' + dataBlocks[j].toString());
          Block newEmptyBlock = Block(null, dataBlocks[i].len - dataBlocks[j].len);
          dataBlocks[i].value = dataBlocks[j].value;
          dataBlocks[i].len = dataBlocks[j].len;
          dataBlocks[j].value = null;
          dataBlocks.insert(i + 1, newEmptyBlock);
          j++;
          break;
        }
      }
    }

// 3 Calculate checksum
    // for (var i = 0; i < defragmentedDataBlocks.length; i++) {
    //   result += outputData[i] * i;
    // }
    List<int> defragmentedData = [];
    dataBlocks.forEach((block) {
      for (var i = 0; i < block.len; i++) {
        defragmentedData.add(block.value ?? 0);
      }
    });

    for (var i = 0; i < defragmentedData.length; i++) {
      result += defragmentedData[i] * i;
    }
    // print(dataBlocks);
    print(defragmentedData);
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
