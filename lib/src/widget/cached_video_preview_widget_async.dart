import 'package:cached_video_preview/src/helper/cache_helper.dart';
import 'package:cached_video_preview/src/models/source_type.dart';
import 'package:cached_video_preview/src/models/video_preview_data.dart';
import 'package:cached_video_preview/src/widget/cached_video_preview_widget.dart';
import 'package:flutter/material.dart';

class CachedVideoPreviewWidgetAsync extends StatefulWidget {
  const CachedVideoPreviewWidgetAsync({
    Key? key,
    required this.path,
    this.type = SourceType.local,
    this.remoteImageBuilder,
    this.fileImageBuilder,
    this.placeHolder,
    this.fadeDuration = const Duration(milliseconds: 500),
    this.httpHeaders,
  }) : super(key: key);

  /// Video path can be remote url or local file path
  final String path;

  /// [SourceType] enum value
  final SourceType type;

  /// Use this callback if you want to build your own widget
  final RemoteImageBuilder? remoteImageBuilder;

  /// Use this callback if you want to build your own widget
  final FileImageBuilder? fileImageBuilder;

  /// Use this [placeHolder] if you want to build your own placeholder
  final Widget? placeHolder;

  /// Use this [fadeDuration] if you want to
  /// ovverride [FadeTransition] duration.
  /// Default = [const Duration(milliseconds: 500)]
  final Duration fadeDuration;

  /// HTTP headers for remote video request
  final Map<String, String>? httpHeaders;

  @override
  _CachedVideoPreviewWidgetAsyncState createState() =>
      _CachedVideoPreviewWidgetAsyncState();
}

class _CachedVideoPreviewWidgetAsyncState
    extends State<CachedVideoPreviewWidgetAsync> {
  VideoPreviewData? data;

  @override
  void initState() {
    () async {
      final res = await CachedVideoPreviewHelper.instance.loadAsync(
        widget.path,
        SourceType.remote,
        {},
      );
      if (mounted) {
        setState(() {
          data = res;
        });
      }
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return widget.placeHolder ??
          const Center(
            child: CircularProgressIndicator.adaptive(),
          );
    }
    return data!.file != null
        ? widget.fileImageBuilder?.call(context, data!.file!) ??
            Image.memory(data!.file!)
        : widget.remoteImageBuilder?.call(context, data!.url) ??
            Image.network(data!.url);
  }
}
