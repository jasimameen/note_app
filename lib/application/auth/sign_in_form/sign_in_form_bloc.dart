import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:note_app/domain/auth/auth_failure.dart';
import 'package:note_app/domain/auth/i_auth_facade.dart';
import 'package:note_app/domain/auth/value_objects.dart';

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    // EmailChanged

    on<EmailChanged>((event, emit) => emit(
          state.copyWith(
            emailAddress: EmailAddress(event.emailStr),
            authFailureOrSuccesOption: none(),
          ),
        ));

    // Password Change

    on<PasswordChanged>((event, emit) => emit(
          state.copyWith(
            password: Password(event.passwordStr),
            authFailureOrSuccesOption: none(),
          ),
        ));

    // SignIn With Google

    on<SignInWithGooglePressed>((event, emit) async {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccesOption: none(),
        ),
      );

      final faulureOrSuccess = await _authFacade.signInWithGoogle();
      emit(state.copyWith(
        isSubmitting: false,
        authFailureOrSuccesOption: some(faulureOrSuccess),
      ));
    });

    // Register With Email

    on<RegisterWithEmailAndPasswordPressed>((event, emit) async {
      Either<AuthFailure, Unit>? failureOrSucces;

      final isEmailValid = state.emailAddress.isValid();
      final isPasswordValid = state.password.isValid();

      if (isEmailValid && isPasswordValid) {
        emit(state.copyWith(
          isSubmitting: true,
          authFailureOrSuccesOption: none(),
        ));

        failureOrSucces = await _authFacade.registerWithEmailAndPassword(
          emailAddress: state.emailAddress,
          password: state.password,
        );
      }

      emit(state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccesOption: optionOf(failureOrSucces),
      ));
    });

    // SignIn With Email

    on<SignInWithEmailAndPasswordPressed>((event, emit) async {
      Either<AuthFailure, Unit>? failureOrSucces;

      final isEmailValid = state.emailAddress.isValid();
      final isPasswordValid = state.password.isValid();

      if (isEmailValid && isPasswordValid) {
        emit(state.copyWith(
          isSubmitting: true,
          authFailureOrSuccesOption: none(),
        ));

        failureOrSucces = await _authFacade.signInWithEmailAndPassword(
          emailAddress: state.emailAddress,
          password: state.password,
        );
      }

      emit(state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccesOption: optionOf(failureOrSucces),
      ));
    });
  }
}
