// service_health_info.dart

import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/health_info.dart';
import 'package:frontend/services/api_constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/services/user_storage.dart';

class HealthInfoService {
  static Future<void> uploadHealthInfo(HealthInfo info) async {
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('jwt_token');
    final token = await UserStorage.loadToken();

    if (token == null) {
      throw Exception("❌ JWT 토큰이 저장되어 있지 않습니다. 로그인을 먼저 수행해야 합니다.");
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/api/health/health_info');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(info.toJson()),
    );

    log('📡 요청 URL: $url');
    log('📤 Authorization: Bearer $token');
    log('📦 전송 데이터: ${jsonEncode(info.toJson())}');
    log('📥 응답 statusCode: ${response.statusCode}');
    log('📥 응답 body: ${response.body}');

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      final msg = body['message'] ?? '서버 오류';
      throw Exception("건강정보 저장 실패: $msg");
    }
  }
}
