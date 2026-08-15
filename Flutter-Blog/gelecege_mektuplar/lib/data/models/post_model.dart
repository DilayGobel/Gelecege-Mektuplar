import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gelecege_mektuplar/data/models/user_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String content,
    required String category,
    required UserModel author,
    required DateTime createdAt,
  }) = _PostModel;

  /// JSON verisinden bir PostModel nesnesi oluşturur.
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
