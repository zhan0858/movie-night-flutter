import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../utils/app_state.dart';
import '../utils/http_helper.dart';
import 'movie_selection_screen.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _errorMessage;

  Future<void> _submitCode() async {
    final code = _codeController.text;
    if (code.length != 4) {
      setState(() {
        _errorMessage = "Code must be 4 characters long";
      });
      return;
    }

    final deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    final response = await HttpHelper.joinSession(code, deviceId);
    if (kDebugMode) {
      print("join session response == $response");
    }
    // error handling
    if (response.containsKey("code")) {
      setState(() {
        _errorMessage = response['message'];
        _showErrorDialog(response["message"]);
      });
      return;
    } else {
      final sessionId = response["data"]["session_id"];
      if (!mounted) return;
      Provider.of<AppState>(context, listen: false).setSessionId(sessionId);

      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const MovieSelectionScreen();
        }));
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/error.png',
              ),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _codeController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter Code',
          style: textTheme.titleLarge,
        ),
        backgroundColor: colorScheme.secondary,
      ),
      body: Container(
        color: colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  style: textTheme.displayMedium,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "Enter 4-digit code",
                    errorText: _errorMessage,
                    counterStyle: textTheme.displayMedium,
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: colorScheme.onSecondary,
                    backgroundColor: colorScheme.secondary,
                  ),
                  onPressed: _submitCode,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
