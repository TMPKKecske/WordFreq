import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileContentPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
      snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF1A1C19),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        useMaterial3: true,
      ),

    );
  }
}

class FileContentPage extends StatefulWidget {
  @override
  _FileContentPageState createState() => _FileContentPageState();
}

class _FileContentPageState extends State<FileContentPage> {
  

  final TextEditingController _controller = TextEditingController();
  late String _filePath;

@override
  void initState() {
    super.initState();
    _getFilePath().then((value) {
      setState(() {
        _filePath = value;
      });
      _loadText();
    });
  }

  Future<String> _getFilePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path + '/save.txt';
  }

  Future<File> _getFile() async {
    String filePath = await _getFilePath();
    return File(filePath);
  }

  Future<void> _loadText() async {
    try {
      File file = await _getFile();
      String contents = await file.readAsString();
      setState(() {
        _controller.text = contents;
        print(contents);
      });
    } catch (e) {
      print("Error loading file: $e");
      print("ErrorR");
    }
  }

  Future<void> _saveText() async {
    File file = await _getFile();
    await file.writeAsString(_controller.text);
  }

  List<List<String>> _data = [
    ['Rank', 'Word'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chinese word frequency ranker'),
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Your words:',
                hintText: 'Add words here...',
              ),
              onChanged: (value) {
                _saveText();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _rank(_controller.text);
              },
              child: Text('Start ranking'),
            ), 
            SizedBox(height: 20),
            DataTable(
              rows: _buildRows(),
              columns: _buildHeaderColumns(),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _data = [["Rank", "Word"]];
                });
          final snackBar = SnackBar(
            content: const Text('Cleared!'),
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text('Clear list'),
            ),
          ],
        ),
        ),
      ),
    );
  }

  void _rank(String words) async {
  String content = await rootBundle.loadString("assets/ChineseRanked.txt");
    setState(() {
                  _data = [];
                });

  if (words.isNotEmpty || words.split("\n").length != 0) 
    {
  for (String x in content.split("\n")) 
  {
    for (String line in words.split("\n")) 
    {
      if (x == line) 
      {
        bool canPass = true;
        for ( List<String> entry in _data) 
        {
          if (entry.toString() == [(content.split("\n").indexOf(line)+1).toString(), line].toString() )
          {
            canPass = false;
          }
        }

        if (canPass)
        {
          setState(() {
            if ((content.split("\n").indexOf(line)+1).toString() != "9555") 
            {
              _data.add([(content.split("\n").indexOf(line)+1).toString(), line]);
            }
            _data.sort((a, b) {
              return int.parse(a[0]).compareTo(int.parse(b[0]));
            });
          });
        }
      }
    }

  }  
      final snackBar = SnackBar(
            content: const Text('The ranking has finished!' ),
            duration: const Duration(milliseconds: 2000),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } 
    _data.insert(0, ["Rank", "Word"]); 


  }

List<DataColumn> _buildHeaderColumns() {
  return _data[0].map((header) => DataColumn(label: Text(header))).toList();
}

List<DataRow> _buildRows() {
  return _data.skip(1).map((row) {
    int rankValue = int.tryParse(row[0]) ?? 0;

    Color rowColor = rankValue < 3500 ? Colors.green: Colors.transparent;

    return DataRow(
      color: MaterialStateProperty.all<Color>(rowColor),
      cells: row.map((cell) {
        return DataCell(
          Text(
            cell,
            style: TextStyle(fontSize: 16.0), 
          ),
        );
      }).toList(),
    );
  }).toList();
}
}   
