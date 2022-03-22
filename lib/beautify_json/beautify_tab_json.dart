
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import 'beautify_json.dart';

class BeautifyTabJsonWidget extends StatefulWidget {

  BeautifyTabJsonWidget({Key? key}) : super(key: key);

  final TabbedViewController controller = TabbedViewController([]);

  bool firstInitFlag = true;

  int num = 1;

  @override
  State<StatefulWidget> createState() {
    return _BeautifyTabJsonWidgetState();
  }

}

class _BeautifyTabJsonWidgetState extends State<BeautifyTabJsonWidget> {

  TabbedViewController controller = TabbedViewController([]);

  bool get firstInitFlag => widget.firstInitFlag;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    for(TabData tabData in controller.tabs) {
      (tabData.content as BeautifyJsonWidget).identifyStrFunc = _identifyStrStateFunc2;
    }
  }

  @override
  Widget build(BuildContext context) {
    _firstInit();
    TabbedView tabbedView = TabbedView(
      controller: controller,
      tabsAreaButtonsBuilder: (context, tabsCount) {
        List<TabButton> buttons = [];
        buttons.add(TabButton(
            icon: IconProvider.data(Icons.add),
            onPressed: () {
              _crateTabJson();
            }));
        if (tabsCount > 0) {
          buttons.add(TabButton(
            icon: IconProvider.data(Icons.delete),
            onPressed: () {
              if (controller.selectedIndex != null) {
                controller.removeTab(controller.selectedIndex!);
              }
            }));
        }
        return buttons;
      },
    );
    return tabbedView;
  }

  void _crateTabJson() {
    String identifyStr = 'tab___${widget.num}';
    widget.num++;
    var tabData = TabData(text: identifyStr,);
    UniqueKey tabKey = tabData.uniqueKey;
    tabData.content = BeautifyJsonWidget(identifyStr, _identifyStrStateFunc2);
    widget.controller.addTab(tabData);
  }

  void _firstInit() {
    if(firstInitFlag) {
      for (int i = 0; i < 5; i++) {
        _crateTabJson();
      }
    }
    widget.firstInitFlag = false;
  }

  void _identifyStrStateFunc2(String value){
    int index = controller.selectedIndex ?? 0;
    setState(() {
      controller.tabs[index].text = value;
    });

  }

  void _identifyStrStateFunc(UniqueKey tabKey, String value){
    for(TabData tabData in controller.tabs) {
      if(tabData.uniqueKey == tabKey) {
        setState(() {
          tabData.text = value;
        });
        break;
      }
    }
  }
}