import 'package:flutter/material.dart';

class PesanScreen extends StatefulWidget {
  final Map dosenData;
  const PesanScreen({super.key, required this.dosenData});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  final TextEditingController _controller = TextEditingController();
  late List messages;

  @override
  void initState() {
    super.initState();
    messages = List.from(widget.dosenData['details']);
  }

  void kirimPesan() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add({
        'role': 'saya',
        'message': _controller.text.trim(),
        'time': DateTime.now().toIso8601String(),
      });
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final nama = widget.dosenData['name'];
    final img = widget.dosenData['img'];
    final colorScheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        widget.dosenData['details'] = messages;
        Navigator.pop(context, widget.dosenData);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundImage: AssetImage(img), radius: 16),
            title: Text(nama, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: const Text('06.30'),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final chat = messages[index];
                  final isDosen = chat['role'] == 'dosen';
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: isDosen
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isDosen)
                          CircleAvatar(
                              backgroundImage: AssetImage(img), radius: 14),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDosen
                                  ? colorScheme.tertiary
                                  : colorScheme.primary,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: Radius.circular(isDosen ? 0 : 12),
                                bottomRight: Radius.circular(isDosen ? 12 : 0),
                              ),
                            ),
                            child: Text(
                              chat['message'],
                              style: TextStyle(
                                fontSize: 15,
                                color: isDosen
                                    ? colorScheme.onTertiary
                                    : colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        if (!isDosen)
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/gambar_saya.jpg'),
                            radius: 14,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.emoji_emotions),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: kirimPesan,
                  ),
                  hintText: 'Ketikkan pesan',
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
