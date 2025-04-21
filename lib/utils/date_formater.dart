import 'package:intl/intl.dart';

class DateFormatter {
  /// Formatea una fecha según el formato proporcionado.
  /// Si no se proporciona un formato, usa "yyyy-MM-dd" por defecto.
  static String format(DateTime? date, {String format = "yyyy-MM-dd"}) {
    if (date == null) {
      return "Fecha no válida"; // Manejo de fechas nulas
    }
    return DateFormat(format).format(date);
  }

  /// Convierte una cadena de texto a un objeto DateTime según el formato proporcionado.
  /// Si no se proporciona un formato, usa "yyyy-MM-dd" por defecto.
  static DateTime? parse(String? dateString, {String format = "yyyy-MM-dd"}) {
    if (dateString == null || dateString.isEmpty) {
      return null; // Manejo de cadenas nulas o vacías
    }
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      print("Error al parsear la fecha: $e");
      return null;
    }
  }
}
