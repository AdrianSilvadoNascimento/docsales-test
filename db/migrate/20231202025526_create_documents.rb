class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.string :pdf_url
      t.string :description
      t.json :document_data, default: {}

      t.timestamps
    end
  end
end
