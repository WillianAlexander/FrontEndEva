class Usuario {
  final String usuario;
  final String nombres;
  final String apellidos;
  final String identificacion;
  final String correo;
  final String? password;
  final int? rolId;
  final int? departamentoId;
  final bool activo;
  final DateTime? fdesde;
  final DateTime? fhasta;
  final int? version;

  Usuario({
    required this.usuario,
    required this.nombres,
    required this.apellidos,
    required this.identificacion,
    required this.correo,
    this.password,
    this.rolId,
    this.departamentoId,
    required this.activo,
    this.fdesde,
    this.fhasta,
    this.version,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuario: json['usuario'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      identificacion: json['identificacion'],
      correo: json['correo'],
      password: json['password'] ?? '',
      rolId: json['rol_id'],
      departamentoId: json['departamento_id'],
      activo: json['activo'],
      fdesde: DateTime.parse(json['fdesde']),
      fhasta: DateTime.parse(json['fhasta']),
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario,
      'nombres': nombres,
      'apellidos': apellidos,
      'identificacion': identificacion,
      'correo': correo,
      'password': password,
      'rol_id': rolId,
      'departamento_id': departamentoId,
      'activo': activo,
      'fdesde': fdesde?.toIso8601String(),
      'fhasta': fhasta?.toIso8601String(),
      'version': version,
    };
  }
}
