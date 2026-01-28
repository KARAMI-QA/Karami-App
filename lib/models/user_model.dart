class User {
  final String id;
  final String? name;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? image;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final String deviceType;
  final int firstTimePasswordChange;
  final String isVerified;
  final int isEmployee;
  final int isSuper;
  final String status;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    this.name,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.phone,
    this.image,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    required this.deviceType,
    required this.firstTimePasswordChange,
    required this.isVerified,
    required this.isEmployee,
    required this.isSuper,
    required this.status,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      phoneVerifiedAt: json['phone_verified_at'] != null
          ? DateTime.parse(json['phone_verified_at'])
          : null,
      deviceType: json['device_type'] ?? 'Web',
      firstTimePasswordChange: json['first_time_password_change'] ?? 0,
      isVerified: json['is_verified'] ?? 'Not Verified',
      isEmployee: json['is_employee'] ?? 0,
      isSuper: json['is_super'] ?? 0,
      status: json['status'] ?? 'Active',
      createdBy: json['created_by']?.toString(),
      updatedBy: json['updated_by']?.toString(),
      deletedBy: json['deleted_by']?.toString(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'image': image,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'phone_verified_at': phoneVerifiedAt?.toIso8601String(),
      'device_type': deviceType,
      'first_time_password_change': firstTimePasswordChange,
      'is_verified': isVerified,
      'is_employee': isEmployee,
      'is_super': isSuper,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get fullName {
    if (name != null && name!.isNotEmpty) return name!;

    final parts = [
      if (firstName != null && firstName!.isNotEmpty) firstName,
      if (middleName != null && middleName!.isNotEmpty) middleName,
      if (lastName != null && lastName!.isNotEmpty) lastName,
    ];

    return parts.join(' ');
  }

  bool get isAdmin => isSuper == 1;
  bool get isEmailVerified => emailVerifiedAt != null;
  bool get isPhoneVerified => phoneVerifiedAt != null;
  bool get isActive => status == 'Active';
}
