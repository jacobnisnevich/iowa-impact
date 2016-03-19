require 'json'

precinct_file = File.read('precinct-data.json')
precinct_hash = JSON.parse(precinct_file)["data"]["CountyResults"]

# Setup the column headers
p "County,ClintonDelegates,SandersDelegeates,O'MalleyDelegates,TotalDelegates"

precinct_hash.each do |county_result|
  county_name = county_result["County"]["Name"]
  clinton_delegates = 0
  sanders_delegates = 0
  o_malley_delegates = 0
  total_delegates = county_result["ResultTotal"]

  county_result["Candidates"].each do |candidate_entry|
    candidate = candidate_entry["Candidate"]
    
    # If county result is nil, set vote count to 0
    if candidate["CandidateId"] == 24
      clinton_delegates = candidate_entry["Result"] || 0
    elsif candidate["CandidateId"] == 26
      sanders_delegates = candidate_entry["Result"] || 0
    elsif candidate["CandidateId"] == 25
      o_malley_delegates = candidate_entry["Result"] || 0
    end
  end

  p "#{county_name},#{clinton_delegates},#{sanders_delegates},#{o_malley_delegates},#{total_delegates}"
end
