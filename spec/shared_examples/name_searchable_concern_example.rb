shared_examples "name searchable concern" do |factory_name|
  let!(:search_param) { "Example" }
  let!(:records_to_find) do 
    (0..3).to_a.map { |index| create(factory_name, name: "Example #{index}") }
  end
  let!(:records_to_ignore) { create_list(factory_name, 3) }
end