import 'package:flutter/material.dart';

void main() {
  runApp(const OmniChatApp());
}

class OmniChatApp extends StatelessWidget {
  const OmniChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ChatListScreen(),
    );
  }
}

class ChatItem {
  final String name;
  final String lastMessage;
  final String time;
  final String platform;
  final IconData icon;

  const ChatItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.platform,
    required this.icon,
  });
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  final List<ChatItem> mockChats = const [
    ChatItem(
      name: 'Family Group',
      lastMessage: 'Let us coordinate dinner plans.',
      time: '12:45 PM',
      platform: 'WhatsApp Bridge',
      icon: Icons.chat_bubble_outline,
    ),
    ChatItem(
      name: 'Dev Community',
      lastMessage: 'Merged the latest pull request.',
      time: '11:20 AM',
      platform: 'Telegram Bridge',
      icon: Icons.send_rounded,
    ),
    ChatItem(
      name: 'Alex Rivera',
      lastMessage: 'Sent verification payload.',
      time: 'Yesterday',
      platform: 'Signal Bridge',
      icon: Icons.lock_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OmniChat Universal'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: mockChats.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
        itemBuilder: (context, index) {
          final chat = mockChats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(chat.icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(chat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(chat.time, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    chat.platform,
                    style: const TextStyle(fontSize: 10, color: Colors.tealAccent),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatConversationScreen(chat: chat),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatConversationScreen extends StatefulWidget {
  final ChatItem chat;
  const ChatConversationScreen({super.key, required this.chat});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [
    'Connection established via bridge gateway.',
    'Ready for incoming payloads.'
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(text);
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chat.name, style: const TextStyle(fontSize: 16)),
            Text(widget.chat.platform, style: const TextStyle(fontSize: 11, color: Colors.tealAccent)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isMe = index >= 2;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(
                        color: isMe
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: _sendMessage,
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
