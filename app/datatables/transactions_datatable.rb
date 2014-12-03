class TransactionsDatatable
  delegate :params, :current_user, :link_to, :number_to_currency, :edit_property_transaction_path, to: :@view

  def initialize(view, property)
    @property = property
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: @property.transactions.count,
        iTotalDisplayRecords: transactions.total_entries,
        aaData: data
    }
  end

  private
    def data
      transactions.map do |transaction|
        [
          link_to(transaction.account, [transaction.property, transaction]),
          transaction.date,
          number_to_currency(transaction.income, :precision => 2),
          number_to_currency(transaction.expense, :precision => 2),
          number_to_currency(transaction.miscellaneous, :precision => 2),
          transaction.comment,
          link_to('Edit', edit_property_transaction_path(transaction.property, transaction)),
          link_to('Destroy', [transaction.property, transaction], method: :delete, data: { confirm: 'Are you sure?' })
        ]
      end
    end

    def transactions
      @transactions ||= fetch_transactions
    end

    def fetch_transactions
      transactions = @property.transactions
      case "#{sort_column}"
        when 'comment'
          # currently not sorting on comment column
        else
          transactions = transactions.order "#{sort_column} #{sort_direction}"
      end

      transactions = transactions.page(page).per_page(per_page)
      if params[:search][:value].present?
        transactions = transactions.where 'account like :search',
                                          search: "%#{params[:search][:value]}%"
      end
      transactions
    end

    def page
      params[:start].to_i/per_page + 1
    end

    def per_page
      params[:length].to_i > 0 ? params[:length].to_i : 10
    end

    def sort_column
      columns = %w[account date income expense miscellaneous comment]
      columns[params[:order][0.to_s.to_sym][:column].to_i]
    end

    def sort_direction
      params[:order][0.to_s.to_sym][:dir] == 'desc' ? 'desc' : 'asc'
    end
end