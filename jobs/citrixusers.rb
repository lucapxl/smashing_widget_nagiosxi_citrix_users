require 'net/http'
require 'open-uri'
require 'json'

########################################################################################################
# make sure you edit these variables to fit your environment
apiKey = 'xxxxxxxxxxxx'
nagiosHOST = 'x.x.x.x'
serviceName = 'Citrix Users'
########################################################################################################

citrixUsersURL = 'http://' + nagiosHOST + '/nagiosxi/api/v1/objects/servicestatus?apikey=' + apiKey + '&name=' + serviceName

SCHEDULER.every "60s", first_in: 0 do |job|
    totalServer = totalActive = totalDisco = totalHung = 0
    
    resp = Net::HTTP.get_response(URI.parse(citrixUsersURL))
    jsonData = resp.body
    citrixUsers = JSON.parse(jsonData)
    citrixUsers['servicestatus'].each do |child|
        active = child['performance_data'][/active=(.*?);;/,1].to_i
        totalActive += active

        disconnected = child['performance_data'][/disconnected=(.*?);;/,1].to_i
        totalDisco += disconnected

        hung = child['performance_data'][/hung=(.*?);;/,1].to_i
        totalHung += hung

        if totalServer < (active + disconnected + hung) 
            totalServer = active + disconnected + hung
        end
    end
    send_event(:citrixusers, active: totalActive, disconnected: totalDisco, hung: totalHung, servermax: totalServer)

end