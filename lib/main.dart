import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<void> _startHttpServer() async {
    // Start the server
    final server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      8080,
    );

    print('Listening on ${server.address.address}:${server.port}');

    // Listen for requests
    await for (final request in server) {
      if (request.method == 'POST' && request.uri.path == '/data') {
        var content = await utf8.decoder.bind(request).join();
        var data = json.decode(content);
        print('Received data: $data');
        request.response
          ..statusCode = HttpStatus.ok
          ..write('Data received')
          ..close();
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..write('Not Found')
          ..close();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _startHttpServer();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
