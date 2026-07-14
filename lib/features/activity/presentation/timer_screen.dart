import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/state/app_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'activity_form_screen.dart';

class TimerScreen extends StatefulWidget {
  final AppController appController;

  const TimerScreen({super.key, required this.appController});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const Color laranjaPrefeitura = Color(0xFFE17F28);
  static const Color fundoEscuro = Color(0xFF111111);
  static const Color cardEscuro = Color(0xFF1E1E1E);

  Timer? _timer;
  int _segundosPassados = 0; 
  bool _estaRodando = false;
  String _tipoAtividade = 'Musculação';

  final List<String> _atividades = [
    'Musculação',
    'Corrida',
    'Caminhada',
    'Yoga',
    'Ciclismo',
  ];

  void _alternarCronometro() {
    if (_estaRodando) {
      _timer?.cancel();
      setState(() => _estaRodando = false);
    } else {
      setState(() => _estaRodando = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _segundosPassados++);
      });
    }
  }

  String _formatarTempo(int segundosTotais) {
    final minutos = (segundosTotais % 3600) ~/ 60;
    final segundos = segundosTotais % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

  void _finalizarAtividade() {
    final bool ehInvalido = _segundosPassados < 30;

    if (ehInvalido) {
      _timer?.cancel();
      setState(() => _estaRodando = false);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: cardEscuro,
          title: const Text(
            'Tempo Insuficiente',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'A atividade física deve durar pelo menos 30 minutos para ser computada e pontuada pelo CRESST.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Voltar ao Treino',
                style: TextStyle(color: laranjaPrefeitura),
              ),
            ),
          ],
        ),
      );
      return;
    }
    _tirarFotoEEditar();
  }

  Future<void> _tirarFotoEEditar() async {
    _timer?.cancel();
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivityFormScreen(
            appController: widget.appController,
            duration: Duration(seconds: _segundosPassados),
            imagePath: photo.path,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoEscuro,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Novo Treino', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: _tipoAtividade,
              dropdownColor: cardEscuro,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Selecione o Exercício',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: laranjaPrefeitura),
                ),
              ),
              items: _atividades.map((atv) {
                return DropdownMenuItem(value: atv, child: Text(atv));
              }).toList(),
              onChanged: (value) => setState(() => _tipoAtividade = value!),
            ),
            const Spacer(),

            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _estaRodando ? laranjaPrefeitura : Colors.white24,
                  width: 6,
                ),
              ),
              child: Center(
                child: Text(
                  _formatarTempo(_segundosPassados),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _segundosPassados < 30
                  ? 'Mínimo: 30s para testar (Equivale a 30m)'
                  : 'Meta atingida! Pronto para encerrar.',
              style: TextStyle(
                color: _segundosPassados < 30 ? Colors.white60 : Colors.green,
                fontSize: 12,
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _alternarCronometro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _estaRodando
                            ? Colors.amber.shade700
                            : laranjaPrefeitura,
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(_estaRodando ? Icons.pause : Icons.play_arrow),
                      label: Text(_estaRodando ? 'Pausar' : 'Iniciar Treino'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _segundosPassados > 0
                        ? _finalizarAtividade
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.white12,
                    ),
                    child: const Icon(Icons.stop),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
