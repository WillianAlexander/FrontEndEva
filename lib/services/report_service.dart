import 'dart:io';
import 'package:http/http.dart' as http;

class ReportService {
  Future<http.StreamedResponse> saveToDatabase(
    File file,
    String usuario,
    String estado,
    DateTime periodo,
    DateTime fentrega,
  ) async {
    try {
      // Crear una solicitud multipart
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.0.128:3000/informes'),
      );

      // Agregar el archivo al cuerpo de la solicitud
      request.files.add(
        http.MultipartFile(
          'contenido', // Nombre del campo esperado por el backend
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.uri.pathSegments.last,
        ),
      );

      // Agregar otros datos al cuerpo de la solicitud
      request.fields['usuario'] = usuario;
      request.fields['estado'] = estado;
      request.fields['periodo'] = periodo.toIso8601String();
      request.fields['fentrega'] = fentrega.toIso8601String();

      // Enviar la solicitud
      final response = await request.send();
      return response; // Devolver la respuesta al método que lo llama
    } catch (e) {
      print('Error al enviar el archivo al backend: $e');
      rethrow; // Propagar el error para manejarlo en el método que lo llama
    }
  }
}
