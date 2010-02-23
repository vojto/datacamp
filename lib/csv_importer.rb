class CsvImporter
  attr_reader :file, :errors
  attr_accessor :encoding
  
  def initialize(encoding)
    self.encoding = encoding
  end
  
  def load_file path, separator = ",", header_lines = 0
    @file = CsvFile.new(path, separator, header_lines)
    @file.encoding = self.encoding
    if @file.open
      return true
    else
      @errors << I18n.t("assets.preview.file_not_loaded", :path => @path)
      return false
    end
  end
  
  def import_into_dataset(dataset, column_mapping)
    # Die if no file's open
    raise RuntimeException, "Can't import, no file open" unless @file
    
    # Get dataset description
    @dataset_description = dataset.dataset_description
    @dataset_class = dataset.dataset_record_class
    @field_descriptions = @dataset_description.field_descriptions
    
    # Determine which column is which field
    columns = column_mapping
    
    count = 0
    Go through each line
    puts Time.now
        @file.each(true) do |row|
          record = {}
          columns.each do |i, field_description_id|
            next unless field_description_id
            field_description = @field_descriptions.find_all{|description|description.id.to_i == field_description_id.to_i}[0]
            next unless field_description
            value = row[i.to_i].to_s
            record[field_description.identifier] = value
          end
          count += 1
        end
        puts Time.now
    count
  end
end