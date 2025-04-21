class Informe {
  final String usuarioEntrega;
  final String periodo;
  final DateTime fechaEntrega;
  final List<int>? contenido;
  final String estadoId;
  final DateTime? fdesde;
  final DateTime? fhasta;
  final int version;

  Informe({
    required this.usuarioEntrega,
    required this.periodo,
    required this.fechaEntrega,
    required this.estadoId,
    required this.fdesde,
    required this.fhasta,
    required this.version,
    required this.contenido,
  });

  factory Informe.fromJson(Map<String, dynamic> json) {
    return Informe(
      usuarioEntrega: json['usuario_entrega'],
      periodo: json['periodo'],
      fechaEntrega: DateTime.parse(json['fecha_entrega']),
      estadoId: json['estado_id'],
      fdesde: DateTime.parse(json['fdesde']),
      fhasta: DateTime.parse(json['fhasta']),
      version: json['version'],
      contenido: List<int>.from(json['contenido']['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_entrega': usuarioEntrega,
      'periodo': periodo,
      'fecha_entrega': fechaEntrega.toIso8601String(),
      'contenido': contenido,
      'estado_id': estadoId,
      'fdesde': fdesde?.toIso8601String(),
      'fhasta': fhasta?.toIso8601String(),
      'version': version,
    };
  }
}
