shared_examples "paginatable concern" do |factory_name|
  context "when pages fix page size" do
    let!(:records) { create_list(factory_name, 20)}

    context "when :page and :length are empty" do
      let(:paginated_records) { described_class.paginate(nil, nil) }

      it "returns default 10 records" do
        expect(paginated_records.count).to eq 10
      end

      it "matches first 10 records" do
        expected_record = described_class.all[0..9]
        expect(paginated_records).to eq expected_record
      end
    end

    context "when :page is fulfilled and :length is empty" do
      let(:paginated_records) { described_class.paginate(2, nil) }

      it "return default 10 records" do
        expect(paginated_records.count).to eq 10
      end
      it "returns 10 records from right page" do
        expected_record = described_class.all[10..19]
        expect(paginated_records).to eq expected_record
      end
    end

    context "when :page and :length are fulfilled and fits records size" do
      let(:paginated_records) { described_class.paginate(2, 5) }

      it "returns right quantity of records" do
        expect(paginated_records.count).to eq 5
      end

      it "returns record from right page" do
        expected_record = described_class.all[5..9]
        expect(paginated_records).to eq expected_record
      end
    end

    context "when :page and :length are fulfilled and does not fit records size"  do
      let(:paginated_records) { described_class.paginate(2, 30) }

      it "does not return any record" do
        expect(paginated_records.count).to eq 0
      end

      it "returns empty result" do
        expect(paginated_records).to_not be_present
      end
    end
  end
  context "when pages does not fix page size" do
    let!(:records) { create_list(factory_name, 7)}

    context "when :page and :length are empty" do
      let(:paginated_records) { described_class.paginate(nil, nil) }

      it "returns default 7 records" do
        expect(paginated_records.count).to eq 7
      end

      it "matches first 7 records" do
        expected_record = described_class.all[0..6]
        expect(paginated_records).to eq expected_record
      end
    end

    context "when :page is fulfilled and :length is empty" do
      let(:paginated_records) { described_class.paginate(2, nil) }

      it "returns right quantity of records" do
        expect(paginated_records.count).to eq 0
      end

      it "returns records from right page" do
        expect(paginated_records).to_not be_present
      end
    end

    context "when :page and :length are fulfilled " do
      let(:paginated_records) { described_class.paginate(2, 5) }

      it "returns right quantity of records" do
        expect(paginated_records.count).to eq 2
      end

      it "returns records from right page" do
        expected_record = described_class.all[5..6]
        expect(paginated_records).to eq expected_record
      end
    end
  end
end