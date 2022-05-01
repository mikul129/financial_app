part of 'FinancialRatingsBloc.dart';

abstract class FinancialRatingsEvent extends Equatable {
  const FinancialRatingsEvent();

  @override
  List<Object> get props => [];
}

class GetFinancialRatings extends FinancialRatingsEvent {}
