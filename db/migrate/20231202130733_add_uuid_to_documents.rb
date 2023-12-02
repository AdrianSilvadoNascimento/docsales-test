class AddUuidToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :uuid, :string
  end
end
