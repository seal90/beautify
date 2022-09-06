
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
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

  String savedFilePath = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      MaterialButton(
        child: const Text("文件"),
          onPressed: selectFile
      ),
      Text("文件保存路径:" + savedFilePath),

    ],);
  }

  void selectFile() async {
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
    notifySavedPath(saveFilePath);

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

  void notifySavedPath(String saveFilePath) {
    setState(() {
      savedFilePath = saveFilePath;
    });
  }
}