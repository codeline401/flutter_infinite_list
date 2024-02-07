import 'package:equatable/equatable.dart';

final class Post extends Equatable{ //we extends equatable so we can comapre posts
  const Post({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;

  @override
  List<Object> get props => [id, title, body]; 
}