class TransfersController < ApplicationController
  helper_method :transfers_params
  
  def index
    @start = Time.now
    @to = transfers_params[:to]
    @symbol = transfers_params[:symbol].to_s.upcase
    @per_page = (transfers_params[:per_page] || '100').to_i
    @page = (transfers_params[:page] || '1').to_i
    @transfers = TokensTransfer.joins(:trx).includes(:trx).where(to: @to)
    @transfers = @transfers.where(symbol: @symbol) if @symbol.present? && @symbol != '*'
    @transfers = @transfers.order(Transaction.arel_table[:block_num].desc)
    @transfers = @transfers.paginate(per_page: @per_page, page: @page)
    @elapsed = Time.now - @start
  end
private
  def transfers_params
    params.permit(:to, :symbol, :per_page, :page)
  end
end
