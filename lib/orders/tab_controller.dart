import 'package:flutter/material.dart';

class TabNavBar extends StatelessWidget {
  final int activeIndex;
  final Function updateIndex;
  const TabNavBar(
      {Key? key, required this.activeIndex, required this.updateIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          TabSwitch(
            tabName: "Open Orders",
            activeIndex: activeIndex,
            index: 0,
            updateIndex: updateIndex,
          ),
          TabSwitch(
            tabName: "Closed Orders",
            activeIndex: activeIndex,
            index: 1,
            updateIndex: updateIndex,
          ),
        ],
      ),
    );
  }
}

class TabSwitch extends StatefulWidget {
  final String tabName;
  final int activeIndex;
  final int index;
  final Function updateIndex;

  const TabSwitch(
      {Key? key,
      required this.tabName,
      required this.activeIndex,
      required this.index,
      required this.updateIndex})
      : super(key: key);

  @override
  State<TabSwitch> createState() => _TabSwitchState();
}

class _TabSwitchState extends State<TabSwitch> {
  Color bgColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.updateIndex(widget.index),
      onTapDown: (tap) {
        setState(() {
          bgColor = Colors.grey;
        });
      },
      onTapUp: (tap) {
        bgColor = Colors.white;
      },
      child: Container(
        padding: const EdgeInsets.only(top: 12),
        color: bgColor,
        width: MediaQuery.of(context).size.width * .5,
        child: Column(
          children: [
            Text(
              widget.tabName,
              style: TextStyle(
                  fontSize: 18,
                  color: widget.activeIndex == widget.index
                      ? Colors.deepOrange
                      : Colors.black),
            ),
            Divider(
              thickness: 2,
              color: widget.activeIndex == widget.index
                  ? Colors.deepOrange
                  : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
