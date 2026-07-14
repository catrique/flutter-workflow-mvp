import 'package:flutter/material.dart';
import 'package:app_cresst/core/theme/app_colors.dart';
import 'package:app_cresst/core/state/app_controller.dart';
import 'package:app_cresst/features/activity/domain/activity_model.dart';
import 'package:app_cresst/features/auth_user/domain/user_model.dart'; 
import '../../activity/presentation/timer_screen.dart'; 
import 'dart:io'; 

class DashboardScreen extends StatefulWidget {
  final AppController appController;

  const DashboardScreen({super.key, required this.appController});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isCalendarExpanded = false;
  int _activeTab = 0;
  final _scaffoldKey =
      GlobalKey<
        ScaffoldState
      >(); 

  final _nameController = TextEditingController();
  String _selectedSecretaria = 'SEMUSA';
  String _selectedSetor = 'CRESST';

  final List<String> _secretarias = ['SEMUSA', 'SEPLAG', 'SEMED', 'SEGOV'];
  final List<String> _setores = [
    'CRESST',
    'ESF Vila Nova',
    'CMEI Centro',
    'Centro Administrativo',
  ];

  final List<Map<String, dynamic>> _mockFeed = [
    {
      'nome': 'Ana Silva',
      'secretaria': 'SEMUSA',
      'atividade': 'Zumba',
      'tempo': '45 min',
      'distancia': '--',
      'hora': '07:30',
      'genero': 'F',
    },
    {
      'nome': 'Carlos Souza',
      'secretaria': 'SEPLAG',
      'atividade': 'Corrida',
      'tempo': '35 min',
      'distancia': '5.2 km',
      'hora': '08:15',
      'genero': 'M',
    },
    {
      'nome': 'Mariana Reis',
      'secretaria': 'SEMED',
      'atividade': 'Funcional',
      'tempo': '50 min',
      'distancia': '--',
      'hora': '09:00',
      'genero': 'F',
    },
    {
      'nome': 'Roberto Lima',
      'secretaria': 'SEMUSA',
      'atividade': 'Ciclismo',
      'tempo': '60 min',
      'distancia': '18 km',
      'hora': '10:10',
      'genero': 'M',
    },
    {
      'nome': 'Patricia Dias',
      'secretaria': 'SEGOV',
      'atividade': 'Musculação',
      'tempo': '40 min',
      'distancia': '--',
      'hora': '11:20',
      'genero': 'F',
    },
    {
      'nome': 'Ricardo Alves',
      'secretaria': 'SEPLAG',
      'atividade': 'Caminhada',
      'tempo': '30 min',
      'distancia': '3.1 km',
      'hora': '12:05',
      'genero': 'M',
    },
    {
      'nome': 'Juliana Costa',
      'secretaria': 'SEMED',
      'atividade': 'Yoga',
      'tempo': '45 min',
      'distancia': '--',
      'hora': '14:15',
      'genero': 'F',
    },
    {
      'nome': 'Fernando Oliveira',
      'secretaria': 'SEMUSA',
      'atividade': 'Futebol',
      'tempo': '90 min',
      'distancia': '--',
      'hora': '16:00',
      'genero': 'M',
    },
    {
      'nome': 'Camila Santos',
      'secretaria': 'SEGOV',
      'atividade': 'Natação',
      'tempo': '45 min',
      'distancia': '1.5 km',
      'hora': '17:15',
      'genero': 'F',
    },
    {
      'nome': 'Lucas Martins',
      'secretaria': 'SEPLAG',
      'atividade': 'Crossfit',
      'tempo': '50 min',
      'distancia': '--',
      'hora': '18:00',
      'genero': 'M',
    },
    {
      'nome': 'Amanda Ribeiro',
      'secretaria': 'SEMED',
      'atividade': 'Pilates',
      'tempo': '50 min',
      'distancia': '--',
      'hora': '18:30',
      'genero': 'F',
    },
    {
      'nome': 'Bruno Carvalho',
      'secretaria': 'SEMUSA',
      'atividade': 'Corrida',
      'tempo': '42 min',
      'distancia': '6.0 km',
      'hora': '19:10',
      'genero': 'M',
    },
    {
      'nome': 'Beatriz Rocha',
      'secretaria': 'SEGOV',
      'atividade': 'Judô',
      'tempo': '60 min',
      'distancia': '--',
      'hora': '19:45',
      'genero': 'F',
    },
    {
      'nome': 'Tiago Mendes',
      'secretaria': 'SEPLAG',
      'atividade': 'Spinning',
      'tempo': '45 min',
      'distancia': '--',
      'hora': '20:15',
      'genero': 'M',
    },
    {
      'nome': 'Gabriela Neves',
      'secretaria': 'SEMED',
      'atividade': 'Dança',
      'tempo': '50 min',
      'distancia': '--',
      'hora': '20:45',
      'genero': 'F',
    },
  ];

  final List<Map<String, String>> _mockUserHistory = [
    {
      'data': 'Ontem',
      'tipo': 'Musculação',
      'tempo': '45 min',
      'pontos': '+100 pts',
    },
    {
      'data': '22 Jun',
      'tipo': 'Corrida',
      'tempo': '30 min (4.5 km)',
      'pontos': '+100 pts',
    },
    {
      'data': '19 Jun',
      'tipo': 'Funcional',
      'tempo': '50 min',
      'pontos': '+100 pts',
    },
    {
      'data': '18 Jun',
      'tipo': 'Zumba',
      'tempo': '40 min',
      'pontos': '+100 pts',
    },
  ];

  @override
  void initState() {
    super.initState();
    final user = widget.appController.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _selectedSecretaria = _secretarias.contains(user.secretaria)
          ? user.secretaria
          : _secretarias.first;
      _selectedSetor = _setores.contains(user.setor)
          ? user.setor
          : _setores.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _atualizarPerfil() {
    final currentUser = widget.appController.currentUser;
    if (currentUser != null && _nameController.text.trim().isNotEmpty) {
      final updatedUser = UserModel(
        name: _nameController.text.trim(),
        cpf: currentUser.cpf, 
        secretaria: _selectedSecretaria,
        setor: _selectedSetor,
        healthProfile: currentUser.healthProfile,
      );

      widget.appController.loginUser(
        updatedUser,
      ); 
      setState(() {}); 
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.sucessoVerde,
          content: Text(
            'Perfil atualizado com sucesso!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  void _mostrarStory(BuildContext context, Map<String, dynamic> dados) {
    final String imagePath =
        dados['isReal'] == true &&
            dados['photoPath'] != null &&
            dados['photoPath'].isNotEmpty
        ? dados['photoPath']
        : (dados['genero'] == 'M'
              ? 'assets/images/foto_mock_1.png'
              : 'assets/images/foto_mock_2.png');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: imagePath.startsWith('assets/')
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.cardEscuro,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                size: 80,
                                color: AppColors.primariaLaranja,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Imagem não encontrada nos assets.',
                                style: TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Image.file(
                      File(
                        imagePath,
                      ), 
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.cardEscuro,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                size: 80,
                                color: AppColors.primariaLaranja,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Erro ao carregar a foto tirada.',
                                style: TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[800]!, Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primariaLaranja,
                      child: Text(
                        dados['nome'][0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dados['nome'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${dados['secretaria']} • Hoje às ${dados['hora']}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.grey[900]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricItem(
                      Icons.fitness_center,
                      'Atividade',
                      dados['atividade'],
                    ),
                    _buildMetricItem(Icons.timer, 'Duração', dados['tempo']),
                    if (dados['distancia'] != '--')
                      _buildMetricItem(
                        Icons.straighten,
                        'Distância',
                        dados['distancia'],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMetricItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primariaLaranja, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textoCinzaClaro,
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.appController.currentUser;
    final userActivities = widget.appController.activities;
    final String primeiraLetra = user?.name.isNotEmpty == true
        ? user!.name[0]
        : 'S';

    return Scaffold(
      key: _scaffoldKey, 
      backgroundColor: AppColors.fundoEscuro,

      drawer: Drawer(
        backgroundColor: AppColors.fundoEscuro,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Meu Perfil',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textoCinzaClaro,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  'Nome Completo',
                  style: TextStyle(
                    color: AppColors.textoCinzaClaro,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardEscuro,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.primariaLaranja,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Secretaria',
                  style: TextStyle(
                    color: AppColors.textoCinzaClaro,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedSecretaria,
                  dropdownColor: AppColors.cardEscuro,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardEscuro,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white10),
                    ),
                  ),
                  items: _secretarias
                      .map(
                        (sec) => DropdownMenuItem(value: sec, child: Text(sec)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedSecretaria = value!),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Setor / Unidade',
                  style: TextStyle(
                    color: AppColors.textoCinzaClaro,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedSetor,
                  dropdownColor: AppColors.cardEscuro,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardEscuro,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white10),
                    ),
                  ),
                  items: _setores
                      .map(
                        (setor) =>
                            DropdownMenuItem(value: setor, child: Text(setor)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _selectedSetor = value!),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _atualizarPerfil,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primariaLaranja,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Salvar Alterações',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      appBar: AppBar(
        backgroundColor: AppColors.cardEscuro,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: CircleAvatar(
              backgroundColor: AppColors.primariaLaranja,
              radius: 18,
              child: Text(
                primeiraLetra,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            onPressed: () => _scaffoldKey.currentState
                ?.openDrawer(), 
          ),
        ),
        title: Text(
          'Olá, ${user?.name.split(' ').first ?? 'Servidor'} 👋',
          style: const TextStyle(
            color: AppColors.textoBranco,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primariaLaranja.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primariaLaranja, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: AppColors.primariaLaranja,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.appController.totalPoints + 400} pts',
                  style: const TextStyle(
                    color: AppColors.primariaLaranja,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () =>
                  setState(() => _isCalendarExpanded = !_isCalendarExpanded),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardEscuro,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: AppColors.primariaLaranja,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Frequência Semanal',
                              style: TextStyle(
                                color: AppColors.textoBranco,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          _isCalendarExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: AppColors.textoCinzaClaro,
                        ),
                      ],
                    ),
                    if (_isCalendarExpanded) ...[
                      const Divider(color: Colors.white10, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            [
                              'Seg',
                              'Ter',
                              'Qua',
                              'Qui',
                              'Sex',
                              'Sáb',
                              'Dom',
                            ].map((dia) {
                              bool ativo =
                                  dia == 'Seg' || dia == 'Ter' || dia == 'Qua';
                              return Column(
                                children: [
                                  Text(
                                    dia,
                                    style: const TextStyle(
                                      color: AppColors.textoCinzaClaro,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: ativo
                                        ? AppColors.primariaLaranja
                                        : Colors.white10,
                                    child: Icon(
                                      ativo ? Icons.check : Icons.close,
                                      size: 14,
                                      color: ativo
                                          ? Colors.white
                                          : AppColors.textoCinzaClaro,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.cardEscuro,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTabItem(0, 'Hoje'),
                  _buildTabItem(1, 'Histórico'),
                  _buildTabItem(2, 'Progresso'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: IndexedStack(
                index: _activeTab,
                children: [
                  _buildFeedTab(),
                  _buildHistoryTab(userActivities),
                  _buildProgressTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primariaLaranja,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TimerScreen(appController: widget.appController),
            ),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    bool selected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primariaLaranja : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textoCinzaClaro,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedTab() {
    final user = widget.appController.currentUser;
    final userActivities = widget.appController.activities;

    final List<Map<String, dynamic>> treinosReais = userActivities.map((act) {
      return {
        'nome': user?.name.isNotEmpty == true ? user!.name : 'Servidor',
        'secretaria': user?.secretaria ?? 'SEMUSA',
        'atividade': act.type,
        'tempo': '${act.duration.inMinutes} min',
        'distancia': '--',
        'hora': 'Agora mesmo',
        'genero': 'M',
        'photoPath':
            act.photoPath, 
        'isReal': true,
      };
    }).toList();

    final listaCompletaFeed = [...treinosReais.reversed, ..._mockFeed];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: listaCompletaFeed.length,
      itemBuilder: (context, index) {
        final item = listaCompletaFeed[index];
        return Card(
          color: AppColors.cardEscuro,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: item['isReal'] == true
                  ? AppColors.primariaLaranja
                  : Colors.white10,
              width: item['isReal'] == true ? 1.5 : 1.0,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: GestureDetector(
              onTap: () => _mostrarStory(context, item),
              child: Container(
                padding: const EdgeInsets.all(2.5),
                decoration: const BoxDecoration(
                  color: AppColors.primariaLaranja,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.fundoEscuro,
                  child: Text(
                    item['nome'][0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Text(
                  item['isReal'] == true
                      ? '${item['nome']} (Você)'
                      : item['nome'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '• ${item['hora']}',
                  style: const TextStyle(
                    color: AppColors.textoCinzaClaro,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              '${item['secretaria']} completou ${item['atividade']} (${item['tempo']})',
              style: const TextStyle(
                color: AppColors.textoCinzaClaro,
                fontSize: 13,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.primariaLaranja,
            ),
            onTap: () => _mostrarStory(context, item),
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab(List<ActivityModel>? realActivities) {
    final list = realActivities ?? [];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (list.isNotEmpty) ...[
          const Text(
            'Atividades Recentes',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...list.reversed.indexed.map((record) {
            final indexItem = record.$1;
            final act = record.$2;
            final realIndex = list.length - 1 - indexItem;

            return Card(
              color: AppColors.cardEscuro,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: AppColors.sucessoVerde,
                ),
                title: Text(
                  act.type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Hoje • ${act.duration.inMinutes} min de treino',
                  style: const TextStyle(color: AppColors.textoCinzaClaro),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '+100 pts  ',
                      style: TextStyle(
                        color: AppColors.primariaLaranja,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: AppColors.textoCinzaClaro,
                        size: 20,
                      ),
                      onPressed: () {
                        final editController = TextEditingController(
                          text: act.type,
                        );
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.cardEscuro,
                            title: const Text(
                              'Editar Atividade',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: TextField(
                              controller: editController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Nome do Treino',
                                labelStyle: TextStyle(
                                  color: AppColors.textoCinzaClaro,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (editController.text.trim().isNotEmpty) {
                                    setState(() {
                                      widget
                                          .appController
                                          .activities[realIndex] = ActivityModel(
                                        type: editController.text.trim(),
                                        duration: act.duration,
                                        timestamp: act
                                            .timestamp, 
                                        photoPath: act
                                            .photoPath, 
                                        observations: act.observations,
                                      );
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text(
                                  'Salvar',
                                  style: TextStyle(
                                    color: AppColors.primariaLaranja,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
        const Text(
          'Histórico Anterior',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ..._mockUserHistory.map(
          (item) => Card(
            color: AppColors.cardEscuro,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(
                Icons.history,
                color: AppColors.primariaLaranja,
              ),
              title: Text(
                item['tipo']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${item['data']} • ${item['tempo']}',
                style: const TextStyle(color: AppColors.textoCinzaClaro),
              ),
              trailing: Text(
                item['pontos']!,
                style: const TextStyle(
                  color: AppColors.primariaLaranja,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardEscuro,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumo de Junho',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '500',
                          style: TextStyle(
                            color: AppColors.primariaLaranja,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Pontos Totais',
                          style: TextStyle(
                            color: AppColors.textoCinzaClaro,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Treinos no Mês',
                          style: TextStyle(
                            color: AppColors.textoCinzaClaro,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '185m',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Minutos Ativos',
                          style: TextStyle(
                            color: AppColors.textoCinzaClaro,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Engajamento por Secretaria (Média)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildProgressBarMock('SEMUSA (Saúde)', 0.85, '85% ativos'),
          _buildProgressBarMock('SEMED (Educação)', 0.62, '62% ativos'),
          _buildProgressBarMock('SEPLAG (Planejamento)', 0.45, '45% ativos'),
        ],
      ),
    );
  }

  Widget _buildProgressBarMock(String label, double percent, String trailing) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textoCinzaClaro,
                  fontSize: 13,
                ),
              ),
              Text(
                trailing,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.white10,
            color: AppColors.primariaLaranja,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
