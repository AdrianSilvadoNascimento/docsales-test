require 'google/cloud/storage'

class Api::V1::DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  
  def index
    @documents = Document.all
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new

    if check_params(document_params) == false
      flash[:error] = "Error generating PDF"
      render :new
    end

    @document.uuid = generate_uuid
    @document.document_data = document_params
    @document.description = document_params['description']

    if @document.save!
      generate_and_upload_pdf

      redirect_to template_api_v1_documents_path(uuid: @document.uuid), notice: 'Pdf has been generated successfully'
    end
  end

  def destroy
    @document = Document.find_by(uuid: params['uuid'])
    @document.destroy
    redirect_to api_v1_documents_path, notice: 'Document has been successfuly deleted'
  end

  def template
    @document = Document.find_by(uuid: params['uuid'])
    @customer_name = @document.document_data['customer_name']
    @contract_value = @document.document_data['contract_value']
  end

  def download
    respond_to do |format|
      format.pdf { send_document_pdf }
    end
  end

  private

    def check_params(params)
      return false if params['customer_name'].blank? || params['contract_value'].blank? || params['description'].blank?
    end
  
    def set_document
      @document = Document.find_by(uuid: params['uuid'])
    end

    def generate_uuid
      SecureRandom.uuid
    end

    def document_params
      params.require(:document).permit(:customer_name, :contract_value, :description)
    end

    def generate_and_upload_pdf
      document = GeneratePdf.new(Document.find_by(uuid: @document.uuid))
      pdf_url = upload_to_google_storage(document.to_pdf)

      @document.update(pdf_url: pdf_url)
    end

    def upload_to_google_storage(pdf_data)
      storage = Google::Cloud::Storage.new(project_id: "carbide-oarlock-382113")
      bucket = storage.bucket('bucket_docsales')

      file_name = "pdf_#{SecureRandom.uuid}.pdf"

      file = bucket.create_file(pdf_data, file_name)

      file.url
    end
    
    def document_pdf
      GeneratePdf.new(Document.find_by(uuid: params['uuid']))
    end

    def send_document_pdf
      send_file document_pdf.to_pdf,
        filename: document_pdf.filename,
        type: "application/pdf",
        disposition: 'inline'
    end
end
