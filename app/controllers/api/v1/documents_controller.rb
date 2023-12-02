class Api::V1::DocumentsController < ApplicationController
  def index
    @documents = Document.all
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
