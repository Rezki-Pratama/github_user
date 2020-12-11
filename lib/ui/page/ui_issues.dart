import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/bloc/issues_bloc.dart';
import 'package:infinite_list/model/issues.dart';
import 'package:infinite_list/model/users.dart';
import 'package:infinite_list/utiilities/app_style.dart';
import 'package:intl/intl.dart';

class UiIssues extends StatefulWidget {
  @override
  _UiIssuesState createState() => _UiIssuesState();
}

class _UiIssuesState extends State<UiIssues> {
  ScrollController controller = ScrollController();
  final _textController = TextEditingController();
  IssuesBloc bloc;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  void onScroll() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if (currentScroll == maxScroll) {
      bloc.add(SearchIssues(text: _textController.text, lazyLoad: true));
    }
    print('maximal cuk');
  }

  void _onClear() {
    _textController.text = '';
    bloc.add(SearchIssues(text: '', lazyLoad: false));
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<IssuesBloc>(context);
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
              bloc.add(SearchIssues(text: text, lazyLoad: false));
            },
            decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppStyle.colorWhite,
                ),
                suffixIcon: GestureDetector(
                    onTap: _onClear,
                    child: const Icon(
                      Icons.clear,
                      color: AppStyle.colorWhite,
                    )),
                border: InputBorder.none,
                hintStyle: AppStyle.whiteStyle,
                hintText: 'Search Issues'),
          ),
        ),
        Expanded(
          child: BlocBuilder<IssuesBloc, IssuesState>(builder: (context, state) {
            if (state is IssuesStateLoading) {
              return Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppStyle.colorDark),
                strokeWidth: 7,
              ));
            }
            if (state is IssuesStateError) {
              return Center(
                  child: Text(state.message, style: AppStyle.darkStyle));
            }
            if (state is IssuesStateSuccess) {
              IssuesStateSuccess issuesStateSuccess = state as IssuesStateSuccess;
              return ListView.builder(
                  controller: controller,
                  itemCount: (issuesStateSuccess.hasReachedMax)
                      ? issuesStateSuccess.issues.length
                      : issuesStateSuccess.issues.length + 1,
                  itemBuilder: (context, index) => (index <
                          issuesStateSuccess.issues.length)
                      ? _SearchResultItem(item: issuesStateSuccess.issues[index])
                      : (issuesStateSuccess.issues.length < 10
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
  final Issues item;

  const _SearchResultItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('yyyy-MM-dd hh:mm');
    var inputDate = dateFormat.parse(item.updatedAt.toString());
    var outputFormat = DateFormat('dd-MM-yyyy hh:mm a');
    var ouputDate = outputFormat.format(inputDate);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppStyle.colorDark,
        child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.network(item.user.avatarUrl))),
      title: Text(
        item.title,
        style: AppStyle.darkMedStyle
      ),
      subtitle: Text(ouputDate,style: AppStyle.darkSmallStyle),
      trailing: Text(item.state,style: AppStyle.darkMedStyle),
    );
  }
}
