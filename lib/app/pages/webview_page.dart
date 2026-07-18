import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
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
      onMessageReceived: (message) async {
        final url = message.message;
            debugPrint("JS URL: $url");
 final data = message.message;
    // PDF
     if (data.startsWith('data:application/pdf;base64,')) {
    try {
      final base64String =
          data.replaceFirst('data:application/pdf;base64,', '');

      final Uint8List bytes = base64Decode(base64String);

      final dir = await getApplicationDocumentsDirectory();

      final file = File(
        '${dir.path}/Projexino_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      await file.writeAsBytes(bytes);

      debugPrint('PDF SAVED => ${file.path}');

      await OpenFile.open(file.path);

      return;
    } catch (e) {
      debugPrint('PDF ERROR => $e');
    }
  }



        final match = RegExp(r'place_id:([^&]+)').firstMatch(url);

        if (match != null) {
          final placeId = match.group(1)!;

          final googleMapsUri = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query_place_id=$placeId&query=location',
          );

          await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
        }
      },
    );

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            debugPrint("URL => ${request.url}");

            final url = request.url;

            // Open Google Maps externally
            if (url.contains('google.com/maps') ||
                url.contains('maps.google.com') ||
                url.startsWith('geo:')) {
              final uri = Uri.parse(url);

              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }

              return NavigationDecision.prevent;
            }

            // PDF detection
           if (request.url.startsWith('blob:')) {
  debugPrint('BLOB URL => ${request.url}');

  await _controller.runJavaScript('''
    (async function() {
      const response = await fetch("${request.url}");
      const blob = await response.blob();

      const reader = new FileReader();

      reader.onloadend = function() {
        Flutter.postMessage(reader.result);
      };

      reader.readAsDataURL(blob);
    })();
  ''');

  return NavigationDecision.prevent;
}

            return NavigationDecision.navigate;
          },

          onProgress: (progress) => debugPrint('Loading: $progress%'),
          onPageFinished: (url) async {
  await controller.runJavaScript('''
    document.addEventListener('click', function(e) {

      const pdfBtn = e.target.closest('[data-testid="download-pdf-btn"]');
      if (pdfBtn) {
        Flutter.postMessage('PDF_DOWNLOAD_CLICKED');
      }

      const originalOpen = window.open;
      window.open = function(url, target, features) {
        if (url) {
          Flutter.postMessage(url);
        }
        return originalOpen ? originalOpen(url, target, features) : null;
      };
    }, true);
  ''');
},
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
    await [Permission.location, Permission.storage].request();
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
