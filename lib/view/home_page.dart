import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instant_image_viewer/connection_bloc/connection_bloc.dart';
import 'package:instant_image_viewer/view/bloc/images_bloc.dart';
import 'package:instant_image_viewer/view/widgets/image_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  Widget child = Center(
    key: Key("initial"),
    child: CircularProgressIndicator(color: Colors.black),
  );
  Widget savedChild = Container();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      bool isTop = scrollController.position.pixels ==
          (scrollController.position.maxScrollExtent);
      if (isTop) {
        context.read<ImagesBloc>().add(ImagesGetNextPageEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) {
              if (state is NoConnectionState) {
                setState(() {

                  savedChild = child;

                  child = SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        key: Key("no connection"),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('NO INTERNET CONNECTION :(')
                          ],
                        )),
                  );
                });
              } else{
                setState((){
                  child = savedChild;
                  context.read<ImagesBloc>().add(ImagesUpdateEvent());
                });
              }
            },
          ),
          BlocListener<ImagesBloc, ImagesState>(
            listener: (context, state) {
              if (state is ImagesHasDataState) {
                setState(() {
                  child = Center(
                    key: const Key("has data"),
                    child: RefreshIndicator(
                      color: Colors.black,
                      onRefresh: () async {
                        context.read<ImagesBloc>().add(ImagesUpdateEvent());
                      },
                      child: CustomScrollView(
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: MasonryGridView.count(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              itemCount: state.photoData.length,
                              itemBuilder: (context, index) {
                                return FittedBox(
                                  fit: BoxFit.cover,
                                  child: ImageTileWidget(
                                    extent: (index % 5 + 1) * 100,
                                    hash: state.photoData[index].blurHash!,
                                    url: state.photoData[index].urls!.regular!,
                                    userImageUrl: state.photoData[index].user!
                                        .profileImage!.medium!,
                                    username:
                                        state.photoData[index].user!.name!,
                                  ),
                                );
                              },
                            ),
                          ),
                          SliverPersistentHeader(
                            delegate: Delegate(),
                          )
                        ],
                      ),
                    ),
                  );
                });
              } else if (state is ImagesLoadingState) {
                setState(() {
                  child = SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                        key: Key("loading"),
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        )),
                  );
                });
              }
            },
          ),

        ],
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: child,
        ),
      ),
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 15,
      child: Center(
          child: CircularProgressIndicator(
        color: Colors.black,
      )),
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
