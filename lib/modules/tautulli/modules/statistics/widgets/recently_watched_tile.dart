import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';
import 'package:tautulli/tautulli.dart';

class TautulliStatisticsRecentlyWatchedTile extends StatelessWidget {
    final Map<String, dynamic> data;
    final double _imageDimension = 83.0;
    final double _padding = 8.0;

    TautulliStatisticsRecentlyWatchedTile({
        Key key,
        @required this.data,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) => LSCard(
        child: InkWell(
            borderRadius: BorderRadius.circular(Constants.UI_BORDER_RADIUS),
            child: Row(
                children: [
                    _poster(context),
                    _details(context),
                ],
            ),
            onTap: () async => _onTap(context),
        ),
        decoration: data['art'] != null && (data['art'] as String).isNotEmpty
            ? LunaCardDecoration(
                uri: context.watch<TautulliState>().getImageURLFromPath(
                    data['art'],
                    width: MediaQuery.of(context).size.width.truncate(),
                ),
                headers: context.watch<TautulliState>().headers.cast<String, String>(),
            )
            : null,
    );

    Widget _poster(BuildContext context) => LSNetworkImage(
        url: context.watch<TautulliState>().getImageURLFromPath(data['thumb']),
        headers: context.watch<TautulliState>().headers.cast<String, String>(),
        placeholder: 'assets/images/sonarr/noseriesposter.png',
        height: _imageDimension,
        width: _imageDimension/1.5,
    );

    Widget _details(BuildContext context) => Expanded(
        child: Padding(
            child: Container(
                child: Column(
                    children: [
                        _title,
                        _subtitle(context),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                ),
                height: (_imageDimension-(_padding*2)),
            ),
            padding: EdgeInsets.all(_padding),
        ),
    );

    Widget get _title => LSTitle(
        text: data['title'],
        maxLines: 1,
    );

    Widget _subtitle(BuildContext context) => RichText(
        text: TextSpan(
            style: TextStyle(
                color: Colors.white70,
                fontSize: Constants.UI_FONT_SIZE_SUBTITLE,
            ),
            children: <TextSpan>[
                TextSpan(text: data['friendly_name'] ?? 'Unknown User'),
                TextSpan(text: '\n'),
                data['player'] != null
                    ? TextSpan(text: data['player'])
                    : TextSpan(text: '${Constants.TEXT_EMDASH}'),
                TextSpan(text: '\n'),
                data['last_watch'] != null
                    ? TextSpan(text: 'Watched ' + DateTime.fromMillisecondsSinceEpoch(data['last_watch']*1000)?.lunaAge ?? 'Unknown')
                    : TextSpan(text: Constants.TEXT_EMDASH)
            ],
        ),
        softWrap: false,
        maxLines: 3,
        overflow: TextOverflow.fade,
    );

    Future<void> _onTap(BuildContext context) async => TautulliMediaDetailsRouter.navigateTo(context, ratingKey: data['rating_key'], mediaType: TautulliMediaType.NULL.from(data['media_type']));
}
