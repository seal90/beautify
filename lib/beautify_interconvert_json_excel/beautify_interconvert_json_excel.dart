
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel_dart/excel_dart.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class BeautifyJsonExcel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BeautifyJsonExcelState();
  }

}

class _BeautifyJsonExcelState extends State<BeautifyJsonExcel> {

  String savedJsonToExcelFilePath = "";

  String savedExcelToJsonFilePath = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius:const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: buildJsonToExcel(),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius:const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: buildExcelToJson(),
      ),



    ],);
  }

  Widget buildExcelToJson() {

    return Column(children: [
      MaterialButton(
          child: const Text("选择Excel文件"),
          onPressed: selectExcelToJsonFile
      ),
      Text("文件保存路径:" + savedExcelToJsonFilePath),
    ],);
  }

  void selectExcelToJsonFile() async {
    final XTypeGroup typeGroup = XTypeGroup(
      label: 'text',
      extensions: <String>['xlsx'],
    );
    // final String initialDirectory = (await getApplicationDocumentsDirectory()).path;
    final XFile? xfile = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
      // initialDirectory: initialDirectory,
    );
    if (xfile == null) {
      // Operation was canceled by the user.
      return;
    }
    try {
      final String fileName = xfile.name;

      var file = File(xfile.path);

      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      var jsonObjs = List<Map<String, dynamic>>.empty(growable: true);
      var attributes = List<String>.empty(growable: true);
      for (var table in excel.tables.keys) {
        var tab = excel.tables[table];
        if(null != tab) {
          var row = tab.rows.elementAt(0);
          for(var define in row) {
            attributes.add(define?.value);
          }

          var maxRows = tab.maxRows;
          // 忽略第一行
          for (var i = 1; i< maxRows; i++) {
            var curObj = HashMap<String, dynamic>();

            var row = tab.rows.elementAt(i);
            var j = 0;
            for(var define in row) {
              var key = attributes.elementAt(j);
              curObj.putIfAbsent(key, () => define?.value);
              j++;
            }
            jsonObjs.add(curObj);
          }
        }
        // 只解析第一个sheet
        break;
      }

      var toSavePath = fileName.substring(0, fileName.indexOf(r'.'));

      final String initialDirectory =
          (await getDownloadsDirectory())!.path;
      String saveFilePath = initialDirectory + "/";

      String saveFileName = saveFilePath + toSavePath + "_to_json.json";

      var curJsonObjsStr = jsonEncode(jsonObjs);

      var saveFile = File(saveFileName);
      await saveFile.writeAsString(curJsonObjsStr);
      notifyExcelToJsonSavedPath(saveFileName);
    } catch (e) {
      print(e);
    }
  }

  void notifyExcelToJsonSavedPath(String saveFilePath) {
    setState(() {
      savedExcelToJsonFilePath = saveFilePath;
    });
  }

  Widget buildJsonToExcel() {
    return Column(children: [
      MaterialButton(
          child: const Text("选择JSON文件"),
          onPressed: selectJsonToExcelFile
      ),
      Text("文件保存路径:" + savedJsonToExcelFilePath),
    ],);
  }

  void selectJsonToExcelFile() async {
    final XTypeGroup typeGroup = XTypeGroup(
      label: 'text',
      extensions: <String>['txt', 'json'],
    );
    // final String initialDirectory = (await getApplicationDocumentsDirectory()).path;
    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
    // initialDirectory: initialDirectory,
    );
    if (file == null) {
    // Operation was canceled by the user.
    return;
    }
    final String fileName = file.name;
    final String fileContent = await file.readAsString();

    List<dynamic> listContent = jsonDecode(fileContent);

    Set<String> headers = Set();
    for(int i=0;i<listContent.length; i++) {
      Map<String, dynamic> entity = listContent[i];
      headers.addAll(entity.keys);
    }

    List<String> headersList = List.from(headers);

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    int columnIndex = 0;
    int rowIndex = 0;

    for(int j = 0; j<headersList.length; j++) {
      String header = headersList[j];
      var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: rowIndex));
      cell.value = header; // dynamic values support provided;
      columnIndex++;
    }

    for(int i=0;i<listContent.length; i++) {
      Map<String, dynamic> entity = listContent[i];

      columnIndex = 0;
      rowIndex++;
      for(int j = 0; j<headersList.length; j++) {
        String header = headersList[j];
        dynamic val = entity[header];

        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: rowIndex));
        cell.value = val; // dynamic values support provided;

        columnIndex++;
      }

    }

    var fileBytes = excel.save()!;

    String saveFileName = fileName + "_to_excel.xlsx";

    final String initialDirectory =
        (await getDownloadsDirectory())!.path;
    String saveFilePath = initialDirectory + "/" +saveFileName;

    const String mimeType = 'text/plain';
    final XFile textFile = XFile.fromData(Uint8List.fromList(fileBytes), name: saveFileName);
    await textFile.saveTo(saveFilePath);
    notifyJsonToExcelSavedPath(saveFilePath);

    // File("/Users/seal/Downloads/002_json.xlsx")
    //   ..createSync(recursive: true)
    //   ..writeAsBytesSync(fileBytes);
    // File("/Users/seal/Downloads/002_json.xml").createSync()
    // var sink = File("/Users/seal/Downloads/002_json.xlsx").openWrite();
    // sink.writeAll(objects);
    // sink.close();

    // print(headers);
    // print(fileContent);
    // await showDialog<void>(
    // context: context,
    // builder: (BuildContext context) => TextDisplay(fileName, fileContent),
    // );
  }

  void notifyJsonToExcelSavedPath(String saveFilePath) {
    setState(() {
      savedJsonToExcelFilePath = saveFilePath;
    });
  }
}