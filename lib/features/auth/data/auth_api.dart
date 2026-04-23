import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/services/api_client.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(apiClientProvider));
});

class AuthApi {
  final ApiClient _client;
  AuthApi(this._client);

  Future<ApiResponse<RequestOtpResult>> requestOtp({
    required String phone,
    required String purpose, // 'LOGIN' or 'REGISTER'
  }) {
    return _client.post<RequestOtpResult>(
      '/api/v3/auth/request-otp',
      body: {'phone': phone, 'purpose': purpose},
      fromJson: RequestOtpResult.fromJson,
    );
  }

  Future<ApiResponse<VerifyOtpResult>> verifyOtp({
    required String phone,
    required String otp,
    required String purpose,
  }) {
    return _client.post<VerifyOtpResult>(
      '/api/v3/auth/verify-otp',
      body: {'phone': phone, 'otp': otp, 'purpose': purpose},
      fromJson: VerifyOtpResult.fromJson,
    );
  }

  Future<ApiResponse<RegisterResult>> register({
    required String registrationToken,
    required String fullName,
    required int storeId,
  }) {
    return _client.post<RegisterResult>(
      '/api/v3/auth/register',
      body: {'registration_token': registrationToken, 'full_name': fullName, 'store_id': storeId},
      fromJson: RegisterResult.fromJson,
    );
  }

  Future<ApiResponse<List<StoreDto>>> listStores() {
    return _client.get<List<StoreDto>>(
      '/api/v3/auth/stores',
      fromJson: (j) {
        final arr = (j['stores'] as List?) ?? const [];
        return arr.map((e) => StoreDto.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> session() {
    return _client.get('/api/v3/auth/session', requireAuth: true);
  }

  Future<ApiResponse<Map<String, dynamic>>> logout() {
    return _client.post('/api/v3/auth/logout', requireAuth: true);
  }

  Future<ApiResponse<LinkLegacyResult>> linkLegacy({String? membershipNumber, String? legacyName}) {
    return _client.post<LinkLegacyResult>(
      '/api/v3/me/link-legacy',
      body: {
        if (membershipNumber != null && membershipNumber.isNotEmpty) 'membership_number': membershipNumber,
        if (legacyName != null && legacyName.isNotEmpty) 'legacy_name': legacyName,
      },
      requireAuth: true,
      fromJson: LinkLegacyResult.fromJson,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> createStoreCustomer(int storeId) {
    return _client.post('/api/v3/me/create-customer', body: {'store_id': storeId}, requireAuth: true);
  }

  Future<ApiResponse<LinkLegacyResult>> confirmLinkLegacy(int customerId) {
    return _client.post<LinkLegacyResult>(
      '/api/v3/me/link-legacy/confirm',
      body: {'customer_id': customerId},
      requireAuth: true,
      fromJson: LinkLegacyResult.fromJson,
    );
  }

  Future<void> saveSession(String token) => _client.setSessionToken(token);
  Future<void> clearSession() => _client.clearSessionToken();
}

// ----- DTOs -----

class RequestOtpResult {
  final String transactionId;
  final String refNo;
  final DateTime expiresAt;
  final String? otpDebug;

  RequestOtpResult({required this.transactionId, required this.refNo, required this.expiresAt, this.otpDebug});

  factory RequestOtpResult.fromJson(Map<String, dynamic> j) => RequestOtpResult(
    transactionId: j['transaction_id'] as String? ?? '',
    refNo: j['ref_no'] as String? ?? '',
    expiresAt: DateTime.parse(j['expires_at'] as String),
    otpDebug: j['otp_debug'] as String?,
  );
}

class CustomerUserDto {
  final int id;
  final String phone;
  final String? fullName;

  CustomerUserDto({required this.id, required this.phone, this.fullName});

  factory CustomerUserDto.fromJson(Map<String, dynamic> j) =>
      CustomerUserDto(id: (j['id'] as num).toInt(), phone: j['phone'] as String, fullName: j['full_name'] as String?);
}

class VerifyOtpResult {
  /// 'LOGGED_IN' or 'NEEDS_REGISTRATION'
  final String status;
  final String? sessionToken;
  final DateTime? expiresAt;
  final CustomerUserDto? user;

  final String? registrationToken;
  final DateTime? registrationTokenExpires;

  VerifyOtpResult({
    required this.status,
    this.sessionToken,
    this.expiresAt,
    this.user,
    this.registrationToken,
    this.registrationTokenExpires,
  });

  factory VerifyOtpResult.fromJson(Map<String, dynamic> j) => VerifyOtpResult(
    status: j['status'] as String,
    sessionToken: j['session_token'] as String?,
    expiresAt: j['expires_at'] != null ? DateTime.parse(j['expires_at']) : null,
    user: j['user'] != null ? CustomerUserDto.fromJson(j['user']) : null,
    registrationToken: j['registration_token'] as String?,
    registrationTokenExpires: j['registration_token_expires'] != null
        ? DateTime.parse(j['registration_token_expires'])
        : null,
  );
}

class RegisterResult {
  /// 'CREATED' | 'NEEDS_MIGRATION_DECISION'
  final String status;
  final String? sessionToken;
  final DateTime? expiresAt;
  final CustomerUserDto? user;
  final int? storeId;
  final List<LinkableCustomerDto> candidates;

  RegisterResult({
    required this.status,
    this.sessionToken,
    this.expiresAt,
    this.user,
    this.storeId,
    this.candidates = const [],
  });

  factory RegisterResult.fromJson(Map<String, dynamic> j) => RegisterResult(
    status: j['status'] as String,
    sessionToken: j['session_token'] as String?,
    expiresAt: j['expires_at'] != null ? DateTime.parse(j['expires_at']) : null,
    user: j['user'] != null ? CustomerUserDto.fromJson(j['user']) : null,
    storeId: (j['store_id'] as num?)?.toInt(),
    candidates: ((j['candidates'] as List?) ?? const [])
        .map((e) => LinkableCustomerDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class StoreDto {
  final int id;
  final String storeName;

  StoreDto({required this.id, required this.storeName});

  factory StoreDto.fromJson(Map<String, dynamic> j) =>
      StoreDto(id: (j['id'] as num).toInt(), storeName: j['store_name'] as String? ?? '');
}

class LinkableCustomerDto {
  final int id;
  final String name;
  final String last4;
  final String? membershipNumber;
  final int totalPoints;

  LinkableCustomerDto({
    required this.id,
    required this.name,
    required this.last4,
    this.membershipNumber,
    required this.totalPoints,
  });

  factory LinkableCustomerDto.fromJson(Map<String, dynamic> j) => LinkableCustomerDto(
    id: (j['id'] as num).toInt(),
    name: j['name'] as String? ?? '',
    last4: j['last4'] as String? ?? '',
    membershipNumber: j['membership_number'] as String?,
    totalPoints: (j['total_points'] as num?)?.toInt() ?? 0,
  );
}

class LinkLegacyResult {
  /// 'LINKED' | 'CANDIDATES' | 'NOT_FOUND'
  final String status;
  final int? linkedCustomerId;
  final int totalPoints;
  final List<LinkableCustomerDto> candidates;
  final String? message;

  LinkLegacyResult({
    required this.status,
    this.linkedCustomerId,
    this.totalPoints = 0,
    this.candidates = const [],
    this.message,
  });

  factory LinkLegacyResult.fromJson(Map<String, dynamic> j) => LinkLegacyResult(
    status: j['status'] as String,
    linkedCustomerId: (j['linked_customer_id'] as num?)?.toInt(),
    totalPoints: (j['total_points'] as num?)?.toInt() ?? 0,
    candidates:
        (j['candidates'] as List?)?.map((e) => LinkableCustomerDto.fromJson(e as Map<String, dynamic>)).toList() ??
        const [],
    message: j['message'] as String?,
  );
}
