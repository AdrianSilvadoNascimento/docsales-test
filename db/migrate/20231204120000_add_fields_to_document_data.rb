class AddFieldsToDocumentData < ActiveRecord::Migration[6.1]
  def change
    Document.find_each do |document|
      document.update(document_data: { customer_name: nil, contract_value: nil })
    end
  end
end