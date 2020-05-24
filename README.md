# Citrix users from NagiosXI Widget for [Smashing](https://smashing.github.io)

[Smashing](https://smashing.github.io) widget to monitor the total number of Citrix users connected and disconected from Nagios XI.
This works if you have multiple XEN Servers in your environment and all share in Nagios and they are monitored with the custom script that returns performance data for connected users and disconnected users. 

link to the script TODO

The numbers in the tiles represent the following:

* Total Connected users
* Total Disconnected | Maximum connected in a single server


## Example
![citrix](https://github.com/lucapxl/smashing_widget_nagiosxi_citrix_users/blob/master/images/example.png)

## Installation and Configuration
This widget uses `open-uri` and `json`. make sure to add them in your dashboard Gemfile
```Gemfile
gem 'open-uri'
gem 'json'
```

and to run the update command to download and install them.

```bash
$ bundle update
```

Create a ```citrixusers``` folder in your ```/widgets``` directory and clone this repository inside it. make a symolic link of the file ```jobs/citrixusers.rb``` in the ```/jobs/``` directory of your dashboard. For example, if your smashing installation directory is in ```/opt/dashboard/``` you would run this:
```Shell
$ ln -s /opt/dashboard/widgets/citrixusers/jobs/citrixusers.rb /opt/dashboard/jobs/citrixusers.rb
```

configure `citrixusers.rb` job file for your environment:

```ruby
apiKey = 'xxxxxxx' # The API Key generated in your Nagios XI
nagiosHOST = 'your.nagiosxihost.name' # IP Address or Hostname of your Nagios XI server
serviceName = 'Citrix Users'
```

add the tiles in your dashboard .erb file

```html
    <li data-row="3" data-col="2" data-sizex="1" data-sizey="1">
      <div data-id="citrixusers" data-view="Citrixusers" data-title="Citrix Users"></div>
    </li>
```

## License

Distributed under the MIT license