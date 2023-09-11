import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: const Center(
          child: ParentWidget(),
        ),
      ),
    );
  }
}

class TapBoxA extends StatefulWidget {
  const TapBoxA({super.key});

  @override
  State<TapBoxA> createState() => _TapBoxAState();
}

class _TapBoxAState extends State<TapBoxA> {
  bool _active = false;

  void _handleTop() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTop,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
        child: Center(
          child: Text(
            _active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

//親
//TapboxB
//TapboxC
//active状態を管理する
//ボックスがタップされた時に、_handleTopboxChengedを呼ぶ
//タップが発生し、_activeの状態が変更されると、setStateを呼び出してUIを更新する
class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTopboxChenged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TapboxC(
        active: _active,
        onChanged: _handleTopboxChenged,
      ),
    );
  }
}

//子
//タップを検知すると、親に通知する
class TapBoxB extends StatelessWidget {
  final bool active;
  final ValueChanged<bool> onChanged;

  const TapBoxB({super.key, this.active = false, required this.onChanged});

  void _handleTop() {
    onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTop,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
        child: Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

//子
//_activeの状態は親に渡すが、
//_highlight状態は内部で管理する
class TapboxC extends StatefulWidget {
  final bool active;
  final ValueChanged<bool> onChanged;

  const TapboxC({
    super.key,
    this.active = false,
    required this.onChanged,
  });

  @override
  State<TapboxC> createState() => _TapBoxCState();
}

class _TapBoxCState extends State<TapboxC> {
  bool _hithlight = false;

  void _handleTopDown(TapDownDetails details) {
    setState(() {
      _hithlight = true;
    });
  }

  void _handleTopUp(TapUpDetails details) {
    setState(() {
      _hithlight = false;
    });
  }

  void _handleTopCancel() {
    setState(() {
      _hithlight = false;
    });
  }

  void _handleTop() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    //GestureDetectorは全てのタップイベントをリッスンする
    //タップイベントが発生すると、その状態変化を親ウィジェットに渡し、
    //ウェジェットプロパティを使用して適切なアクションを実行する
    return GestureDetector(
      onTapDown: _handleTopDown,
      onTapUp: _handleTopUp,
      onTap: _handleTop,
      onTapCancel: _handleTopCancel,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
          border: _hithlight ? Border.all(color: Colors.teal[700]!, width: 10) : null,
        ),
        child: Center(
          child: Text(
            widget.active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
