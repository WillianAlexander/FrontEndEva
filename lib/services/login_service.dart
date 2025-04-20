import 'dart:convert';

class LoginService {
  Map<String, dynamic> decodeToken(String token) {
    final parts = token.split('.');
    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      print('Decoded Token Payload: $payload');
      return jsonDecode(payload);
    } catch (e) {
      throw FormatException('Unable to decode token $e');
    }
  }

  // void calculateExpiresIn(String token) {
  //   final parts = token.split('.');
  //   if (parts.length == 3) {
  //     final payload = utf8.decode(
  //       base64Url.decode(base64Url.normalize(parts[1])),
  //     );
  //     final Map<String, dynamic> decodedPayload = jsonDecode(payload);

  //     if (decodedPayload.containsKey('exp')) {
  //       final exp = decodedPayload['exp'];
  //       final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  //       final expiresIn = exp - currentTime;

  //       print('Token expires in: $expiresIn seconds');
  //     } else {
  //       print('No exp field found in token');
  //     }
  //   } else {
  //     print('Invalid Token');
  //   }
  // }
}
