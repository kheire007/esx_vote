ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('elec:vote')
AddEventHandler('elec:vote', function(candidate)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local candidate = candidate

  MySQL.Async.execute('UPDATE users SET vote = @vote WHERE identifier = @identifier',{['@identifier'] = xPlayer.getIdentifier(),['@vote'] = candidate })
end)


-- Run this when a user enters a message in chat
AddEventHandler('chatMessage', function(source, name, msg)
    args = stringsplit(msg, " ")
    CancelEvent()
	if args[1] ~= nil then
		if string.find(args[1], "/") then
			local cmd = args[1]
			table.remove(args, 1)	
		else
			-- Sets variable 'player' to the players SteamId
			player = GetPlayerIdentifiers(source)[1]
			-- Fetches all rows from the database table 'users' where the column 'identifier' equals the players SteamId
			local result = MySQL.Sync.fetchAll(
			  'SELECT * FROM users WHERE identifier = @identifier',
			  {
				['@identifier'] = player
			  }
			)
			-- Loops through the result and allows you to call from the database results
			for i=1, #result, 1 do
			
				-- If the resulted user is a superadmin then do the following
				if result[i].group == 'superadmin' then -- ADD EXTRA GROUPS HERE WITH "and result[i].group == ' '"
					-- Loop through the table staff
						TriggerClientEvent('chatMessage', -1, "superadmin | " ..name, {255, 0, 0}, msg)
						CancelEvent()
					--end
				-- If the resulted user is not a superadmin then do the following
				elseif result[i].group == 'admin' then -- ADD EXTRA GROUPS HERE WITH "and result[i].group == ' '"
					-- Loop through the table staff
						TriggerClientEvent('chatMessage', -1, "admin |" .. name, {0, 255, 0}, msg)
						CancelEvent()
					--end
				-- If the resulted user is not a superadmin then do the following
				elseif result[i].group == 'mod' then -- ADD EXTRA GROUPS HERE WITH "and result[i].group == ' '"
					-- Loop through the table staff
						TriggerClientEvent('chatMessage', -1, " mod | " .. name, {0, 0, 255}, msg)
						CancelEvent()
					--end
				-- If the resulted user is not a superadmin then do the following
				else
					-- IF YOU WANT IT TO SAY THEY HAVE INSUFFICIENT PERMISSIONS UNCOMMENT THE NEXT LINE
					--TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions!")
					CancelEvent()
					
				end
			end
		end
	end
end)


function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end