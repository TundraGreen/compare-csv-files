# compare-csv-files

    Find the differences between two csv files: either rows present in one and not the other; or, changes in fields where both files have the same rows and columns.

    Author: William H. Prescott
    Date: 2021-05-21
    Version: 1.0

    Usage: ruby compare_csv_files.rb [options]

    Options:
      -1, --first    - first_file_path - first file (required)
      -2, --second   - second_file_path - second file (required)
      -f, --fields   - find differences in fields (default)
      -h, --help     - print these notes
      -i, --ignore   - comma separated list of field names to ignore when differencing (no_spaces)
      -k, --key_name - name of column containing a unique id (required for records, defaults to 'id')
      -r, --records  - find differences in records 

    Note 0: files must have a header row including the name of the key field.
    Note 1: if -r and -f are both specified the last one is used.
    Note 2: for -f compare, the two files must contain the same number of records in the same order.

    Examples: ruby compare_csv_files.rb [options]
    ruby compare_csv_files.rb -1 test1.csv -2 test2.csv -f -i 'updated_at,primary_county' -k id
    ruby compare_csv_files.rb -1 test1.csv -2 test2.csv -f
    ruby compare_csv_files.rb -1 test3.csv -2 test2.csv -r -k id
