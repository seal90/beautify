import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:pretty_json/pretty_json.dart';


class BeautifyJsonWidget extends StatefulWidget {

  Function identifyStrFunc;

  UniqueKey tabUniqueKey;

  BeautifyJsonWidget(this.tabUniqueKey, this.identifyStrFunc, { Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BeautifyJsonWidgetState();
  }

}

class _BeautifyJsonWidgetState extends State<BeautifyJsonWidget> {

  final TextEditingController _textEditingController = TextEditingController();

  Map<String, dynamic> beautifyJsonData = {};

  bool formatInputEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _toJsonConfigView(),
                _toJosnInputView(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _viewJsonConfigView(),
                _viewJsonView(),
              ],
            ),
          ),
        ],
      );
  }

  void _formatInputChange() {
    setState(() {
      _beautifyInput();
    });
  }

  void _beautifyInput() {
    String prettyStr = prettyJson(beautifyJsonData, indent: 2);

    _textEditingController.value = TextEditingValue(
      text: prettyStr,
      composing: _textEditingController.value.composing,
      selection: _textEditingController.value.selection,
    );
  }

  /// 开启格式化输入内容
  void _formatInputEnabledChange() {
    setState(() {
      formatInputEnabled = !formatInputEnabled;
    });
  }

  Widget _viewJsonView() {

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius:const BorderRadius.all(//圆角
            Radius.circular(5.0),
          ),
        ),

        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: JsonView.map(
            beautifyJsonData,
            theme: const JsonViewTheme(
              keyStyle: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              doubleStyle: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 16,
              ),
              intStyle: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 16,
              ),
              stringStyle: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 16,
              ),
              boolStyle: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 16,
              ),
              closeIcon: Icon(
                Icons.arrow_drop_up,
                color: Colors.purpleAccent,
                size: 20,
              ),
              openIcon: Icon(
                Icons.arrow_drop_down,
                color: Colors.purpleAccent,
                size: 20,
              ),
              separator: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.arrow_right_alt_outlined,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }

  Widget _viewJsonConfigView() {
    return Row(
      children: [
        MaterialButton(
          child: Row(
            children: const [
              Icon(Icons.copy),
              Text("Copy Json"),
            ],
          ),
          onPressed: (){
            String prettyStr = prettyJson(beautifyJsonData, indent: 2);
            Clipboard.setData(ClipboardData(text: prettyStr));
          }
        ),
      ],
    );
  }

  Widget _toJosnInputView() {
    return Expanded(
      // child: Container(height:100, width: 100, color: Colors.red,),
      child: TextField(
        controller: _textEditingController,
        keyboardType: TextInputType.multiline,
        minLines: 10000,
        maxLines: 10000,
        autofocus: true,
        cursorColor: Colors.blue,
        decoration: const InputDecoration(
          hintText: '需要美化的字符串',
          // labelText: '字符串',
          // 未获得焦点下划线设为灰色
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          //获得焦点下划线设为蓝色
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        onChanged: (text){
          _toBeautifyJsonData(text);
        },
      ),
    );
  }

  void _toBeautifyJsonData(String text) {
    setState(() {
      if(text.isEmpty) {
        beautifyJsonData = {};
      } else {
        try {
          beautifyJsonData = jsonDecode(text);
          if(formatInputEnabled) {
            _beautifyInput();
          }
        } catch (e) {

        }
      }
    });
  }

  Widget _toJsonConfigView() {
    return Wrap(
      children: [
        Row(
          children: [
            // const Text("identify"),
            SizedBox(
              width: 100,
              height: 25,
              child: TextField(
                scrollPadding: const EdgeInsets.all(0.0),
                onChanged: (value){
                  setState(() {
                    widget.identifyStrFunc(widget.tabUniqueKey, value);
                  });
                },
              ),
            ),
            MaterialButton(
              child: Row(
                children: [
                  Icon(
                    Icons.power_settings_new_outlined,
                    color: formatInputEnabled ? Colors.blue : Colors.black,
                  ),
                  Text(
                    'Format Input',
                    style: TextStyle(
                      color: formatInputEnabled ? Colors.blue : Colors.black,
                    ),
                  ),
                ],
              ),
              onPressed: _formatInputChange,
              onLongPress: _formatInputEnabledChange,
            ),
          ],
        ),
      ],
    );
  }
}