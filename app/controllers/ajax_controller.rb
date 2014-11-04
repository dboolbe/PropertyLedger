class AjaxController < ApplicationController

  def accounts
    if params[:term]
      puts "==============================================================="
      puts "params[:term] = #{params[:term]}"
      puts "==============================================================="
      like = "%".concat(params[:term]).concat "%"
      transactions = current_user.transactions.select(:account).where("account like ?", like).distinct.limit 5
    else
      puts "==============================================================="
      puts "params = #{params}"
      puts "==============================================================="
      transactions = current_user.transactions.select(:account).distinct.limit 5
    end

    list = transactions.map { |transaction| Hash[account: transaction.account] }

    puts "================================================================="
    puts "list = #{list}"
    puts "================================================================="

    render json: list
  end
end