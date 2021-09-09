import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_control/pdu_widgets/pdu_control.dart';

class PDUOutletControlWidget extends StatefulWidget {
  final String name;
  final OutletState initialState;

  const PDUOutletControlWidget(
      {Key? key, required this.name, required this.initialState})
      : super(key: key);

  static Iterable<PDUOutletControlWidget> allOutlets(
      {required PDUInfo pduInfo}) sync* {
    for (final outlet in pduInfo.outlets.entries)
      yield PDUOutletControlWidget(
          name: outlet.key, initialState: outlet.value);
  }

  @override
  _PDUOutletControlWidgetState createState() => _PDUOutletControlWidgetState();
}

class _PDUOutletControlWidgetState extends State<PDUOutletControlWidget> {
  late OutletState outletState = widget.initialState;

  String _translateName(String x) {
    final translators = const {
      "Outlet 1": "usv",
      "Outlet 2": "modem",
      "Outlet 3": "gaming",
      "Outlet 4": "fan"
    };
    return translators[x] ?? x;
  }

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(
            outletState == OutletState.ON ? Icons.power : Icons.power_off),
        title: Row(
          children: [
            Text(_translateName(widget.name)),
            Spacer(),
            ElevatedButton(
              onPressed: (widget.name == "Outlet 1")
                  ? null
                  : () {
                      if (widget.name != "Outlet 1") {
                        final pdu = context.read<PDUCommander?>();
                        if (pdu != null) {
                          pdu.setOutletState(
                              int.parse(
                                      widget.name.replaceAll("Outlet ", "")) -
                                  1,
                              outletState.toggle());
                          setState(() {
                            outletState = outletState.toggle();
                          });
                        }
                      }
                    },
              child: Text(outletState == OutletState.ON ? "ON" : "OFF"),
            ),
          ],
        ),
      );
}
