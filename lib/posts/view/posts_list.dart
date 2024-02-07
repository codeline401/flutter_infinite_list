import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_infinite_list/posts/bloc/post_bloc.dart';
import 'package:flutter_infinite_list/posts/posts.dart';
//import 'package:flutter_infinite_list/posts/widgets/bottom_loader.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {

  final _scrollCOntroller = ScrollController();

  @override
  void initState(){
    super.initState();
    _scrollCOntroller.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch(state.status){
          case Poststatus.failure:
            return const Center(child: Text('Failed to fetch posts'),);
          
          case Poststatus.succes:
            if(state.posts.isEmpty){
              return const Center(child: Text('no posts'),);
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index){
                return index >= state.posts.length
                  ? const BottomLoader()
                  : PostListItem(post : state.posts[index]);
              },
              itemCount: state.hasReachedMax
                ? state.posts.length
                : state.posts.length + 1,
              controller: _scrollCOntroller,
            );
          
          case Poststatus.initial:
            return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  @override
  void dispose(){
    _scrollCOntroller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if(_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollCOntroller.hasClients) return false;
    final maxScroll = _scrollCOntroller.position.maxScrollExtent;
    final currentScroll = _scrollCOntroller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

