import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pesan_screen.dart';
import 'package:intl/intl.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  List dosenList = [];

  Future<void> loadData() async {
    final String jsonString = await rootBundle
        .loadString('assets/json_data_chat_dosen/dosen_chat.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      dosenList = jsonData;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  String formatTime(String? iso) {
    if (iso == null) return '';
    final time = DateTime.tryParse(iso);
    if (time == null) return '';
    return DateFormat.Hm().format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'WhNajmaNst',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: SearchAnchor.bar(
              barElevation: const WidgetStatePropertyAll(2),
              barHintText: 'Cari dosen dan mulai chat',
              suggestionsBuilder: (context, controller) {
                return <Widget>[
                  const Center(child: Text('Belum ada pencarian'))
                ];
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: dosenList.length,
        itemBuilder: (context, index) {
          final dosen = dosenList[index];
          final nama = dosen['name'];
          final gambar = dosen['img'];
          final List details = dosen['details'] ?? [];
          final lastChat =
              details.isNotEmpty ? details.last['message'] : 'Belum ada chat';
          final lastTime =
              details.isNotEmpty ? formatTime(details.last['time']) : '';

          return ListTile(
            leading: CircleAvatar(backgroundImage: AssetImage(gambar)),
            title: Text(nama),
            subtitle:
                Text(lastChat, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(lastTime),
            onTap: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PesanScreen(dosenData: dosen),
                ),
              );
              if (updated != null) {
                setState(() {
                  dosenList[index] = updated;
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Pembaruan'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Komunitas'),
          NavigationDestination(icon: Icon(Icons.call), label: 'Panggilan'),
        ],
      ),
    );
  }
}
