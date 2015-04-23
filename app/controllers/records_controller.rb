class RecordsController < ApplicationController
  def show
    # fix id if there is no correct format
    params[:id] = "#{params[:id]}.#{params[:format]}" if !['json', 'html'].include? params[:format]

    @record = WhoisRecord.find_by_name(params[:id])
    
    begin
      respond_to do |format|
        format.json do
          if @record.present?
            return render json: @record.json
          else
            return render json: {
              name: params[:id],
              error: "Domain not found."},
              status: :not_found
          end
        end
      end
    rescue ActionController::UnknownFormat
      if @record.present?
      else
        return render text: "Domain not found: #{params[:id]}", status: :not_found
      end
    end
  end
end
