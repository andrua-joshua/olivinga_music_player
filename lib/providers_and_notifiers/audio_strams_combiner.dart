///
///class used to represent the data return by the audio streams
///
//ignore: camel_case_types
class PositionData {
  final Duration _positionStream;
  final Duration _bufferedPositionStream;
  final Duration _durationStream;

  PositionData(
      this._positionStream, this._bufferedPositionStream, this._durationStream);

  Duration get position => _positionStream;
  Duration get bufferedPosition => _bufferedPositionStream;
  Duration get duration => _durationStream;
}
