import 'package:flutter/material.dart';

Future<String> askModal(BuildContext context, String question) async {
  return await Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) {
        return AskMOdal(question: question);
      },
    ),
  );
}

class AskMOdal extends StatelessWidget {
  final String question;
  const AskMOdal({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Card(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(question),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    onPressed: () {
                      Navigator.pop(context, 'ok');
                    },
                    child: const Text('ok'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: () {
                      Navigator.pop(context, 'annuler');
                    },
                    child: const Text('annuler'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
