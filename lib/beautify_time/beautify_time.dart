
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BeautifyTimeWidget extends StatefulWidget {
  const BeautifyTimeWidget({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _BeautifyTimeWidgetState();
  }

}

class _BeautifyTimeWidgetState extends State<BeautifyTimeWidget> {

  int _nowMillisecond = 0;
  Timer? _nowMillisecondTimer;

  final _timestamp2TimeStrTextFieldController = TextEditingController();
  final _timeStr2TimestampTextFieldController = TextEditingController();

  final _timestamp2TimeStrItem = const [
    DropdownMenuItem<String>(value: "ms", child: Text("Millisecond",),),
    DropdownMenuItem<String>(value: "s", child: Text("Second"),),
  ];

  String _timestamp2TimeStrDropdownValue = "ms";

  String _timestamp2TimeStrResult = "";

  String _timeStr2TimestampDropdownValue = "ms";

  String _timeStr2TimestampResult = "";

  @override
  void initState() {
    super.initState();
    _nowMillisecondTimer = Timer.periodic(const Duration(seconds: 3), (timer){
      setState(() {
        _nowMillisecond = DateTime.now().toUtc().millisecondsSinceEpoch;
      });
    });

    var nowStr = formatDateTime(DateTime.now().toUtc());
    _timeStr2TimestampTextFieldController.text = nowStr;
  }

  @override
  void dispose() {
    super.dispose();
    _nowMillisecondTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Text("Time stamp(Does not account for daylight saving time)"),
          ],
        ),
        Row(
          children: [
            const Text("Now:"),
            SelectableText(_nowMillisecond.toString()),
          ],
        ),
        Row(
          children: [
            const Text("Time stamp:"),
            SizedBox(
              width: 150,
              child: TextField(
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller: _timestamp2TimeStrTextFieldController,
              ),
            ),
            DropdownButton<String>(
              value: _timestamp2TimeStrDropdownValue,
              items: _timestamp2TimeStrItem,
              onChanged: (value) {
                setState(() {
                  _timestamp2TimeStrDropdownValue = value!;
                });
              },
            ),
            MaterialButton(
              color: Colors.lightBlue,
              child: const Text("transform >>"),
              onPressed: (){
                String inputValue = _timestamp2TimeStrTextFieldController.value.text;
                if(inputValue.isNotEmpty) {
                  var inputIntValue = int.parse(inputValue);
                  if("s" == _timestamp2TimeStrDropdownValue) {
                    inputIntValue = inputIntValue * 1000;
                  }
                  var inputDateTime = DateTime.fromMillisecondsSinceEpoch(inputIntValue).toUtc();

                  var inputDateTimeStr = formatDateTime(inputDateTime);
                  setState(() {
                    _timestamp2TimeStrResult = inputDateTimeStr;
                  });
                }
              },
            ),
            SizedBox(
              width: 150,
              child: SelectableText(
                  _timestamp2TimeStrResult
              ),
            ),

            MaterialButton(
              child: const Text("Copy"),
              color: Colors.lightBlue,
              onPressed: (){
                Clipboard.setData(ClipboardData(text: _timestamp2TimeStrResult));
              },
            ),
          ],
        ),
        Row(
          children: [
            const Text("Time:"),
            SizedBox(
              width: 180,
              child: TextField(
                keyboardType: TextInputType.datetime,
                controller: _timeStr2TimestampTextFieldController,
              ),
            ),

            MaterialButton(
              color: Colors.lightBlue,
              child: const Text("transform >>"),
              onPressed: (){
                var inputValue = _timeStr2TimestampTextFieldController.text;

                try {
                  var inputDateTime = DateTime.parse(inputValue).toUtc();
                  int inputDataTimeInt = inputDateTime.millisecondsSinceEpoch;
                  if ("s" == _timeStr2TimestampDropdownValue) {
                    inputDataTimeInt = inputDataTimeInt ~/ 1000;
                  }
                  setState(() {
                    _timeStr2TimestampResult = inputDataTimeInt.toString();
                  });
                } catch(e) {
                  setState(() {
                    _timeStr2TimestampResult = "";
                  });
                }
              },
            ),
            SizedBox(
              width: 120,
              child: SelectableText(_timeStr2TimestampResult),
            ),
            DropdownButton<String>(
              items: _timestamp2TimeStrItem,
              value: _timeStr2TimestampDropdownValue,
              onChanged: (value) {
                setState(() {
                  _timeStr2TimestampDropdownValue = value!;
                });
              },
            ),
            MaterialButton(
              child: const Text("Copy"),
              color: Colors.lightBlue,
              onPressed: (){
                Clipboard.setData(ClipboardData(text: _timeStr2TimestampResult));
              },
            ),
          ],
        ),
      ],
    );
  }

  String formatDateTime(DateTime date) {
    return "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
  }

}