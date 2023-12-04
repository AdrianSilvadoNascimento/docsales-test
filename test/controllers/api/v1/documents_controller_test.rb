require "test_helper"

class Api::V1::DocumentsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "Should list documents" do
    get api_v1_documents_url
    assert_response :success
  end

  test "Should create document" do
    GeneratePdf.any_instance.stubs(:to_pdf).returns("fake_pdf_data")

    post api_v1_documents_url, params: { document: { customer_name: "John Doe", contract_value: "1000", description: "Test document" } }, as: :json

    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_match /Pdf has been generated successfully/, @response.body

    assert_equal "fake_pdf_data", uploaded_pdf_data
    assert_equal "bucket_docsales", uploaded_pdf_url
  end

  test "Should not create invalid document" do
    post api_v1_documents_url, params: { document: invalid_params }, as: :json

    assert_response :unprocessable_entity
    assert_match /Error generating PDF/, @response.body

    assert_nil uploaded_pdf_data
    assert_nil uploaded_pdf_url
  end

  test "Should delete a document" do
    document = Document.new
    document.uuid = SecureRandom.uuid
    document.description = document_params['description']
    document.document_data['customer_name'] = document_params['customer_name']
    document.document_data['contract_value'] = document_params['contract_value']
    
    delete exclude_api_v1_documents_url, params: { uuid: document.uuid }, as: :json

    assert_response :success
    assert_match /Document has been successfuly deleted/, @response.body
  end

  def document_params
    {
      customer_name: 'Adrian',
      description: 'Short description',
      contract_value: 'R$5.200,00',
    }
  end
  
  def invalid_params
    {
      customer_name: '',
      description: '',
      contract_value: '',
    }
  end
end
