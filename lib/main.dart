import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool isCrossTurn = true;
  List<String> board = List.filled(9, "");
  final List<List<int>> winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6],
  ];

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (board[index] != "" || x() != "") return;
    setState(() {
      board[index] = isCrossTurn ? "X" : "O";
      isCrossTurn = !isCrossTurn;
    });
    _controller.forward(from: 0);
  }

  void restartGame() {
    setState(() {
      board = List.filled(9, "");
      isCrossTurn = true;
    });
  }

  String checkWinner() {
    for (var pattern in winPatterns) {
      String first = board[pattern[0]];
      if (first != "" &&
          first == board[pattern[1]] &&
          first == board[pattern[2]]) {
        return first;
      }
    }

    if (!board.contains("")) {
      return "Draw";
    }

    return '';
  }

  String x() {
    if (checkWinner() == "X") return "Player 1 Won";
    if (checkWinner() == "O") return "Player 2 Won";
    if (checkWinner() == "") return "";
    return "DRAW";
  }

  Widget _buildCell(int index) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        height: 100,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black, // keep initial black background
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: const Offset(3, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: board[index] == "X"
                ? Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 60)
                : board[index] == "O"
                    ? Icon(Icons.circle_outlined, color: Colors.blueAccent, size: 60)
                    : null,
          ),
        ),
      ),
    );
  }

  Widget _buildWinnerScreen(String text) {
    return Scaffold(
      appBar: AppBar(title: const Text("Game Over")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                color: text == "DRAW" ? Colors.orange : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 36,
                shadows: const [
                  Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 3),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: restartGame,
              icon: const Icon(Icons.replay),
              label: const Text("Play Again!"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (x() == 'Player 1 Won') return _buildWinnerScreen('Player 1 Won');
    if (x() == 'Player 2 Won') return _buildWinnerScreen('Player 2 Won');
    if (x() == 'DRAW') return _buildWinnerScreen('DRAW');

    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe')),
      backgroundColor: Colors.grey[900], // make the whole screen dark
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: isCrossTurn ? 1.0 : 0.3,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    Icon(Icons.cancel_outlined,
                        color: Colors.redAccent, size: 80),
                    Text("Turn",
                        style: GoogleFonts.poppins(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              AnimatedOpacity(
                opacity: !isCrossTurn ? 1.0 : 0.3,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    Icon(Icons.circle_outlined,
                        color: Colors.blueAccent, size: 80),
                    Text("Turn",
                        style: GoogleFonts.poppins(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_buildCell(0), _buildCell(1), _buildCell(2)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_buildCell(3), _buildCell(4), _buildCell(5)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_buildCell(6), _buildCell(7), _buildCell(8)],
              ),
              const SizedBox(height: 25),
              ElevatedButton(onPressed: ()=>restartGame()
              ,style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text('Restart',style: GoogleFonts.poppins(color: Colors.white,fontSize: 24),),)
            ],
          ),
        ],
      ),
    );
  }
}
