import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:server_control/pdu_widgets/pdu_control.dart';
import 'package:server_control/pdu_widgets/pdu_info_widget.dart';
import 'package:server_control/server_status_widgets/server_status_widget.dart';

import 'tools/force_reload.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _providers = <SingleChildWidget>[
    ChangeNotifierProvider<PDUHostnameWrapper>(
      create: (context) =>
          PDUHostnameWrapper.wrap(PDUHostName("192.168.0.100")),
    ),
    ChangeNotifierProvider<PDULoginWrapper>(
      create: (context) => PDULoginWrapper.wrap(PDULogin("admin", "admin")),
    ),
    ChangeNotifierProvider<ForceReload>(
      create: (context) => ForceReload(),
    ),
    ProxyProvider2<PDUHostnameWrapper, PDULoginWrapper, PDUCommander?>(
      create: null,
      update: (context, hostnameW, loginW, result) {
        if (hostnameW.hasValue && loginW.hasValue) {
          return PDUCommander(hostname: hostnameW.value, login: loginW.value);
        } else
          return null;
      },
    ),
    StreamProvider<PDUInfo?>(
      create: (context) async* {
        bool ready = true;
        Timer timer = Timer(Duration(seconds: 10), () => ready = true);

        try {
          while (true) {
            final forceReload = context.read<ForceReload>();
            if (forceReload.value || ready) {
              if (forceReload.value) {
                print("Force Reloaded");
                forceReload.value = false;
              }
              PDUHostnameWrapper hostNameW =
                  context.read<PDUHostnameWrapper>();
              PDULoginWrapper loginW = context.read<PDULoginWrapper>();

              if (hostNameW.hasValue && loginW.hasValue) {
                try {
                  final info = await PDUInfo.fetch(
                      hostname: hostNameW.value, login: loginW.value);
                  yield info;
                } catch (exception) {
                  // catch all
                }
              }
              ready = false;
            }
            await Future.delayed(Duration(seconds: 1));
          }
        } finally {
          timer.cancel();
        }
      },
      initialData: null,
      catchError: (context, error) => null,
    ),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers,
      child: MaterialApp(
        title: 'Server Control',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: HomePage(title: 'Server Control'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  static const List<Tab> tabs = <Tab>[
    Tab(
      text: "PDU Info",
    ),
    Tab(text: "Server Status")
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [PDUInfoWidget(), ServerStatusWidget()],
      ),
    );
  }
}
