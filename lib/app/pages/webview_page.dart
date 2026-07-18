import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({super.key});

  // Notifier to inform parent if login page is active
  final ValueNotifier<bool> isLoginPageNotifier = ValueNotifier(false);

  bool get isLoginPage => isLoginPageNotifier.value;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  Color _backgroundColor = Colors.black;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params);

    // Add JavaScript channel to listen for SPA route changes
    controller.addJavaScriptChannel(
      'Flutter',
      onMessageReceived: (message) {
        final url = message.message;
        debugPrint("SPA URL changed: $url");
        widget.isLoginPageNotifier.value =
            url.contains('/login') || url.contains('/register');
      },
    );

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            debugPrint("URL => ${request.url}");

            // PDF detection
            if (request.url.contains(".pdf")) {
              final Uri url = Uri.parse(request.url);

              await launchUrl(url, mode: LaunchMode.externalApplication);

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },


          onProgress: (progress) => debugPrint('Loading: $progress%'),
        ),
      )
      ..loadRequest(Uri.parse('https://projexino.com/login'));

    if (!kIsWeb && !Platform.isMacOS) {
      controller.setBackgroundColor(Colors.transparent);
    }

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
      requestPermissions();
  }

Future<void> requestPermissions() async {

  await [
    Permission.location,
    Permission.storage,
  ].request();

}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //    final currentUrl = await _controller.currentUrl() ?? '';
        //    if (currentUrl.contains('/login')) { // <-- Replace with your final URL
        //   return false; // Do not navigate back
        // }
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Container(
          color: _backgroundColor,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: WebViewWidget(
            controller: _controller,

            // gestureRecognizers: {
            //   Factory<OneSequenceGestureRecognizer>(
            //       () => EagerGestureRecognizer()),
            // },
          ),
        ),
      ),
    );
  }
}
