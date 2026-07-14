class UserModel {
  final String name;
  final String cpf;
  final String secretaria;
  final String setor;
  final Map<String, String> healthProfile;

  const UserModel({
    required this.name,
    required this.cpf, 
    required this.secretaria,
    required this.setor,
    required this.healthProfile,
  });

  UserModel copyWith({
    String? name,
    String? cpf, 
    String? secretaria,
    String? setor,
    Map<String, String>? healthProfile,
  }) {
    return UserModel(
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      secretaria: secretaria ?? this.secretaria,
      setor: setor ?? this.setor,
      healthProfile: healthProfile ?? this.healthProfile,
    );
  }
}