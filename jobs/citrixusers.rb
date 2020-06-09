require 'rest-client'
require 'json'

########################################################################################################
# make sure you edit these variables to fit your environment
apiKey = 'xxxxxxxxxxxx'
nagiosHOST = 'x.x.x.x'
serviceName = 'Citrix Users'
########################################################################################################

citrixUsersURL = 'https://' + nagiosHOST + '/nagiosxi/api/v1/objects/servicestatus?apikey=' + apiKey + '&name=' + serviceName

SCHEDULER.every "60s", first_in: 0 do |job|
    totalServer = totalActive = totalDisco = totalHung = 0
    citrixUsers = ""
    resp = RestClient::Request.new({
        method: :get,
        url: citrixUsersURL,
        verify_ssl: false
    }).execute do |resp, request, result|
        case resp.code
        when 200
            citrixUsers = JSON.parse(resp.to_str)
        else
            fail "error: #{resp.to_str}"
        end
    end        

    citrixUsers['servicestatus'].each do |child|
        active = child['perfdata'][/active=(.*?);;/,1].to_i
        totalActive += active

        disconnected = child['perfdata'][/disconnected=(.*?);;/,1].to_i
        totalDisco += disconnected

        hung = child['perfdata'][/hung=(.*?);;/,1].to_i
        totalHung += hung

        if totalServer < (active + disconnected + hung) 
            totalServer = active + disconnected + hung
        end
    end
    send_event(:citrixusers, active: totalActive, disconnected: totalDisco, hung: totalHung, servermax: totalServer)

end