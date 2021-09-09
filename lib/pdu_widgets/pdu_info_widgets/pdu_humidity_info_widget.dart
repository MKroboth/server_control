import 'package:flutter/material.dart';
import 'package:server_control/pdu_widgets/pdu_control.dart';

class PDUHumidityInfoWidget extends StatelessWidget {
  final PDUInfo pduInfo;

  const PDUHumidityInfoWidget({Key? key, required this.pduInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(Icons.opacity),
        title: Row(
          children: [
            Text("Humidity"),
            Spacer(),
            Text("${pduInfo.humidity}%"),
          ],
        ),
      );
}
