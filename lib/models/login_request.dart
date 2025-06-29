import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
    final String email;
    final String password;

    LoginRequest({
        required this.email,
        required this.password,
    });

    factory LoginRequest.fromJson(Map<String, dynamic> json){
     try{
         return LoginRequest(
             email: json["email"],
             password: json["password"],
         );
     }catch(e){
         print("Error parsing login : $e");
         throw Exception("Failed to parse login JSON");
     }
    }

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}
