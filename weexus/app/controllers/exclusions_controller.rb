class ExclusionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_exclusion, only: [:show, :edit, :update, :destroy]

  # GET /exclusions
  # GET /exclusions.json
  def index
    @exclusions = Exclusion.all.paginate(page: params[:page], per_page: 5)
  end

  # GET /exclusions/1
  # GET /exclusions/1.json
  def show
  end

  # GET /exclusions/new
  def new
    @exclusion = Exclusion.new
  end

  # GET /exclusions/1/edit
  def edit
  end

  # POST /exclusions
  # POST /exclusions.json
  def create
    @exclusion = Exclusion.new(exclusion_params)

    respond_to do |format|
      if @exclusion.save
        format.html { redirect_to @exclusion, notice: 'Exclusion was successfully created.' }
        format.json { render :show, status: :created, location: @exclusion }
      else
        format.html { render :new }
        format.json { render json: @exclusion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exclusions/1
  # PATCH/PUT /exclusions/1.json
  def update
    respond_to do |format|
      if @exclusion.update(exclusion_params)
        format.html { redirect_to @exclusion, notice: 'Exclusion was successfully updated.' }
        format.json { render :show, status: :ok, location: @exclusion }
      else
        format.html { render :edit }
        format.json { render json: @exclusion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exclusions/1
  # DELETE /exclusions/1.json
  def destroy
    @exclusion.destroy
    respond_to do |format|
      format.html { redirect_to exclusions_url, notice: 'Exclusion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exclusion
      @exclusion = Exclusion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exclusion_params
      params.require(:exclusion).permit(:word, :weighting)
    end
end
