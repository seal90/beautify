
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import 'beautify_json.dart';

class BeautifyTabJsonWidget extends StatefulWidget {

  const BeautifyTabJsonWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BeautifyTabJsonWidgetState();
  }

}

class _BeautifyTabJsonWidgetState extends State<BeautifyTabJsonWidget> {

  TabbedViewController controller = TabbedViewController([]);

  @override
  Widget build(BuildContext context) {
    int num = 1;
    TabbedView tabbedView = TabbedView(
      controller: controller,
      tabsAreaButtonsBuilder: (context, tabsCount) {
        List<TabButton> buttons = [];
        buttons.add(TabButton(
            icon: IconProvider.data(Icons.add),
            onPressed: () {
              String identifyStr = 'tab___$num';
              num++;
              var tabData = TabData(text: identifyStr,);
              UniqueKey tabKey = tabData.uniqueKey;
              tabData.content = BeautifyJsonWidget(tabKey, _identifyStrStateFunc);
              controller.addTab(tabData);
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