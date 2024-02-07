import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_infinite_list/posts/models/post.dart';
//import 'package:flutter_infinite_list/bloc/bloc.dart';

import 'package:stream_transform/stream_transform.dart'; //to use throttle API

part 'post_event.dart';
part 'post_state.dart';

const _postLimits = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper){
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}


//This PostBloc will have a direct dependency on an http client.

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration)
    );
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(PostEvent event, Emitter<PostState> emit) async {
    if(state.hasReachedMax) return;
    try {
      if(state.status == Poststatus.initial){
        final posts = await _fetchPosts();
        return emit(state.copyWith(
          status: Poststatus.succes,
          posts: posts,
          hasReachedMax: false
        ));
      }

      final posts = await _fetchPosts(state.posts.length);
      emit(posts.isEmpty
        ? state.copyWith(hasReachedMax: false)
        : state.copyWith(
          status: Poststatus.succes,
          posts: List.of(state.posts)..addAll(posts),
          hasReachedMax: false,
        )
      );
    } catch (_) {
      emit(state.copyWith(status: Poststatus.failure));
    }
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start' : '$startIndex', '_limit' : '$_postLimits'},
      ),
    );
    if(response.statusCode == 200){
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String
        );
      }).toList();
    }
    throw Exception('Error fetching post');
  }
}
