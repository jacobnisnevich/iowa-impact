require 'csv'
require 'liblinear'

training_data = []
training_data_strings = CSV.read("iowa-demographics-norm.csv").each
training_data_strings.each do |row|
  training_data.push(row.collect{ |i| i.to_f })
end

target_data = CSV.read("iowa-delegate-diff.csv").flatten.collect{ |i| i.to_f }

model = Liblinear.train({
  solver_type: Liblinear::L2R_L2LOSS_SVR
}, target_data, training_data)

test_data = []
correct = 0

# Use trained model to compare predictions with actual results
training_data.each_with_index do |training_row, index|
  predicted = Liblinear.predict(model, training_row).round(2)
  actual = target_data[index]

  if (predicted > 0 && actual > 0) || (predicted < 0 && actual < 0)
    correct = correct + 1
  end

  test_data.push({
    :predicted => predicted,
    :actual => actual
  }) 
end

puts "Correct predictions: #{correct / target_data.length.to_f}"

# Output to CSV
csv_string =  "Predicted,Actual\n"
test_data.each do |test|
  csv_string.concat "#{test[:predicted]},#{test[:actual]}\n"
end

File.open("linear-model-predictions.csv", 'w') do |file|
  file.write(csv_string)
end
