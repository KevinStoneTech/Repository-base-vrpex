local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local logAdminEstoque = "https://discord.com/api/webhooks/1059548748600062002/pasHT3p82Q_dTdEWCZ996-MP1OY8DMPGaS_VaE-hLMQp2WyTt1bgwpV-6WVcG4U1DhAL" -- OK 01/2023
local logAdminWhitelist = "https://discord.com/api/webhooks/1059549344354807818/IbMYvE_nzZ-YkoVXXGeqhidpu175xJGbNk21HMMiS5b8WAltn0xpjnyAV8PGgl6v0S5i"
local logAdminKick = "https://discord.com/api/webhooks/1059549505361555566/72aQyUvZ4cnzFgdzbOSy1Tjbe5y8WqLRbMqxPlczhskz6-xZtFGdr0Y9pHhqeVht8fmt"
local logAdminMoney = "https://discord.com/api/webhooks/1059550528738168853/vHSmlLQm186gFJt_067VhGqHIsG0WIwpGaWuY8zhhnFYNW3f5P469jzXYjCZzIZWwHJA"
local logAdminConce = "https://discord.com/api/webhooks/1059550814953283654/V9u8RELBUN_ZcnfjCxfBF_b1zwRZ1Yrldtg5Efe-Y8WCtffxlRa0X13gpdYvRzdT9JOJ"
local logAdminGod = "https://discord.com/api/webhooks/1059551541155082361/YffJt7_2p3BaFkw8G0Zgh9FDgG2-IQPsU2uT6QQ9bwrUuunwNKJ9KQtpMgZyytPfZFNe" -- CRIAR SCRIPT PARA GERAR LOGS
local logAdminRemcar = "https://discord.com/api/webhooks/1059552217054580828/YrYBgbdO_Jc9kobvguD4fxqtXRu8tVsK-Mq1L44OxyTOgYTOkTrvDNhBkDcyFvtPyMfI"
local logAdminArmas = ""
local logAdminApagao = ""
local logAdminGeral = ""
local logAdminTime = ""
local logAdminServerStart = "https://discord.com/api/webhooks/1061405418884177940/4bqnP78rD4cU9Jup0puUEsCAReDfy0XknO9TNrh5jIHEzInED42yeg4LTiY45LNoalOh" -- OK STONE
local webhooktempban = "https://discord.com/api/webhooks/1064693813832065034/g50oREyHdBhWCqlT8QHH1BK2f-kgd8i_4KZAbOVdgnIZEndfqNjUWsWQdBHQFIBhhZ1o"


function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end


--------------------------------------------------START SERVER----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    PerformHttpRequest(logAdminServerStart, function(err, text, headers) end, 'POST', json.encode({
        content = '||@everyone||',
        embeds = {
            {
                description = '**SERVIDOR ONLINE:**\n\nAperte F8 e colete: *connect 127.0.0.1',
                color = 2723266 -- Se quiser mudar a cor é aqui
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end)
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR COLOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('carcolor',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local vehicle = vRPclient.getNearestVehicle(source,7)
        if vehicle then
            local rgb = vRP.prompt(source,"RGB Color(255 255 255):","")
            rgb = sanitizeString(rgb,"\"[]{}+=?!_()#@%/\\|,.",false)
            local r,g,b = table.unpack(splitString(rgb," "))
            TriggerClientEvent('vcolorv',source,vehicle,tonumber(r),tonumber(g),tonumber(b))
            TriggerClientEvent('Notify',source,"sucesso","Cor Alterada")
        end
    end
end) 
-----------------------------------------------------------------------------------------------------------------------------------------
--[ VROUPAS ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local player_customs = {}
RegisterCommand('vroupas',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
	local custom = vRPclient.getCustomization(source)
	
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"tpway.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
        if player_customs[source] then
            player_customs[source] = nil
            vRPclient._removeDiv(source,"customization")
        else 
			local content = ""
			
            for k,v in pairs(custom) do
                content = content..k.." => "..json.encode(v).."<br/>" 
            end

            player_customs[source] = true
            vRPclient._setDiv(source,"customization",".div_customization{ margin: auto; padding: 4px; width: 250px; margin-top: 200px; margin-right: 50px; background: rgba(15,15,15,0.7); color: #ffff; font-weight: bold; }",content)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ BLIPS ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        blips[source] = { source }
       TriggerClientEvent("blips:updateBlips",-1,blips)
        if vRP.hasPermission(user_id,"mindmaster.permissao") then
            TriggerClientEvent("blips:adminStart",source)
        end
     end
 end)

AddEventHandler("playerDropped",function()
	if blips[source] then
		blips[source] = nil
		TriggerClientEvent("blips:updateBlips",-1,blips)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARSENAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('armas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if user_id then
		if args[1] == "kit" and vRP.hasPermission(user_id,"admin.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_STUNGUN"] = { ammo = 0 }})
			vRPclient.giveWeapons(source,{["WEAPON_NIGHTSTICK"] = { ammo = 0 }})
			vRPclient.giveWeapons(source,{["WEAPON_FLASHLIGHT"] = { ammo = 0 }})
			vRPclient.giveWeapons(source,{["WEAPON_BAT"] = { ammo = 0 }})
			vRPclient.giveWeapons(source,{["WEAPON_FIREWORK"] = { ammo = 100 }})
			vRPclient.setArmour(source,100)

			PerformHttpRequest(logAdminArmas, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 
						title = "REGISTRO DE ARMAS:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						thumbnail = {
						url = "https://i.ibb.co/sPXYXwq/kstech2023.png"
						}, 
						fields = {
							{ 
								name = "**Quem pegou:**", 
								value = "` "..user_id.." ` "
							},
							{ 
								name = "**Tipo:**", 
								value = "` "..args[1].." ` "
							},
						}, 
						footer = { 
							text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
							icon_url = "" 
						},
						color = 941511 
					}
				}
			}), { ['Content-Type'] = 'application/json' })

		elseif args[1] == "limpar" and vRP.hasPermission(user_id,"admin.permissao") then
			vRPclient.giveWeapons(source,{},true)
			vRPclient.setArmour(source,0)
		elseif vRP.hasPermission(user_id,"admin.permissao") then
			TriggerClientEvent("Notify",source,"negado","Armamento não encontrado.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ESTOQUE ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('estoque',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] and args[2] then
            vRP.execute("creative/set_estoque",{ vehicle = args[1], quantidade = args[2] })
			TriggerClientEvent("Notify",source,"sucesso","Você colocou mais <b>"..args[2].."</b> no estoque, para o carro <b>"..args[1].."</b>.") 
			
			PerformHttpRequest(logAdminConce, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 
						title = "REGISTRO DE CONCE:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						thumbnail = {
						url = "https://i.ibb.co/sPXYXwq/kstech2023.png"
						}, 
						fields = {
							{ 
								name = "**Quem adicionou:**", 
								value = "` "..user_id.." ` "
							},
							{ 
								name = "**Veiculo:**", 
								value = "` "..args[1].." ` "
							},
							{ 
								name = "**Quantidade:**", 
								value = "` "..args[2].." ` "
							}
						}, 
						footer = { 
							text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
							icon_url = "" 
						},
						color = 941511 
					}
				}
			}), { ['Content-Type'] = 'application/json' })
			
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USER VEHS [ADMIN]
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('veiculos',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
        	local nuser_id = parseInt(args[1])
            if nuser_id > 0 then 
                local vehicle = vRP.query("creative/get_vehicle",{ user_id = parseInt(nuser_id) })
                local car_names = {}
                for k,v in pairs(vehicle) do
                	table.insert(car_names, "<b>" .. vRP.vehicleName(v.vehicle) .. "</b>")
                    --TriggerClientEvent("Notify",source,"importante","<b>Modelo:</b> "..v.vehicle,10000)
                end
                car_names = table.concat(car_names, ", ")
                local identity = vRP.getUserIdentity(nuser_id)
                TriggerClientEvent("Notify",source,"importante","Veículos de <b>"..identity.name.." " .. identity.firstname.. " ("..#vehicle..")</b>: "..car_names,10000)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ADICIONAR CARRO ]--------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('addcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserId(parseInt(args[2]))
    if vRP.hasPermission(user_id,"addcar.permissao") then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(nuser_id)
            vRP.execute("creative/add_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time()) })
            TriggerClientEvent("Notify",source,"sucesso","Você adicionou o veículo <b>"..args[1].."</b> para o Passaporte: <b>"..parseInt(args[2]).."</b>.") 
			
			local nomeCar = args[1]
			local quantCar = parseInt(args[2])

			PerformHttpRequest(logAdminEstoque, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 
						title = "REGISTRO DE ADDCAR:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						thumbnail = {
						url = "https://i.ibb.co/sPXYXwq/kstech2023.png"
						}, 
						fields = {
							{ 
								name = "**Quem adicionou:**", 
								value = "` "..identity.name.." "..identity.firstname.." ` "
							},
							{ 
								name = "**Nº de Passaporte:**", 
								value = "` "..user_id.." ` "
							},
							{ 
								name = "**Carro adicionado:**", 
								value = "` "..nomeCar.." ` "
							},
							{ 
								name = "**Quantidade adicionada:**", 
								value = "` "..quantCar.." `\n⠀"
							}
						}, 
						footer = { 
							text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
							icon_url = "https://i.ibb.co/sPXYXwq/kstech2023.png" 
						},
						color = 941511 
					}
				}
			}), { ['Content-Type'] = 'application/json' })
			

        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ REMOVER CARRO ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('remcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserId(parseInt(args[2]))
    if vRP.hasPermission(user_id,"rem.permissao") then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(nuser_id)
            vRP.execute("creative/rem_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time())  }) 
            TriggerClientEvent("Notify",source,"sucesso","Você removeu o veículo <b>"..args[1].."</b> do Passaporte: <b>"..parseInt(args[2]).."</b>.") 
			
			local nomeCar = args[1]
			local quantCar = parseInt(args[2])

			PerformHttpRequest(logAdminRemcar, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 
						title = "REGISTRO DE REMCAR:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						thumbnail = {
						url = "https://i.ibb.co/sPXYXwq/kstech2023.png"
						}, 
						fields = {
							{ 
								name = "**Quem removeu:**", 
								value = "` "..identity.name.." "..identity.firstname.." ` "
							},
							{ 
								name = "**Nº de Passaporte:**", 
								value = "` "..user_id.." ` "
							},
							{ 
								name = "**Carro removido:**", 
								value = "` "..nomeCar.." ` "
							},
							{ 
								name = "**Quantidade removida:**", 
								value = "` "..quantCar.." `\n⠀"
							}
						}, 
						footer = { 
							text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
							icon_url = "https://i.ibb.co/sPXYXwq/kstech2023.png" 
						},
						color = 941511 
					}
				}
			}), { ['Content-Type'] = 'application/json' })

        end
    end
end)

--[ GOD ]----------------------------------------------------------------------------------------------------------------------------

RegisterCommand('god',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admim.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"mindmaster.permissao") then
    	local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
            	vRPclient.killGod(id)
				vRPclient.setHealth(id,400)
            end
		end
		
		PerformHttpRequest(logAdminGod, function(err, text, headers) end, 'POST', json.encode({
			embeds = {
				{ 	------------------------------------------------------------
					title = "REGISTRO DE GOD⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
					thumbnail = {
						url = "https://i.ibb.co/sPXYXwq/kstech2023.png"
					}, 
					fields = {
						{ 
							name = "**COLABORADOR DA EQUIPE:**",
							value = "` "..identity.name.." "..identity.firstname.." `\n"

						},
						------------------------------------------------------------
						{ 
							name = "**ID:**", 
							value = "` "..user_id.." ` "
						}
						-------------------------------------------------------------
					}, 
					footer = { 
						text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),
						icon_url = "https://i.ibb.co/sPXYXwq/kstech2023.png"
					},
					color = 15906321 
				}
			}
		}), { ['Content-Type'] = 'application/json' })
    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ Desasgemar ]------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('desalgemar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(args[1]) then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                TriggerClientEvent("admcuff",nplayer,args[2])
				if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
					TriggerClientEvent("Notify",source,"sucesso","Você desalgemou o ID:"..args[1])
				end
			end
		end
	end
end)
--------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pon',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao")  or vRP.hasPermission(user_id,"leif.permissao")  or vRP.hasPermission(user_id,"mod.permissao") then
        local users = vRP.getUsers()
        local players = ""
        local quantidade = 0
        for k,v in pairs(users) do
            if k ~= #users then
                players = players..","
            end

            players = players..k
            quantidade = quantidade + 1
        end
        TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{0,150,255},quantidade)
        TriggerClientEvent('chatMessage',source,"ID's ONLINE",{0,150,255},players)
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ Algemar ]------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('algemar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(args[1]) then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                TriggerClientEvent("admcuff2",nplayer,args[2])
				if vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
					TriggerClientEvent("Notify",source,"aviso","Você algemou o ID:"..args[1])
				end
			end	
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ SYNCAREA ]----------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('area',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local x,y,z = vRPclient.getPosition(source)
    if vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"mindmaster.permissao") then
        TriggerClientEvent("syncarea",-1,x,y,z)
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ APAGAO ]------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('apagao',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id,"moderador.permissao") and args[1] ~= nil then
            local cond = tonumber(args[1])
            --TriggerEvent("cloud:setApagao",cond)
            TriggerClientEvent("cloud:setApagao",-1,cond)                    
        end
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ RAIOS ]-------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('raios', function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id,"moderador.permissao") and args[1] ~= nil then
            local vezes = tonumber(args[1])
            TriggerClientEvent("cloud:raios",-1,vezes)           
        end
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ TROCAR SEXO ]--------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('skinhanha',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"mindmaster.permissao") then
        if parseInt(args[1]) then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                TriggerClientEvent("skinmenu",nplayer,args[2])
                TriggerClientEvent("Notify",source,"sucesso","Você setou a skin <b>"..args[2].."</b> no passaporte <b>"..parseInt(args[1]).."</b>.")
            end
        end
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ DEBUG ]-------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('debug',function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		if vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
			TriggerClientEvent("ToggleDebug",player)
			TriggerClientEvent("Notify",source,"sucesso","Debug")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRYDELETEOBJ ]-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteobj")
AddEventHandler("trydeleteobj",function(index)
    TriggerClientEvent("syncdeleteobj",-1,index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ FIX ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('fix',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local vehicle = vRPclient.getNearestVehicle(source,11)
	if vehicle then
		if vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"fix.permissao") then
			TriggerClientEvent('reparar',source)
			TriggerClientEvent("Notify",source,"sucesso","Você reparou o veiculo!")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MATAR ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('matar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"ademiro.permissao") or vRP.hasPermission(user_id,"mindmaster.permissao") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.killGod(nplayer)
				vRPclient.setHealth(nplayer,0)
				
                TriggerClientEvent("resetBleeding",nplayer)
				TriggerClientEvent("resetDiagnostic",nplayer)

				TriggerClientEvent("Notify",source,"sucesso","Você matou o ID: "..args[1])

				vRP.varyThirst(nplayer,-15)
				vRP.varyHunger(nplayer,-15)
            end
        else
            vRPclient.killGod(source)
			vRPclient.setHealth(source,0)

			vRP.varyThirst(source,-100)
			vRP.varyHunger(source,-100)
			TriggerClientEvent("Notify",source,"sucesso","Você se matou!")

            TriggerClientEvent("resetBleeding",source)
            TriggerClientEvent("resetDiagnostic",source)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAR INVENTARIO mindmaster.permissao
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limparinv',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"moderador.permissao") then
        vRP.clearInventory(user_id)
        TriggerClientEvent("Notify",source,"importante","Seu <b>inventario</b> foi limpado.")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ REVIVER ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('god',function(source,args,rawCommand)
--     local user_id = vRP.getUserId(source)
--     if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"mindmaster.permissao") then
--         if args[1] then
--             local nplayer = vRP.getUserSource(parseInt(args[1]))
--             if nplayer then
--                 vRPclient.killGod(nplayer)
-- 				vRPclient.setHealth(nplayer,400)
				
--                 TriggerClientEvent("resetBleeding",nplayer)
-- 				TriggerClientEvent("resetDiagnostic",nplayer)

-- 				vRP.varyThirst(nplayer,-15)
-- 				vRP.varyHunger(nplayer,-15)
--             end
--         else
--             vRPclient.killGod(source)
-- 			vRPclient.setHealth(source,400)

-- 			vRP.varyThirst(source,-100)
-- 			vRP.varyHunger(source,-100)

--             TriggerClientEvent("resetBleeding",source)
--             TriggerClientEvent("resetDiagnostic",source)
--         end
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ GOD ALL ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('godall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mindmaster.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
    	local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
            	vRPclient.killGod(id)
				vRPclient.setHealth(id,400)
				print(id)

				TriggerClientEvent("Notify",source,"sucesso","Restaurada vida de todos players!")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ HASH ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('hash',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"moderador.permissao") then
		TriggerClientEvent('vehash',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TUNING ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tuning',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"moderador.permissao") then
		TriggerClientEvent('vehtuning',source)
		TriggerClientEvent("Notify",source,"sucesso","Veiculo TUNADO!")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ WL ]---------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('wl',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"wl.permissao") then
        if args[1] then
            vRP.setWhitelisted(parseInt(args[1]),true)
            TriggerClientEvent("Notify",source,"sucesso","Você aprovou o passaporte <b>"..args[1].."</b> na whitelist.")
			
			local idwhite = parseInt(args[1])

			PerformHttpRequest(logAdminWhitelist, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 
						title = "REGISTRO DE WHITELIST:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						thumbnail = {
						url = "https://i.ibb.co/sPXYXwq/kstech2023.png"
						}, 
						fields = {
							{ 
								name = "**Quem adicionou:**", 
								value = "` "..identity.name.." "..identity.firstname.." ` "
							},
							{ 
								name = "**Nº de Passaporte:**", 
								value = "` "..user_id.." ` "
							},
							{ 
								name = "**ID adicionado a Whitelist:**", 
								value = "` "..idwhite.." ` "
							}
						}, 
						footer = { 
							text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
							icon_url = "https://i.ibb.co/sPXYXwq/kstech2023.png" 
						},
						color = 941511 
					}
				}
			}), { ['Content-Type'] = 'application/json' })

        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ UNWL ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unwl',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"unwl.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"mindmaster.permissao") then
		if args[1] then
			vRP.setWhitelisted(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Você retirou o passaporte <b>"..args[1].."</b> da whitelist.")
			
			local idwhite = parseInt(args[1])

			PerformHttpRequest(logAdminWhitelist, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 
						title = "REGISTRO DE WHITELIST:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						thumbnail = {
						url = "https://i.ibb.co/sPXYXwq/kstech2023.png"
						}, 
						fields = {
							{ 
								name = "**Quem removeu:**", 
								value = "` "..identity.name.." "..identity.firstname.." ` "
							},
							{ 
								name = "**Nº de Passaporte:**", 
								value = "` "..user_id.." ` "
							},
							{ 
								name = "**ID removido da Whitelist:**", 
								value = "` "..idwhite.." ` "
							}
						}, 
						footer = { 
							text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
							icon_url = "https://i.ibb.co/sPXYXwq/kstech2023.png" 
						},
						color = 941511 
					}
				}
			}), { ['Content-Type'] = 'application/json' })

		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ KICK ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kick',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"kick.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"mindmaster.permissao") then
		if args[1] then
			local id = vRP.getUserSource(parseInt(args[1]))
			if id then
				vRP.kick(id,"Você foi expulso da cidade.")
				TriggerClientEvent("Notify",source,"sucesso","Você kickou o passaporte <b>"..args[1].."</b> da cidade.")
				
				local kikado = parseInt(args[1])

				PerformHttpRequest(logAdminKick, function(err, text, headers) end, 'POST', json.encode({
					embeds = {
						{ 
							title = "REGISTRO DE KICKS:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
							thumbnail = {
							url = "https://i.ibb.co/sPXYXwq/kstech2023.png"
							}, 
							fields = {
								{ 
									name = "**Quem kickou:**", 
									value = "` "..identity.name.." "..identity.firstname.." ` "
								},
								{ 
									name = "**Nº de Passaporte:**", 
									value = "` "..user_id.." ` "
								},
								{ 
									name = "**ID que foi kickado:**", 
									value = "` "..kikado.." ` "
								}
							}, 
							footer = { 
								text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
								icon_url = "https://i.ibb.co/sPXYXwq/kstech2023.png" 
							},
							color = 941511 
						}
					}
				}), { ['Content-Type'] = 'application/json' })

			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ban',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"kick.permissao") then
        if args[1] then
            local id = vRP.getUserSource(parseInt(args[1]))
            local t_user_id = vRP.getUserSource(parseInt(args[1]))

			vRP.setBanned(parseInt(args[1]),true)
			vRP.kick(t_user_id,"Você foi banido! [ Mais informações em: discord.gg/url ]")
			TriggerClientEvent("Notify",source,"sucesso","Voce baniu o passaporte <b>"..args[1].."</b> da cidade.")

			PerformHttpRequest(webhookadmin, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 
						title = "REGISTRO DE BANIMENTO:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						thumbnail = {
						url = ""
						}, 
						fields = {
							{ 
								name = "**QUEM FOI BANIDO:**", 
								value = "` ["..t_user_id.."] `"
							},
							{ 
								name = "**QUEM BANIU:**", 
								value = "` "..identity.name.." "..identity.firstname.." ["..user_id.."] `"
							}
						}, 
						footer = { 
							text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
							icon_url = "" 
						},
						color = 0225500 
					}
				}
			}), { ['Content-Type'] = 'application/json' })
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"unban.permissao") then
		if args[1] then
            vRP.setBanned(parseInt(args[1]),false)
            TriggerClientEvent("Notify",source,"sucesso","Voce desbaniu o passaporte <b>"..args[1].."</b> da cidade.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MONEY ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('money',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"money.permissao") or vRP.hasPermission(user_id,"daledoledale.permissao") then
		if args[1] then
			vRP.giveMoney(user_id,parseInt(args[1]))

			PerformHttpRequest(logAdminMoney, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 
						title = "REGISTRO DE MONEY:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
						thumbnail = {
						url = "https://i.ibb.co/sPXYXwq/kstech2023.png"
						}, 
						fields = {
							{ 
								name = "**Quem pegou:**", 
								value = "` "..user_id.." ` "
							},
							{ 
								name = "**Quantidade:**", 
								value = "` "..args[1].." ` "
							},
						}, 
						footer = { 
							text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
							icon_url = "https://i.ibb.co/sPXYXwq/kstech2023.png" 
						},
						color = 941511 
					}
				}
			}), { ['Content-Type'] = 'application/json' })

		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ NC ]---------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('nc',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"nc.permissao") then
		vRPclient.toggleNoclip(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ NC 2 SOMENTE ADM ]---------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('nc2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then -- or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"nc.permissao")
		vRPclient.toggleNoclip(source)
		TriggerClientEvent('efeitinholgbt',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TPCDS ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpcds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		local fcoords = vRP.prompt(source,"Cordenadas:","")
		if fcoords == "" then
			return
		end
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end
		vRPclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ COORDENADAS ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		heading = GetEntityHeading(GetPlayerPed(-1))
		vRP.prompt(source,"Cordenadas:","['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z))
	end
end)

RegisterCommand('cds2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:",tD(x)..","..tD(y)..","..tD(z))
	end
end)

RegisterCommand('cds3',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:","{x="..tD(x)..", y="..tD(y)..", z="..tD(z).."},")
	end
end)

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ GROUP ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('group',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mindmaster.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		if args[1] and args[2] then
			vRP.addUserGroup(parseInt(args[1]),args[2])
			TriggerClientEvent("Notify",source,"sucesso","Você setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.")
			SendWebhookMessage(logAdminGeral,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ UNGROUP ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
--------[ UNGROUP  ]---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

RegisterCommand('ungroup',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mindmaster.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
        if args[1] and args[2] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRP.removeUserGroup(parseInt(args[1]),args[2])
                TriggerClientEvent("Notify",source,"sucesso","Voce removeu o passaporte <b>"..parseInt(args[1]).."</b> do grupo <b>"..args[2].."</b>.")
            else
                local data = vRP.getUserDataTable(parseInt(args[1]))
                if data.groups then
                    data.groups[args[2]] = nil
                end
                vRP.setUData(parseInt(args[1]),"vRP:datatable",json.encode(data)).
                TriggerClientEvent("Notify",source,"sucesso","Voce removeu o passaporte <b>"..parseInt(args[1]).."</b> do grupo <b>"..args[2].."</b>.")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TPTOME ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tptome',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"tpto.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			local x,y,z = vRPclient.getPosition(source)
			if tplayer then
				vRPclient.teleport(tplayer,x,y,z)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TPTO ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpto',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"tpto.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			if tplayer then
				vRPclient.teleport(source,vRPclient.getPosition(tplayer))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TPWAY ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpway',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"tpway.permissao")then
		TriggerClientEvent('tptoway',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DELNPCS ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('npc',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao")then
		TriggerClientEvent('delnpcs',source)
		TriggerClientEvent("Notify",source,"sucesso","Você removeu os NPCS")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ PLAYERSON ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cidadao',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
        local users = vRP.getUsers()
        local players = ""
        local quantidade = 0
        for k,v in pairs(users) do
            if k ~= #users then
                players = players..", "
            end
            players = players..k
            quantidade = quantidade + 1
        end
        TriggerClientEvent('chatMessage',source,"TOTAL: ",{29, 100, 242},quantidade)
        TriggerClientEvent('chatMessage',source,"ID's: ",{29, 100, 242},players)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCOLETE Função: colocar colete em alguém ou si colocar colete
-------------------------------------------------------------------------
RegisterCommand('acolete',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.setArmour(nplayer,100)
                TriggerClientEvent("Notify",source,"Sucesso","Voce adicionou colete no passaporte <b>"..args[1].."</b>.")
            end
        else
            vRPclient.setArmour(source,100)
            TriggerClientEvent("Notify",source,"Sucesso","Voce si adicionou colete.")
        end
    end
end)

--------------------------------------------------------------------------
---- RG2 para ADMINISTRADOR ----------------------------------------------
--------------------------------------------------------------------------
-- RG2 ADMIN
RegisterCommand('rg2',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local nuser_id = parseInt(args[1])
        local identity = vRP.getUserIdentity(nuser_id)
        local bankMoney = vRP.getBankMoney(nuser_id)
        local walletMoney = vRP.getMoney(nuser_id)
        local sets = json.decode(vRP.getUData(nuser_id,"vRP:datatable"))
		

        if args[1] then	
           TriggerClientEvent("Notify",source,"Importante","ID: <b>"..parseInt(nuser_id).."</b><br>Nome: <b>"..identity.name.." "..identity.firstname.."</b><br>Idade: <b>"..identity.age.."</b><br>Telefone: <b>"..identity.phone.."</b><br>Carteira: <b>"..vRP.format(parseInt(walletMoney)).."</b><br>Banco: <b>"..vRP.format(parseInt(bankMoney)).."</b><br>Sets: <b>"..json.encode(sets.groups).."</b>",5000)
        else
            TriggerClientEvent("Notify",source,"Negado","Digite o ID desejado!")


        end
    end
end)

--------------------------------------------------------------------------
---- TEMPBAN -------------------------------------------------------------
--------------------------------------------------------------------------

function getTimeFunction(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)
    seconds = seconds - hours * 3600
    local minutes = math.floor(seconds/60)
    seconds = seconds - minutes * 60
	
	local segundos = "SEGUNDO"
	local minutos = "MINUTO"
    
	if seconds > 1 then
		segundos = "SEGUNDOS"
	end
	if seconds > 1 then
		minutos = "MINUTOS"
	end
	if days > 0 then
        return days.." DIA(S) "..hours.." HORA(S) "..minutes.." MINUTO(S) E "..string.format("%.f",seconds).." "..segundos
    elseif hours > 0 then
        return hours.." HORA "..minutes.." "..minutos.." E "..string.format("%.f",seconds).." "..segundos
    elseif minutes > 0 then
        return minutes.." "..minutos.." E "..string.format("%.f",seconds).." "..segundos
    elseif seconds > 0 then
        return string.format("%.f",seconds).." "..segundos
    end
end

vRP.prepare("alek/getTempban", "SELECT * FROM alek_tempban WHERE user_id = @user_id")
vRP.prepare("alek/addTempban"," INSERT IGNORE INTO alek_tempban(user_id,tempban,motivo) VALUES(@user_id,@tempban,@motivo)")
vRP.prepare("alek/remTempban"," DELETE FROM alek_tempban WHERE user_id = @user_id")
vRP.prepare("alek/setTempban","UPDATE alek_tempban SET tempban = @tempban, motivo = @motivo WHERE user_id = @user_id")

RegisterCommand('tempban',function(source,args,rawCommand) --/tempban ID TEMPO
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local nuser_id = vRP.getUserSource(parseInt(args[1]))
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] and args[2] then
			local descricao = vRP.prompt(source,"MOTIVO:","")
			vRP.execute("alek/addTempban",{ user_id = parseInt(args[1])})
			vRP.execute("alek/setTempban",{ user_id = parseInt(args[1]), tempban = os.time()+(parseInt(args[2])*60*60) , motivo = descricao })
			TriggerClientEvent("Notify",source,"sucesso","Voce baniu o passaporte <b>"..args[1].."</b> da cidade.")
			SendWebhookMessage(webhooktempban,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[BANIU]: "..args[1].."  \n[TEMPO]: "..args[2].."  \n[MOTIVO]: "..descricao.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.kick(nuser_id,"Você tomou temp-ban de "..args[2].." horas, Motivo: "..descricao)
			TriggerClientEvent("Notify",source,"sucesso","Voce kikou o passaporte <b>"..args[1].."</b> da cidade.")
		end
	end
end)
AddEventHandler("queue:playerConnecting", function(source,ids,name,setKickReason,deferrals)
	local user_id = vRP.getUserIdByIdentifiers(ids)
	local alektempban,alektempban2 = vRP.query("alek/getTempban", {user_id = user_id})
	if alektempban2 == 1 then
		local tempo = parseInt(tonumber(alektempban[1].tempban))
		if parseInt(tempo) >= parseInt(os.time()) then
			local tempo2 = (parseInt(tempo)-parseInt(os.time()))
			deferrals.done("Você tomou temp-ban, falta: "..getTimeFunction(tempo2).." , Motivo: "..alektempban[1].motivo)
			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
		else
			vRP.execute("alek/remTempban",{ user_id = user_id })
		end
	end
end)
RegisterCommand('remtempban',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"suporte.permissao") then
        if args[1] then
			vRP.execute("alek/remTempban",{ user_id = parseInt(args[1]) })
			TriggerClientEvent("Notify",source,"sucesso","Voce removeu o ID: "..args[1].." do tempban.") 
            SendWebhookMessage(webhooktempban,"```prolog\n[ID]: "..user_id.." \n[REMOVEU ID]: "..args[1].." \n[DO TEMPBAN] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
    end
end)