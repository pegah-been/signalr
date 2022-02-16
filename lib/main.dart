import 'package:flutter/material.dart';
import 'package:signalr_app/signalr_helper.dart';
import 'dart:async';
import 'package:signalr_flutter/signalr_flutter.dart';

import 'message.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _signalRStatus = 'Unknown';
  // late SignalR signalR;
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  SignalRHelper signalR2 = SignalRHelper();
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    // initPlatformState();
    signalR2.connect(receiveMessageHandler);

    startTimer();
    setState(() {
      // _signalRStatus= signalR2.hubConnection.state.toString();
    });

  }
  void startTimer() async {
    var second =20;
    print("second:::"+second.toString());
    var oneSec = Duration(seconds: second);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) async {
        signalR2.connect(receiveMessageHandler);

        print('timer::::::::');
      },
    );
  }
  receiveMessageHandler(args) {
    signalR2.messageList.add(Message(
        name: args[0], message: args[1], isMine: args[0] =="pegah"));
    setState(() {});
  }
  // _handleServerInvokeMethodSimpleParametersNoReturnValue( parameters) {
  //
  //   final paramValues = new StringBuffer("Parameters: ");
  //   for(int i = 0; i < parameters.length; i++){
  //     final value = parameters[i];
  //     // paramValues.write( "$i => $value, ");
  //     print("pega22:::: " + value.toString());
  //
  //   }
  //
  //   print("pega:::: " + paramValues.toString());
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   signalR = SignalR(
  //       'https://testso.pishgamanasia.ir',
  //       "chatHub",
  //       hubMethods: ["ReceiveMessage"],
  //       statusChangeCallback: _onStatusChange,
  //       hubCallback: _onNewMessage);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SignalR Plugin Example App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Connection Status: $_signalRStatus\n',
                  style: Theme.of(context).textTheme.headline5),
              Text(_signalRStatus,
                  style: Theme.of(context).textTheme.headline5),
              Text(signalR2.messageList.toString(),
                  style: Theme.of(context).textTheme.headline5),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                    onPressed: _buttonTapped, child: Text("Invoke Method")),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.cast_connected),
          onPressed: () async {
            // final isConnected =  signalR2. ?? false;
            // print(" isConnected::::"+ isConnected.toString());
            // if (!isConnected) {
            signalR2.connect(receiveMessageHandler);
            //   print("args3:::"+signalR2.messageList.toString());
            // signalR2.disconnect();
            print("_signalRStatus::::"+_signalRStatus);


            // } else {
            //   signalR2.disconnect();
            // }
          },
        ),
      ),
    );
  }

  _onStatusChange(dynamic status) {
    if (mounted) {
      setState(() {
        _signalRStatus = status as String;
        print("_signalRStatus::::"+_signalRStatus);
      });
    }
  }

  _onNewMessage(String? methodName, dynamic message) {
    print('MethodName = $methodName, Message = $message');
  }

  _buttonTapped() async {
    // final res = await signalR2.invokeMethod<dynamic>("SendMessage",
    //     arguments: ["pegah","javar"]).catchError((error) {
    //   print(error.toString());
    // });
    signalR2.sendMessage("pegah","javar");

    // final snackBar = SnackBar(content: Text('SignalR Method Response:'+res));
    // rootScaffoldMessengerKey.currentState!.showSnackBar(snackBar);
  }
}