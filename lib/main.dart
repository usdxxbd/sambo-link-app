import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String kSamBoUrl = 'https://linktr.ee/sambo_cart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SamboApp());
}

class SamboApp extends StatelessWidget {
  const SamboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SAMBO',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB5121B),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SamboWebView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage('assets/branding/sambo_logo_trimmed.png'),
                  width: 320,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 22),
                Text(
                  'Connecting to SAMBO...',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SamboWebView extends StatefulWidget {
  const SamboWebView({super.key});

  @override
  State<SamboWebView> createState() => _SamboWebViewState();
}

class _SamboWebViewState extends State<SamboWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _offline = false;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;
            setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _offline = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
          },
          onWebResourceError: (_) {
            if (!mounted) return;
            setState(() {
              _offline = true;
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) async {
            final uri = Uri.tryParse(request.url);
            if (uri == null) return NavigationDecision.prevent;

            const externalSchemes = {
              'tel',
              'mailto',
              'sms',
              'intent',
              'market',
              'kakaotalk',
              'youtube',
            };

            if (externalSchemes.contains(uri.scheme)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    _loadHome();
  }

  Future<void> _loadHome() async {
    final connectivity = await Connectivity().checkConnectivity();
    final hasNetwork = !connectivity.contains(ConnectivityResult.none);
    if (!hasNetwork) {
      if (!mounted) return;
      setState(() {
        _offline = true;
        _isLoading = false;
      });
      return;
    }
    await _controller.loadRequest(Uri.parse(kSamBoUrl));
  }

  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _handleBack();
        if (shouldExit && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SAMBO'),
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actions: [
            IconButton(
              tooltip: '새로고침',
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                setState(() => _offline = false);
                await _controller.reload();
              },
            ),
            IconButton(
              tooltip: '공유',
              icon: const Icon(Icons.ios_share),
              onPressed: () {
                Share.share(kSamBoUrl, subject: 'SAMBO');
              },
            ),
            IconButton(
              tooltip: '홈',
              icon: const Icon(Icons.home_outlined),
              onPressed: _loadHome,
            ),
          ],
        ),
        body: Column(
          children: [
            if (_isLoading)
              LinearProgressIndicator(value: _progress == 0 ? null : _progress / 100),
            Expanded(
              child: _offline
                  ? _OfflineView(onRetry: _loadHome)
                  : WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineView extends StatelessWidget {
  const _OfflineView({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 52),
            const SizedBox(height: 16),
            const Text(
              '인터넷 연결을 확인해 주세요.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              '연결 후 다시 시도하면 SAMBO 링크트리가 열립니다.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
