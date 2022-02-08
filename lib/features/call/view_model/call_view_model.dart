import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video_call_app/core/webrtc_utils/signaling.dart';

class CallViewModel extends ChangeNotifier {
  Signaling signaling = Signaling();
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  init() {
    localRenderer.initialize();
    remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      remoteRenderer.srcObject = stream;
      notifyListeners();
    });
  }

  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
  }

  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: textEditingController.text));
  }
}
