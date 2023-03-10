-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("vrp_radio",cnVRP)
vCLIENT = Tunnel.getInterface("vrp_radio")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.activeFrequency(freq)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(freq) >= 1 and parseInt(freq) <= 999 then
			if parseInt(freq) == 190 then
				if vRP.hasPermission(user_id,"policia.permissao") then
					vCLIENT.startFrequency(source,190)
					TriggerClientEvent("Notify",source,"sucesso","Rádio <b>"..parseInt(freq)..".0Mhz</b>.",5000)
				end
			elseif parseInt(freq) == 191 then
				if vRP.hasPermission(user_id,"policia.permissao") then
					vCLIENT.startFrequency(source,191)
					TriggerClientEvent("Notify",source,"sucesso","Rádio <b>"..parseInt(freq)..".0Mhz</b>.",5000)
				end
			elseif parseInt(freq) == 192 then
				if vRP.hasPermission(user_id,"paramedico.permissao") then
					vCLIENT.startFrequency(source,192)
					TriggerClientEvent("Notify",source,"sucesso","Rádio <b>"..parseInt(freq)..".0Mhz</b>.",5000)
				end
			elseif parseInt(freq) == 443 then
				if vRP.hasPermission(user_id,"mecanico.permissao") then
					vCLIENT.startFrequency(source,443)
					TriggerClientEvent("Notify",source,"sucesso","Rádio <b>"..parseInt(freq)..".0Mhz</b>.",5000)
				end
			else
				vCLIENT.startFrequency(source,parseInt(freq))
				TriggerClientEvent("Notify",source,"sucesso","Rádio <b>"..parseInt(freq)..".0Mhz</b>.",5000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKRADIO
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.checkRadio()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"radio") < 1 then
			return true
		end
		return false
	end
end

RegisterCommand("radio", function(source, args)
    TriggerClientEvent("vrp_radio:openSystem",source)
end)