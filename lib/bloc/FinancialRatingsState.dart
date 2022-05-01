part of 'FinancialRatingsBloc.dart';

abstract class FinancialRatingsState extends Equatable {
  const FinancialRatingsState();

  @override
  List<Object> get props => [];
}

class FinancialRatingsInitial extends FinancialRatingsState {}

class FinancialRatingsLoaded extends FinancialRatingsState {}

class ConnectionError extends FinancialRatingsState {}
