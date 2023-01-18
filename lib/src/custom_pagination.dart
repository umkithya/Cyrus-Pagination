// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CyrusPagination<T extends Object> extends StatelessWidget {
  CyrusPagination({
    Key? key,
    required this.itemList,
    this.loading = true,
    this.error = false,
    this.page = 1,
    required this.fetchData,
    required this.widget,
    this.loadingWidget,
    this.emptyStateWidget,
    this.loadMoreWidget,
    required this.onRefresh,
    this.end = false,
    this.delay = 0,
    this.hasMoreData = false,
    this.isGridView = false,
    this.sliverAppBar,
    this.gridDelegate,
    this.padding,
  }) : super(key: key);
  final List<T>? itemList;
  bool loading;
  final bool error;
  final bool? end;
  final bool hasMoreData;
  int page;
  final int? delay;
  final void Function() fetchData;
  Widget Function(T,int) widget;
  final Widget? loadingWidget;
  final Widget? emptyStateWidget;
  final Widget? loadMoreWidget;
  final Future<void> Function() onRefresh;
  final bool isGridView;
  final SliverAppBar? sliverAppBar;
  final SliverGridDelegate? gridDelegate;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (!isGridView) {
        debugPrint('abc');
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          debugPrint("$end ISMORE DATA$loading,${itemList!.length}");
          if (end == false) {
            fetchData();
          }
        }
      }
    });
    if (loading == false && itemList!.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child:
            emptyStateWidget ?? const Center(child: Text("No Data Available")),
      );
    } else if (loading) {
      return loadingWidget ?? const Center(child: CircularProgressIndicator());
    } else {
      return isGridView
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification sn) {
                try {
                  if (sn is ScrollUpdateNotification &&
                      sn.metrics.pixels == sn.metrics.maxScrollExtent) {
                    fetchData.call();
                  }
                } catch (e) {
                  debugPrint('$e');
                }

                return true;
              },
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  slivers: <Widget>[
                    sliverAppBar ??
                        const SliverToBoxAdapter(child: SizedBox.shrink()),
                    SliverPadding(
                      padding:
                          const EdgeInsets.only(right: 10, left: 20, top: 20),
                      sliver: SliverGrid(
                        gridDelegate: gridDelegate ??
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 4.5,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => widget(itemList![index],index),
                          childCount: itemList!.length,
                          addAutomaticKeepAlives: true,
                          addRepaintBoundaries: true,
                          addSemanticIndexes: true,
                        ),
                      ),
                    ),
                    if (!loading && !end!)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: loadMoreWidget ??
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              ),
                        ),
                      ),
                    if (!loading && end!)
                      const SliverToBoxAdapter(
                          child: SizedBox(
                        height: 30,
                      )),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                slivers: <Widget>[
                  sliverAppBar ??
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                  SliverPadding(
                    padding: padding ?? EdgeInsets.zero,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => widget(itemList![index],index),
                        childCount: itemList!.length,
                        addAutomaticKeepAlives: true,
                        addRepaintBoundaries: true,
                        addSemanticIndexes: true,
                      ),
                    ),
                  ),
                  if (!loading && !end!)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: loadMoreWidget ??
                            const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                      ),
                    ),
                  if (!loading && end!)
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 30,
                    )),
                ],
              ),

              // ListView.builder(
              //     controller: scrollController,

              //     itemCount: hasMoreData && end != true
              //         ? itemList!.length + 1
              //         : itemList!.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return index >= itemList!.length
              //           ? Container(
              //               alignment: Alignment.center,
              //               child: const Center(
              //                 child: Padding(
              //                   padding: EdgeInsets.only(bottom: 30),
              //                   child: CircularProgressIndicator(
              //                       // strokeWidth: 1.5,
              //                       ),
              //                 ),
              //               ),
              //             )
              //           : widget(itemList![index]);
              //     })
              // ListView(
              //   shrinkWrap: true,
              //   controller: scrollController,
              //   children: [
              //     ListView(
              //         shrinkWrap: true,
              //         physics: const NeverScrollableScrollPhysics(),
              //         // itemExtent: 100,

              //         children: [
              //           ...itemList!.map((e) {
              //             debugPrint('itemLength:${itemList!.length}');
              //             return widget(e);
              //           }).toList(),
              //         ]),
              //     if (hasMoreData && end != true)
              //       Container(
              //         alignment: Alignment.center,
              //         child: const Center(
              //           child: SizedBox(
              //             width: 33,
              //             height: 33,
              //             child: CircularProgressIndicator(
              //               strokeWidth: 1.5,
              //             ),
              //           ),
              //         ),
              //       ),
              //   ],
              // ),
            );
    }
  }
}
