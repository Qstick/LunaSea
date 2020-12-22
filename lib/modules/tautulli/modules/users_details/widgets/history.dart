import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';
import 'package:tautulli/tautulli.dart';

class TautulliUserDetailsHistory extends StatefulWidget {
    final TautulliTableUser user;

    TautulliUserDetailsHistory({
        Key key,
        @required this.user,
    }): super(key: key);

    @override
    State<StatefulWidget> createState() => _State();
}

class _State extends State<TautulliUserDetailsHistory> with AutomaticKeepAliveClientMixin {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
    
    @override
    bool get wantKeepAlive => true;

    @override
    void initState() {
        super.initState();
        SchedulerBinding.instance.scheduleFrameCallback((_) => _refresh());
    }

    Future<void> _refresh() async {
        context.read<TautulliState>().setUserHistory(
            widget.user.userId,
            context.read<TautulliState>().api.history.getHistory(
                userId: widget.user.userId,
                length: TautulliDatabaseValue.CONTENT_LOAD_LENGTH.data,
            ),
        );
        await context.read<TautulliState>().userHistory[widget.user.userId];
    }

    @override
    Widget build(BuildContext context) {
        super.build(context);
        return Scaffold(
            key: _scaffoldKey,
            body: _body,
        );
    }

    Widget get _body => LSRefreshIndicator(
        refreshKey: _refreshKey,
        onRefresh: _refresh,
        child: FutureBuilder(
            future: context.watch<TautulliState>().userHistory[widget.user.userId],
            builder: (context, AsyncSnapshot<TautulliHistory> snapshot) {
                if(snapshot.hasError) {
                    if(snapshot.connectionState != ConnectionState.waiting) {
                        LunaLogger().error('Unable to fetch Tautulli user history: ${widget.user.userId}', snapshot.error, StackTrace.current);
                    }
                    return LSErrorMessage(onTapHandler: () async => _refreshKey.currentState.show());
                }
                if(snapshot.hasData) return snapshot.data.records.length == 0 
                    ? _noHistory()
                    : _history(snapshot.data);
                return LSLoader();
            },
        ),
    );

    Widget _history(TautulliHistory history) => LSListViewBuilder(
        itemCount: history.records.length,
        itemBuilder: (context, index) => TautulliHistoryTile(
            userId: history.records[index].userId,
            history: history.records[index],
        ),
    );

    Widget _noHistory() => LSGenericMessage(
        text: 'No History Found',
        showButton: true,
        buttonText: 'Refresh',
        onTapHandler: () async => _refreshKey.currentState.show(),
    );
}
