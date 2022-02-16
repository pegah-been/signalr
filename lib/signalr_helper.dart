import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:signalr_core/signalr_core.dart';

import 'message.dart';


late HubConnection hubConnection;

class SignalRHelper {
  final url = 'https://testso.pishgamanasia.ir/chatHub';
  var messageList3 = {};
  var messageList2 = [];
  var data='';

  var messageList = <Message>[];
  String textMessage='';

  void connect(receiveMessageHandler) {
    hubConnection = HubConnectionBuilder().withUrl(url,HttpConnectionOptions(
      client: IOClient(HttpClient()..badCertificateCallback = (x, y, z) => true),
      logging: (level, message) => print("MESAGE:::::"+message),
    )).build();
    hubConnection.onclose((error) {
      log('Connection Close');
      print("error2::::"+error.toString());

    });
    hubConnection.serverTimeoutInMilliseconds = 100000; // 100 second
    hubConnection.start()!.catchError((onError){
      print("onError::::"+onError.toString());
    }
    );
    hubConnection.on('ReceiveMessage', receiveMessageHandler);
    // hubConnection.on('ReceiveMessage',(data){
    //
    // });
    // hubConnection.on('ReceiveMessage',(data){
    //   messageList2=data!.cast<String>();
    //   messageList3=messageList2.length.toString();
    //   print("messageList3:::"+messageList3);
    //
    // });

  }

  void sendMessage(String name, String message) {
    hubConnection.invoke('SendMessage', args: [name, message]);
    // messageList.add(Message(
    //     name: name,
    //     message: message,
    //     isMine: true));
    textMessage='';
  }

  void disconnect() {
    hubConnection.stop();
  }


}