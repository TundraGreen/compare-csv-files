# compare_csv_files.rb
# © 2021 William Prescott
# 2021-05-21

require 'csv'

### ##################################################################################
def main
  params = process_command_line_arguments
  ignore = params['ignore']
  key_name = params['key_name']
  old_file_path = params['old_file_path']
  new_file_path = params['new_file_path']
  old_table = read_data(old_file_path)
  new_table = read_data(new_file_path)
  common_rows = difference_records(old_file_path, new_file_path, old_table, new_table, key_name)
  difference_fields(old_file_path, new_file_path, old_table, new_table, ignore, key_name, common_rows)
  print "\n"
end

### ##################################################################################
def create_hash(table, key_name)
  hash_table = {}
  table.by_row!()
  (0...table.length).each do |index|
#     print 'table[index][key_name]: ', table[index][key_name],"\n"
#     print 'table[index]: ', table[index].to_h,"\n"
    hash_table[table[index][key_name]] = table[index].to_h
  end
  return hash_table
end

### ##################################################################################
def difference_fields(old_file_path, new_file_path, old_table, new_table, ignore, key_name, common_rows)
  common_columns = old_table.headers & new_table.headers
  old_hash = create_hash(old_table, key_name)
  new_hash = create_hash(new_table, key_name)
  print "Common columns: #{common_columns.length}\n"
  print "Differences:\n"
  common_columns.each do |column|
    next if ignore.include?(column)
    common_rows.each do |row|
      if old_hash[row][column] != new_hash[row][column]
        print "record: #{row}, field: #{column}\n"
        print "  old_value: ->#{old_hash[row][column]}<-\n"
        print "  new_value: ->#{new_hash[row][column]}<-\n"
      end
    end
  end
end

### ##################################################################################
def difference_records(old_file_path, new_file_path, old_table, new_table, key_name)
  old_array = old_table[key_name]
  new_array = new_table[key_name]
  new_old = new_array - old_array

  old_new = old_array - new_array
  common_rows = old_array & new_array

  print "Old file: #{old_file_path}\n"
  print "  Old count: #{old_array.length}\n"

  print "New file: #{new_file_path}\n"
  print "  New count: #{new_array.length}\n"

  print_record_differences('Losses: ', old_new)
  print_record_differences('Gains: ',  new_old)
  print_record_differences('Common rows: ', common_rows)
  return common_rows
end

### ##################################################################################
def print_record_differences(type, id_list)
  print type, ": ", id_list.length, "\n"
  print "  ", id_list, "\n" if type != 'Common rows: '
end

### ##################################################################################
def print_usage
  print "Author: William H. Prescott\n"
  print "Date: 2021-05-21\n"
  print "Version: 1.0\n"
  print "\n"
  print "Usage: ruby compare_csv_files.rb [options]\n"
  print "\n"
  print "Options:\n"
  print "  -1, --first    - first_file_path - first file (required)\n"
  print "  -2, --second   - second_file_path - second file (required)\n"
  print "  -h, --help     - print these notes\n"
  print "  -i, --ignore   - comma separated list of field names to ignore when differencing (no_spaces)\n"
  print "  -k, --key_name - name of column containing a unique id (required for records, defaults to 'id')\n"
  print "\n"
  print "Note 0: files must have a header row including the name of the key field.\n"
  print "Note 1: if -r and -f are both specified the last one is used.\n"
  print "Note 2: for -f compare, the two files must contain the same number of records in the same order.\n"
  print "\n"
  print "Examples: ruby compare_csv_files.rb [options]\n"
  print "ruby compare_csv_files.rb -1 test1.csv -2 test2.csv -f -i 'updated_at,primary_county' -k id\n"
  print "ruby compare_csv_files.rb -1 test1.csv -2 test2.csv -f -k id\n"
  print "ruby compare_csv_files.rb -1 test3.csv -2 test2.csv -r -k id\n"
  print "\n"
end

### ##################################################################################
def process_command_line_arguments
  index = 0
  while index < ARGV.length do
    case ARGV[index]
    when '-1', '--first'
      index += 1
      old_file_path = ARGV[index]
      index += 1
    when '-2', '--second'
      index += 1
      new_file_path = ARGV[index]
      index += 1
    when '-h', '--help'
      print_usage
      exit
    when '-i', '--ignore'
      index += 1
      ignore = ARGV[index].gsub(/\s/,'').split(/,/)
      index += 1
    when '-k', '--key_name'
      index += 1
      key_name = ARGV[index]
      index += 1
    else
      print_usage
      index += 1
    end
  end
  if old_file_path.nil? || old_file_path.nil?
    print "File paths required. Exiting...\n"
    print_usage
    exit
  end
  request_type = request_type.nil? ? 'fields' : request_type
  key_name = key_name.nil? ? 'id' : key_name
  ignore = ignore.nil? ? [] : ignore
  return {
    'key_name' => key_name,
    'ignore' => ignore,
    'old_file_path' => old_file_path,
    'new_file_path' => new_file_path
  }
end

### ##################################################################################
def read_data(file_path)
  table = CSV.parse(File.read(file_path), headers: true)
end

### ##################################################################################
main

