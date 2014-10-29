class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy]

  # GET /properties
  # GET /properties.json
  def index
    puts "================================================================="
    puts "current_user.id = #{current_user.id}"
    puts "current_user.email = #{current_user.email}"
    puts "================================================================="
    @properties = Property.where(:user_id => current_user.id)
    # @properties = current_user.properties
    puts "================================================================="
    # @transactions = current_user.transactions
    puts "transaction = #{@transactions}"
    puts "current_user.email = #{current_user.email}"
    puts "================================================================="
    @transactions = Transaction.all

    income = @transactions.sum :income
    expense = @transactions.sum :expense
    miscellaneous = @transactions.sum :miscellaneous

    @summation = Hash[
      income: income,
      expense: expense,
      miscellaneous: miscellaneous,
      overall: (income + miscellaneous) - expense
    ]
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
    @summation = Hash.new
    @summation[:income] = @property.transactions.sum :income
    @summation[:expense] = @property.transactions.sum :expense
    @summation[:miscellaneous] = @property.transactions.sum :miscellaneous
    @summation[:overall] = (@summation[:income] + @summation[:miscellaneous]) - @summation[:expense]

    params[:per_page] ||= 100
    @transactions = @property.transactions.paginate(:page => params[:page], :per_page => params[:per_page]).order(:date)
  end

  # GET /properties/new
  def new
    @property = Property.new
    @property.user_id = current_user.id
  end

  # GET /properties/1/edit
  def edit
  end

  # POST /properties
  # POST /properties.json
  def create
    @property = Property.new(property_params)

    respond_to do |format|
      if @property.save
        format.html { redirect_to @property, notice: 'Property was successfully created.' }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /properties/1
  # PATCH/PUT /properties/1.json
  def update
    respond_to do |format|
      if @property.update(property_params)
        format.html { redirect_to @property, notice: 'Property was successfully updated.' }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property.destroy
    respond_to do |format|
      format.html { redirect_to properties_url, notice: 'Property was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params.require(:property).permit(:user_id, :nickname, :description, :address)
    end
end
