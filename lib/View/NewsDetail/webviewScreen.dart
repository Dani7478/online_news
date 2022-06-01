import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
   WebViewScreen({Key? key,required this.link}) : super(key: key);
  String link;
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}
final Completer<WebViewController> _controller = Completer<WebViewController>();


class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:  WebView(
        initialUrl: widget.link,
        javascriptMode: JavascriptMode.unrestricted,
    ),
    );
  }
}
