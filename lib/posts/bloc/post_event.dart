part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

final class PostFetched extends PostEvent{}
//will be added by the persentation layer whenever it needs more Posts to present.
