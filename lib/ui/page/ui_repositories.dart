import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/bloc/repositories_bloc.dart';
import 'package:infinite_list/model/repositories.dart';
import 'package:infinite_list/utiilities/app_style.dart';
import 'package:intl/intl.dart';

class UiRepositories extends StatefulWidget {
  @override
  _UiRepositoriesState createState() => _UiRepositoriesState();
}

class _UiRepositoriesState extends State<UiRepositories> {
  ScrollController controller = ScrollController();
  final _textController = TextEditingController();
  RepositoriesBloc bloc;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  void onScroll() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if (currentScroll == maxScroll) {
      bloc.add(TextSearch(text: _textController.text, lazyLoad: true));
    }
  }

  void _onClear() {
    _textController.text = '';
    bloc.add(TextSearch(text: '', lazyLoad: false));
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<RepositoriesBloc>(context);
    controller.addListener(onScroll);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppStyle.colorGrey,
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width / 25,
              MediaQuery.of(context).size.width / 8,
              MediaQuery.of(context).size.width / 25,
              0),
          child: TextField(
            style: AppStyle.darkStyle,
            controller: _textController,
            autocorrect: false,
            onChanged: (text) {
              bloc.add(TextSearch(text: text, lazyLoad: false));
            },
            decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppStyle.colorDark,
                ),
                suffixIcon: GestureDetector(
                    onTap: _onClear,
                    child: const Icon(
                      Icons.clear,
                      color: AppStyle.colorDark,
                    )),
                border: InputBorder.none,
                hintStyle: AppStyle.darkStyle,
                hintText: 'Search Repositories'),
          ),
        ),
        Expanded(
          child: BlocBuilder<RepositoriesBloc, RepoState>(
              builder: (context, state) {
            if (state is RepoStateLoading) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppStyle.colorGrey),
                strokeWidth: 7,
              ));
            }
            if (state is RepoStateError) {
              return Center(
                  child: Text(state.message, style: AppStyle.greyStyle));
            }
            if (state is RepoStateSuccess) {
              RepoStateSuccess repoStateSuccess = state as RepoStateSuccess;
              return ListView.builder(
                  controller: controller,
                  itemCount: (repoStateSuccess.hasReachedMax)
                      ? repoStateSuccess.repositories.length
                      : repoStateSuccess.repositories.length + 1,
                  itemBuilder: (context, index) => (index <
                          repoStateSuccess.repositories.length)
                      ? _SearchResultItem(
                          item: repoStateSuccess.repositories[index])
                      : (repoStateSuccess.repositories.length < 10
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Center(
                                    child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppStyle.colorGrey),
                                  ),
                                )),
                              ),
                            )));
            }

            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/firstImage.png",
                  width: MediaQuery.of(context).size.width / 2,
                ),
                const Text(
                  'Search to begin',
                  style: AppStyle.greyStyle,
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
  final Repositories item;

  const _SearchResultItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('yyyy-MM-dd hh:mm');
    var inputDate = dateFormat.parse(item.createdAt.toString());
    var outputFormat = DateFormat('dd-MM-yyyy hh:mm a');
    var ouputDate = outputFormat.format(inputDate);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width / 30),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: AppStyle.colorGrey,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(item.owner.avatarUrl))),
        title: Text(
          item.fullName,
          style: AppStyle.whiteMedStyle,
        ),
        subtitle: Text(ouputDate, style: AppStyle.whiteSmallStyle),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text('stars : ' +
              item.stargazersCount.toString(),
              style: AppStyle.whiteSmallStyle,
            )),
            Expanded(
                child: Text('watchers : ' +
              item.watchersCount.toString(),
              style: AppStyle.whiteSmallStyle,
            )),
            Expanded(
                child: Text('forks : ' +
              item.forks.toString(),
              style: AppStyle.whiteSmallStyle,
            )),
          ],
        ),
      ),
    );
  }
}
