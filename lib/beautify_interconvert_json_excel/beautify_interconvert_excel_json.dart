
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel_dart/excel_dart.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class BeautifyExcelJson extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BeautifyExcelJsonState();
  }

}

class _BeautifyExcelJsonState extends State<BeautifyExcelJson> {

  String savedFilePath = "";

  var userDefine = List<ExcelColumnToJsonAttrDefine>.empty(growable: true);

  int firstNum = 0;
  String firstName = "";
  int secondNum = 0;
  String secondName = "";

  @override
  Widget build(BuildContext context) {

    userDefine.add(ExcelColumnToJsonAttrDefine());
    userDefine.add(ExcelColumnToJsonAttrDefine());

    return Column(children: [
      // SizedBox(
      //   height: 100,
      //   child: ListView.builder(
      //     itemCount: 300,
      //     cacheExtent: 20.0,
      //     controller: ScrollController(),
      //     padding: const EdgeInsets.symmetric(vertical: 16),
      //     itemBuilder: (context, index) => ItemTile(index),
      //   ),
      // ),

      SizedBox(
        height: 100,
        child: ExcelColumnToAttrPage(userDefine),
      ),

      Column(children: [
        Row(children: [
          const Text("列序号："),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 40, minWidth: 10, maxWidth: 100),
            child: TextField(
              controller: TextEditingController(),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(15), //限制长度
                FilteringTextInputFormatter.allow(
                    RegExp("[0-9.]")
                ),
              ],
              autofocus: true,
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                hintText: 'To Beautify String',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (text){
                if('' == text) {
                  firstNum = 0;
                } else {
                  firstNum = int.parse(text);
                }
              },
            ),
          ),
          const Text("属性名："),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 40, minWidth: 10, maxWidth: 100),
            child: TextField(
              controller: TextEditingController(),
              autofocus: true,
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                hintText: 'To Beautify String',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (text){
                firstName = text;
              },
            ),
          ),
        ],),
        Row(children: [
          const Text("列序号："),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 40, minWidth: 10, maxWidth: 100),
            child: TextField(
              controller: TextEditingController(),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(15), //限制长度
                FilteringTextInputFormatter.allow(
                    RegExp("[0-9.]")),
              ],
              autofocus: true,
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                hintText: 'To Beautify String',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (text){
                if('' == text) {
                  secondNum = 0;
                } else {
                  secondNum = int.parse(text);
                }
              },
            ),
          ),
          const Text("属性名："),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 40, minWidth: 10, maxWidth: 100),
            child: TextField(
              controller: TextEditingController(),
              autofocus: true,
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                hintText: 'To Beautify String',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (text){
                secondName = text;
              },
            ),
          ),
        ],)
      ],),

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
    final String fileName = xfile.name;

    var file = File(xfile.path);

    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    var userDefine = List<ExcelColumnToJsonAttrDefine>.empty();


    var attrTranslateDefine = translateUserDefine(userDefine);

    var firstDefine = TranslateDefine(firstNum, firstName);
    var secondDefine = TranslateDefine(secondNum, secondName);
    attrTranslateDefine = List<TranslateDefine>.of([firstDefine,secondDefine]);


    var jsonObjs = List<Map<String, dynamic>>.empty(growable: true);
    for (var table in excel.tables.keys) {
      var tab = excel.tables[table];
      if(null != tab) {
        var maxRows = tab.maxRows;
        // 忽略第一行
        for (var i = 1; i< maxRows; i++) {
          var row = tab.rows.elementAt(i);
          var curJsonObj = HashMap<String, dynamic>();
          for(var define in attrTranslateDefine) {
            var colData = row.elementAt(define.columnIndex);
            var val = colData?.value;
            curJsonObj.putIfAbsent(define.jsonAttrName, () => val);
          }
          jsonObjs.add(curJsonObj);
        }
      }
      // 只解析第一个sheet
      break;
    }

    var toSavePath = fileName.substring(0, fileName.indexOf(r'.'));
    var partitionJsonObjs = partition(jsonObjs, 100);



    final String initialDirectory =
        (await getDownloadsDirectory())!.path;
    String saveFilePath = initialDirectory + "/";

    for(var i=0; i<partitionJsonObjs.length; i++) {
      String saveFileName = saveFilePath + toSavePath + "_to_json_"+ i.toString() +".json";

      var curJsonObjs = partitionJsonObjs[i];
      var curJsonObjsStr = jsonEncode(curJsonObjs);

      var file = File(saveFileName);
      file.writeAsString(curJsonObjsStr);
    }

  }

  void notifySavedPath(String saveFilePath) {
    setState(() {
      savedFilePath = saveFilePath;
    });
  }

  List<TranslateDefine> translateUserDefine(List<ExcelColumnToJsonAttrDefine> userDefines) {
    var defines = List<TranslateDefine>.empty();
    for(var userDefine in userDefines) {
      var index = userDefine.columnIndex;
      var jsonAttrName = userDefine.jsonAttrName;

      var proIndex = index! - 1;
      var define = TranslateDefine(proIndex, jsonAttrName!);
      defines.add(define);
    }
    return defines;
  }
}

List<List<E>> partition<E>(List<E> list, int size) {
  if(list.isEmpty) {
    return List.empty();
  }
  int totalPage = (list.length / size).ceil();

  var result = List<List<E>>.empty(growable: true);
  for(int i=0; i<totalPage; i++) {
    int start = i * size;
    int nextStart = start + size;
    int end = nextStart > list.length ? list.length : nextStart;
    result.add(list.sublist(start, end));
  }
  return result;
}

class ExcelColumnToAttrPage extends StatefulWidget {

  List<ExcelColumnToJsonAttrDefine> userDefine;

  ExcelColumnToAttrPage(this.userDefine);

  @override
  State<StatefulWidget> createState() {
    return _ExcelColumnToAttrPageState();
  }

}

class _ExcelColumnToAttrPageState extends State<ExcelColumnToAttrPage> {



  @override
  Widget build(BuildContext context) {
   this.widget.userDefine;

   // return ListView();
    return ListView.builder(
        itemCount: this.widget.userDefine.length,
        itemBuilder: (context, index){
          return Text("text_$index", key: Key('text_$index'),);

        },
    );
  }

}




enum ExcelColumnToJsonAttrUseType {
  useColumnName,
  useColumnIndex,

}

class ExcelColumnToJsonAttrDefine {

  /// 列号，从 1 开始
  int? columnIndex;

  /// 列名称
  String? columnName;

  /// 转化后的 json 属性名称
  String? jsonAttrName;

}

class TranslateDefine {
  int columnIndex;
  String jsonAttrName;

  TranslateDefine(this.columnIndex, this.jsonAttrName);
}