import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../blocs/user_bloc.dart';
import '../models/user_model.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final PagingController<int, User> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      context.read<UserBloc>().add(FetchUsers(pageKey));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.green,
      title: Text(
        'User List',
        style: TextStyle(
          fontFamily: 'SF-PRO',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
      centerTitle: true,
    ),


      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            final isLastPage = state.hasReachedMax;
            if (isLastPage) {
              _pagingController.appendLastPage(state.users);
            } else {
              final nextPageKey = _pagingController.nextPageKey! + 1;
              _pagingController.appendPage(state.users, nextPageKey);
            }
          } else if (state is UserError) {
            _pagingController.error = state.message;
          }
        },
        child: PagedListView<int, User>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<User>(
            itemBuilder: (context, user, index) => Card(
              elevation: 3.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.avatar),
                ),
                title: Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyle(
                    fontFamily: 'SF-PRO',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserDetailScreen(userId: user.id),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
