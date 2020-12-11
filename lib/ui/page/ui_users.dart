import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/bloc/user_bloc.dart';
import 'package:infinite_list/model/users.dart';
import 'package:infinite_list/utiilities/app_style.dart';

class UiUser extends StatefulWidget {
  @override
  _UiUserState createState() => _UiUserState();
}

class _UiUserState extends State<UiUser> {
  ScrollController controller = ScrollController();
  final _textController = TextEditingController();
  UserBloc bloc;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  void onScroll() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if (currentScroll == maxScroll) {
      bloc.add(SearchUsers(text: _textController.text, lazyLoad: true));
    }
    print('maximal cuk');
  }

  void _onClear() {
    _textController.text = '';
    bloc.add(SearchUsers(text: '', lazyLoad: false));
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<UserBloc>(context);
    controller.addListener(onScroll);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppStyle.colorDark,
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width / 25,
              MediaQuery.of(context).size.width / 8,
              MediaQuery.of(context).size.width / 25,
              0),
          child: TextField(
            style: AppStyle.greyStyle,
            controller: _textController,
            autocorrect: false,
            onChanged: (text) {
              bloc.add(SearchUsers(text: text, lazyLoad: false));
            },
            decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppStyle.colorGrey,
                ),
                suffixIcon: GestureDetector(
                    onTap: _onClear,
                    child: const Icon(
                      Icons.clear,
                      color: AppStyle.colorGrey,
                    )),
                border: InputBorder.none,
                hintStyle: AppStyle.greyStyle,
                hintText: 'Search Users'),
          ),
        ),
        Expanded(
          child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserStateLoading) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppStyle.colorDark),
                strokeWidth: 7,
              ));
            }
            if (state is UserStateError) {
              return Center(
                  child: Text(state.message, style: AppStyle.darkStyle));
            }
            if (state is UserStateSuccess) {
              UserStateSuccess userStateSuccess = state as UserStateSuccess;
              return ListView.builder(
                  controller: controller,
                  itemCount: (userStateSuccess.hasReachedMax)
                      ? userStateSuccess.user.length
                      : userStateSuccess.user.length + 1,
                  itemBuilder: (context, index) => (index <
                          userStateSuccess.user.length)
                      ? _SearchResultItem(item: userStateSuccess.user[index])
                      : (userStateSuccess.user.length < 10
                          ? Container()
                          : Container(
                              child: Center(
                                  child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppStyle.colorDark),
                                ),
                              )),
                            )));
            }

            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/secondImage.png",
                  width: MediaQuery.of(context).size.width / 2,
                ),
                const Text(
                  'Search to begin',
                  style: AppStyle.darkStyle,
                ),
              ],
            ));
          }),
        )
      ],
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final User item;

  const _SearchResultItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: AppStyle.colorDark,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(item.avatarUrl))),
      title: Text(
        item.login,
        style: AppStyle.darkStyle,
      ),
    );
  }
}
