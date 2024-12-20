import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'movie_selection_screen.dart';
import 'package:movie_night/utils/http_helper.dart';
import 'package:provider/provider.dart';
import 'package:movie_night/utils/app_state.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String _code = "Fetching...";

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    final response = await HttpHelper.startSession(deviceId);
    if (mounted) {
      setState(() {
        _code = response['data']['code'];
        Provider.of<AppState>(context, listen: false)
            .setSessionId(response['data']['session_id']);
      });
    }
    if (kDebugMode) {
      print("Code: $_code");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Share Code',
          style: textTheme.headlineMedium,
        ),
        backgroundColor: colorScheme.secondary,
      ),
      body: Container(
        color: colorScheme.surface,
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _code,
                  style: textTheme.displayLarge,
                ),
                const SizedBox(height: 32.0),
                const Text("Share this code with your friends"),
                const SizedBox(height: 120.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: colorScheme.onSecondary,
                      backgroundColor: colorScheme.secondary,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const MovieSelectionScreen();
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Begin",
                        style: textTheme.headlineSmall,
                      ),
                    ))
              ]),
        ),
      ),
    );
  }
}
