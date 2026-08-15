import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    // MongoDB'den gelen '_id' alanını 'id' olarak eşliyoruz.
    @JsonKey(name: '_id') required String id,
    required String username,
    required String email,
  }) = _UserModel;

  /// JSON verisinden bir UserModel nesnesi oluşturur.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
