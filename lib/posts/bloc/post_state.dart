part of 'post_bloc.dart';

enum Poststatus { initial, succes, failure }

//PostInitial will tell presentation layer it needs to render a loading indicator while 
//the intial batch   of posts are loads

//PostSuccess will tell the presentation layer it has content to render
  //posts : will be the list<Post> which will be displayed
  //hasReachedMax : will tell the presentation layer wheter or not it has reached the maximum number of posts

//PostFailure : will tell presentation layer that on error has occured while fetching posts

final class PostState extends Equatable {
  const PostState({
    this.status = Poststatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false
  });

  final Poststatus status;
  final List<Post> posts;
  final bool hasReachedMax;

  PostState copyWith({ //we use copywith so we can copy an instance of PostSuccess
    Poststatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''Poststate { status : $status, hasReachedMax : $hasReachedMax, posts : ${posts.length}}''';
  }

  
  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}
