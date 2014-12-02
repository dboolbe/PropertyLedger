class PropertiesDatatable
  delegate :params, :current_user, :link_to, :number_to_currency, :edit_property_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Property.where(:user_id => current_user.id).count,
        iTotalDisplayRecords: properties.total_entries,
        aaData: data
    }
  end

  private
    def data
      properties.map do |property|
        transactions = property.transactions

        income = transactions.sum :income
        expense = transactions.sum :expense
        miscellaneous = transactions.sum :miscellaneous

        overall = (income + miscellaneous) - expense

        [
          link_to(property.nickname, property),
          property.description,
          property.address,
          number_to_currency(income, :precision => 2),
          number_to_currency(expense, :precision => 2),
          number_to_currency(miscellaneous, :precision => 2),
          number_to_currency(overall, :precision => 2),
          link_to('Edit', edit_property_path(property)),
          link_to('Destroy', property, method: :delete, data: { confirm: 'Are you sure?' })
        ]
      end
    end

    def properties
      @properties ||= fetch_properties
    end

    def fetch_properties
      properties = Property.where(:user_id => current_user.id)
      case "#{sort_column}"
        when 'total_income'
          # properties = properties.order("concat_org #{sort_direction}")
        when 'total_expenses'
          # properties = properties.order("fname #{sort_direction}").order("lname #{sort_direction}")
        when 'total_miscellaneous'
          # properties = properties.order("fname #{sort_direction}").order("lname #{sort_direction}")
        when 'overall_total'
          # properties = properties.order("fname #{sort_direction}").order("lname #{sort_direction}")
        else
          properties = properties.order "#{sort_column} #{sort_direction}"
      end

      properties = properties.page(page).per_page(per_page)
      if params[:search][:value].present?
        properties = properties.where 'nickname like :search
                                         or description like :search
                                         or address like :search',
                                      search: "%#{params[:search][:value]}%"
      end
      properties
    end

    def page
      params[:start].to_i/per_page + 1
    end

    def per_page
      params[:length].to_i > 0 ? params[:length].to_i : 10
    end

    def sort_column
      columns = %w[nickname description address total_income total_expenses total_miscellaneous overall_total]
      columns[params[:order][0.to_s.to_sym][:column].to_i]
    end

    def sort_direction
      params[:order][0.to_s.to_sym][:dir] == 'desc' ? 'desc' : 'asc'
    end
end