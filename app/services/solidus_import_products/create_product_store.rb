module SolidusImportProducts
  class CreateProductStore
    def initialize(product_id, store_code)
      @product_id = product_id
      @store = Spree::Store.find_by(code: store_code)
    end

    def call
      return if store.nil? || product_exist_in_store?

      sql = "INSERT INTO spree_products_stores (product_id, store_id) VALUES (#{product_id}, #{store.id})"
      execute(sql)
    end

    private

    attr_reader :product_id, :store

    def product_exist_in_store?
      sql = "SELECT * FROM spree_products_stores WHERE product_id=#{product_id} AND store_id=#{store.id}"
      execute(sql).count.positive?
    end

    def execute(sql)
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
