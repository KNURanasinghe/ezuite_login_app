class UserModel {
  final String userCode;
  final String userDisplayName;
  final String email;
  final String userEmployeeCode;
  final String companyCode;
  final List<dynamic>? userLocations;
  final List<dynamic>? userPermissions;

  UserModel({
    required this.userCode,
    required this.userDisplayName,
    required this.email,
    required this.userEmployeeCode,
    required this.companyCode,
    this.userLocations,
    this.userPermissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userCode: json['User_Code'] ?? json['userCode'] ?? '',
      userDisplayName:
          json['User_Display_Name'] ?? json['userDisplayName'] ?? '',
      email: json['Email'] ?? json['email'] ?? '',
      userEmployeeCode:
          json['User_Employee_Code'] ?? json['userEmployeeCode'] ?? '',
      companyCode: json['Company_Code'] ?? json['companyCode'] ?? '',
      userLocations: json['User_Locations'] ?? json['userLocations'] ?? [],
      userPermissions:
          json['User_Permissions'] ?? json['userPermissions'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'User_Code': userCode,
        'User_Display_Name': userDisplayName,
        'Email': email,
        'User_Employee_Code': userEmployeeCode,
        'Company_Code': companyCode,
        'User_Locations': userLocations,
        'User_Permissions': userPermissions,
      };
}
