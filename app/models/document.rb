class Document < ApplicationRecord
  store_accessor :document_data, :customer_name, :contract_value
end
