import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:pretty_json/pretty_json.dart';


class BeautifyJsonWidget extends StatefulWidget {

  ValueChanged<String> identifyStrFunc;

  String identifyStr;

  dynamic beautifyJsonData = "";

  bool formatInputEnabled = false;

  String sourceStr = "";

  BeautifyJsonWidget(this.identifyStr, this.identifyStrFunc, { Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BeautifyJsonWidgetState();
  }

}

class _BeautifyJsonWidgetState extends State<BeautifyJsonWidget> {

  final TextEditingController _textEditingController = TextEditingController();

  final TextEditingController _identifyEditingController = TextEditingController();

  String viewStr = "";

  @override
  void initState() {
    super.initState();
    _identifyEditingController.text = widget.identifyStr;
    _textEditingController.text = widget.sourceStr;
    try {
      jsonDecode(widget.sourceStr);
      viewStr = widget.sourceStr;
    } finally {

    }
  }

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

  @override
  void dispose() {
    super.dispose();
    widget.sourceStr = _textEditingController.text;
    widget.identifyStr = _identifyEditingController.text;
  }

  void _formatInputChange() {
    setState(() {
      _beautifyInput();
    });
  }

  void _beautifyInput() {
    final jsonMap = jsonDecode(widget.sourceStr);
    JsonEncoder encoder = const JsonEncoder.withIndent(' ');
    String jsonString = encoder.convert(jsonMap);

    _textEditingController.value = TextEditingValue(
      text: jsonString,
      composing: _textEditingController.value.composing,
      selection: _textEditingController.value.selection,
    );
  }

  void _formatInputEnabledChange() {
    setState(() {
      widget.formatInputEnabled = !widget.formatInputEnabled;
    });
  }

  Widget _viewJsonView() {

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius:const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),

        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: JsonView.string(
            viewStr.isEmpty? "{}": viewStr,
            theme: const JsonViewTheme(
                viewType: JsonViewType.collapsible,
                closeIcon: Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: Colors.black,
                ),
                openIcon: Icon(
                  Icons.arrow_right,
                  size: 18,
                  color: Colors.black,
                ),
                separator:Text(' : ',),
                backgroundColor: Colors.white),

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
            String prettyStr = prettyJson(widget.beautifyJsonData, indent: 2);
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
          hintText: 'To Beautify String',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
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
        widget.beautifyJsonData = List.empty();
        widget.sourceStr = "";
      } else {
        try {
          widget.sourceStr = text;
          widget.beautifyJsonData = jsonDecode(text);
          viewStr = text;
          if(widget.formatInputEnabled) {
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
            SizedBox(
              width: 100,
              height: 25,
              child: TextField(
                controller: _identifyEditingController,
                scrollPadding: const EdgeInsets.all(0.0),
                onChanged: (value){
                  setState(() {
                    widget.identifyStrFunc(value);
                  });
                },
              ),
            ),
            MaterialButton(
              child: Row(
                children: [
                  Icon(
                    Icons.power_settings_new_outlined,
                    color: widget.formatInputEnabled ? Colors.blue : Colors.black,
                  ),
                  Text(
                    'Format Input',
                    style: TextStyle(
                      color: widget.formatInputEnabled ? Colors.blue : Colors.black,
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