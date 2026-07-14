import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/auth_user/domain/user_model.dart';
import '../../features/activity/domain/activity_model.dart';

class AppController extends ChangeNotifier {
  UserModel? _currentUser;
  final List<ActivityModel> _activities = [];

  UserModel? get currentUser => _currentUser;
  List<ActivityModel> get activities => _activities;

  final Box _userBox = Hive.box('userBox');
  final Box _activityBox = Hive.box('activityBox');

  AppController() {
    _carregarDadosDoBanco();
  }

  void _carregarDadosDoBanco() {
    if (_userBox.containsKey('name')) {
      final Map<dynamic, dynamic>? rawProfile = _userBox.get('healthProfile');
      final Map<String, String> profile = {};
      if (rawProfile != null) {
        rawProfile.forEach((key, value) {
          profile[key.toString()] = value.toString();
        });
      }

      _currentUser = UserModel(
        name: _userBox.get('name'),
        cpf: _userBox.get('cpf') ?? '', 
        secretaria: _userBox.get('secretaria'),
        setor: _userBox.get('setor'),
        healthProfile: profile,
      );
    } 

    final List? atividadesSalvas = _activityBox.get('lista');
    if (atividadesSalvas != null) {
      for (var item in atividadesSalvas) {
        if (item is Map) {
          _activities.add(
            ActivityModel(
              type: item['type'] ?? '',
              duration: Duration(seconds: item['durationSeconds'] ?? 0),
              timestamp: DateTime.parse(
                item['timestamp'] ?? DateTime.now().toIso8601String(),
              ),
              photoPath: item['photoPath'] ?? '',
            ),
          );
        }
      }
    }

    notifyListeners();
  }

  int get totalPoints =>
      _activities.length * 100; 
  void loginUser(UserModel user) {
    _currentUser = user;

    _userBox.put('name', user.name);
    _userBox.put('cpf', user.cpf);
    _userBox.put('secretaria', user.secretaria);
    _userBox.put('setor', user.setor);
    _userBox.put('healthProfile', user.healthProfile);

    notifyListeners();
  }

  void addActivity(ActivityModel activity) {
    _activities.add(activity);

    final listaParaSalvar = _activities.map((atv) {
      return {
        'type': atv.type,
        'durationSeconds': atv.duration.inSeconds,
        'timestamp': atv.timestamp.toIso8601String(),
        'photoPath': atv.photoPath,
      };
    }).toList();

    _activityBox.put('lista', listaParaSalvar);

    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _activities.clear();
    _userBox.clear();
    _activityBox.clear();
    notifyListeners();
  }
}
