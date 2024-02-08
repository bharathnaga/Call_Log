import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:call_log/call_log.dart';

void main() {
  runApp(CallLogApp());
}

class CallLogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Log App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CallLogScreen(),
    );
  }
}

class CallLogScreen extends StatefulWidget {
  @override
  _CallLogScreenState createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  List<CallLogEntry>? _callLogEntries = [];

  @override
  void initState() {
    super.initState();
    _getCallLog();
  }

  Future<void> _getCallLog() async {
    PermissionStatus permissionStatus = await Permission.phone.request();

    if (permissionStatus.isGranted) {
      try {
        Iterable<CallLogEntry>? callLog = await CallLog.get();
        setState(() {
          _callLogEntries = callLog?.toList();
        });
      } catch (e) {
        // Handle error when getting call log
        print('Error getting call log: $e');
      }
    } else {
      // Handle case when permission is not granted
      print('Permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Log'),
      ),
      body: ListView.builder(
        itemCount: _callLogEntries?.length ?? 0,
        itemBuilder: (context, index) {
          CallLogEntry? callLogEntry = _callLogEntries?[index];
          return ListTile(
            leading: const Icon(Icons.call),
            title: Text(callLogEntry?.name ?? 'Unknown'),
            subtitle: Text(callLogEntry?.number ?? ''),
            trailing: Text(callLogEntry?.duration.toString() + 's'),
            onTap: () {
              // Handle tap on call log entry
            },
          );
        },
      ),
    );
  }
}
