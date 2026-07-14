import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart'; 
import '../../../../core/state/app_controller.dart';
import '../domain/user_model.dart';
import '../../points/presentation/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final AppController appController;

  const OnboardingScreen({super.key, required this.appController});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  
  String _selectedSecretaria = 'SEMUSA';
  String _selectedSetor = 'CRESST';
  
  String _exercicioFrequencia = 'Não pratico';
  String _historicoSaude = 'Não';

  final List<String> _secretarias = ['SEMUSA', 'SEPLAG', 'SEMED', 'SEGOV'];
  final List<String> _setores = ['CRESST', 'ESF Vila Nova', 'CMEI Centro', 'Centro Administrativo'];

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  void _salvarCadastro() {
    if (_formKey.currentState!.validate()) {
      final Map<String, String> respostasQuestionario = {
        'frequencia_exercicio': _exercicioFrequencia,
        'restricao_medica': _historicoSaude,
      };

      final newUser = UserModel(
        name: _nameController.text,
        cpf: _cpfController.text, 
        secretaria: _selectedSecretaria,
        setor: _selectedSetor,
        healthProfile: respostasQuestionario,
      );

      widget.appController.loginUser(newUser); 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(appController: widget.appController),
        ),
      );
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textoCinzaClaro),
      prefixIcon: Icon(icon, color: AppColors.primariaLaranja),
      filled: true,
      fillColor: AppColors.cardEscuro,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primariaLaranja, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.terciariaVermelho),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.terciariaVermelho, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoEscuro, 
      body: SafeArea( 
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                RichText(
                  text: const TextSpan(
                    text: 'Conecta ',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textoBranco),
                    children: [
                      TextSpan(
                        text: 'CRESST',
                        style: TextStyle(color: AppColors.primariaLaranja),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Preencha seus dados institucionais de Divinópolis para começar a pontuar.',
                  style: TextStyle(color: AppColors.textoCinzaClaro, fontSize: 14),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: AppColors.textoBranco),
                  decoration: _buildInputDecoration('Nome Completo', Icons.person),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Insira seu nome completo';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textoBranco),
                  decoration: _buildInputDecoration('CPF (Apenas números)', Icons.badge),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Insira seu CPF';
                    if (value.trim().length < 11) return 'CPF inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: _selectedSecretaria,
                  dropdownColor: AppColors.cardEscuro,
                  style: const TextStyle(color: AppColors.textoBranco),
                  decoration: _buildInputDecoration('Secretaria', Icons.business),
                  items: _secretarias.map((sec) => DropdownMenuItem(value: sec, child: Text(sec))).toList(),
                  onChanged: (value) => setState(() => _selectedSecretaria = value!),
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: _selectedSetor,
                  dropdownColor: AppColors.cardEscuro,
                  style: const TextStyle(color: AppColors.textoBranco),
                  decoration: _buildInputDecoration('Setor / Unidade', Icons.location_on),
                  items: _setores.map((setor) => DropdownMenuItem(value: setor, child: Text(setor))).toList(),
                  onChanged: (value) => setState(() => _selectedSetor = value!),
                ),
                const SizedBox(height: 36),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardEscuro,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.favorite, color: AppColors.terciariaVermelho),
                          const SizedBox(width: 8),
                          const Text(
                            'Perfil de Saúde Inicial',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textoBranco),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white10, height: 24),
                      
                      const Text('Frequência de atividade física:', style: TextStyle(color: AppColors.textoCinzaClaro)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _exercicioFrequencia,
                        dropdownColor: AppColors.cardEscuro,
                        style: const TextStyle(color: AppColors.textoBranco),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                        items: ['Não pratico', '1 a 2 vezes por semana', '3 ou mais vezes por semana']
                            .map((opcao) => DropdownMenuItem(value: opcao, child: Text(opcao))).toList(),
                        onChanged: (value) => setState(() => _exercicioFrequencia = value!),
                      ),
                      const SizedBox(height: 20),

                      const Text('Restrição médica ou histórico de lesões?', style: TextStyle(color: AppColors.textoCinzaClaro)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _historicoSaude,
                        dropdownColor: AppColors.cardEscuro,
                        style: const TextStyle(color: AppColors.textoBranco),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                        items: ['Não', 'Sim, mas leve', 'Sim, restrição severa']
                            .map((opcao) => DropdownMenuItem(value: opcao, child: Text(opcao))).toList(),
                        onChanged: (value) => setState(() => _historicoSaude = value!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _salvarCadastro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primariaLaranja,
                      foregroundColor: AppColors.textoBranco,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text('Concluir e Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}