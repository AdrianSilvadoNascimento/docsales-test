require 'render_anywhere'
require 'pdfkit'

class GeneratePdf
  include RenderAnywhere

  def initialize(document)
    @document = document
  end

  def to_pdf
    PDFKit.new(as_html, page_size: 'A4').to_file("#{Rails.root}/public/document.pdf")
  end

  def filename
    "Contract #{@document.uuid}.pdf"
  end

  private
    attr_reader :document

    def as_html
      html_content = ActionController::Base.render(
        template: "api/v1/documents/template",
        layout: "template_pdf",
        locals: { document: document }
      )
    end    
end
