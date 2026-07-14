import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/state/app_controller.dart';
import '../domain/activity_model.dart';

class ActivityFormScreen extends StatefulWidget {
  final AppController appController;
  final Duration duration;
  final String imagePath;

  const ActivityFormScreen({
    super.key,
    required this.appController,
    required this.duration,
    required this.imagePath,
  });

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _titleController = TextEditingController();
  String _categoriaSelecionada = 'Musculação';

  final List<String> _categorias = [
    'Academia', 'Musculação', 'HIIT', 'Zumba', 'Judô', 
    'Vôlei', 'Futebol', 'Caminhada', 'Corrida', 'Natação'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: const Text('Detalhes da Atividade', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea( 
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.imagePath.startsWith('assets') || widget.imagePath.contains('mvp_photo')
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.white10,
                        child: const Icon(Icons.fitness_center, size: 64, color: Color(0xFFE17F28)),
                      )
                    : Image.file(
                        File(widget.imagePath), 
                        height: 200, 
                        width: double.infinity, 
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Título do Treino (ex: Treino de Perna)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE17F28))),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _categoriaSelecionada,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                ),
                items: _categorias.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _categoriaSelecionada = val!),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE17F28)),
                  onPressed: () {
                    final activity = ActivityModel(
                      type: '$_categoriaSelecionada: ${_titleController.text}',
                      duration: widget.duration,
                      timestamp: DateTime.now(),
                      photoPath: widget.imagePath,
                    );
                    widget.appController.addActivity(activity);
                    
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('SALVAR CHECK-IN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}