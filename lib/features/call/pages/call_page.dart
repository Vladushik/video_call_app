import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:video_call_app/features/call/view_model/call_view_model.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late CallViewModel viewModel;
  @override
  void initState() {
    viewModel = Provider.of<CallViewModel>(context, listen: false)..init();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video call")),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      viewModel.signaling.openUserMedia(
                        viewModel.localRenderer,
                        viewModel.remoteRenderer,
                      );
                    },
                    child: const Text("Open camera"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.signaling.hangUp(viewModel.localRenderer);
                    },
                    child: const Text("Hangup"),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      viewModel.roomId = await viewModel.signaling
                          .createRoom(viewModel.remoteRenderer);
                      viewModel.textEditingController.text = viewModel.roomId!;
                      setState(() {});
                    },
                    child: const Text("Create room"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.signaling.joinRoom(
                        viewModel.textEditingController.text,
                        viewModel.remoteRenderer,
                      );
                    },
                    child: const Text("Join room"),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Join: "),
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                      icon: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: viewModel.copyToClipboard,
                      ),
                    ),
                    controller: viewModel.textEditingController,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RTCVideoView(viewModel.localRenderer, mirror: true),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: RTCVideoView(viewModel.remoteRenderer),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
