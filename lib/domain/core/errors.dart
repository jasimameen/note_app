import 'package:note_app/domain/core/failures.dart';

class UnexpentedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpentedValueError(this.valueFailure);

  @override
  String toString() {
    const explanation =
        'Encountered ValueFailure at an unrecoverable point. Terminating.';
    return Error.safeToString('$explanation Failure was $valueFailure');
  }
}
