reactor = peripheral.wrap("back")
url = "http://127.0.0.1:8000"
ident = 0
headers = {Identifier=tostring(ident)}


function sendData()
    status = reactor.getStatus()

    damagePercent = reactor.getDamagePercent()

    temperature = reactor.getTemperature()
    heatCapacity = reactor.getHeatCapacity()
    coolant = reactor.getCoolant()
    coolantCapacity = reactor.getCoolantCapacity()

    heatedCoolant = reactor.getHeatedCoolant()
    heatedCoolantCapacity = reactor.getHeatedCoolantCapacity()

    fuel = reactor.getFuel()
    fuelCapacity = reactor.getFuelCapacity()

    waste = reactor.getWaste()
    wasteCapacity = reactor.getWasteCapacity()


    burnRate = reactor.getBurnRate()
    actualBurnRate = reactor.getActualBurnRate()
    boilEfficiency = reactor.getBoilEfficiency()
    heatingRate = reactor.getHeatingRate()
    environmentalLoss = reactor.getEnvironmentalLoss()
    table = {ident=ident,status=status,damagePercent=damagePercent,temperature=temperature,heatCapacity=heatCapacity,coolant=coolant,coolantCapacity=coolantCapacity,heatedCoolant=heatedCoolant,heatedCoolantCapacity=heatedCoolantCapacity,fuel=fuel,fuelCapacity=fuelCapacity,waste=waste,wasteCapacity=wasteCapacity,burnRate=burnRate,actualBurnRate=actualBurnRate,boilEfficiency=boilEfficiency,heatingRate=heatingRate,environmentalLoss=environmentalLoss}
    json = textutils.serializeJSON(table)
    --print(json)
    
    http.post(url,json,headers)
end 


function updateData()
    response = http.get(url,headers)
    code,msg = response.getResponseCode()
    if(code==200) then
        data = response.readAll()
        print("receiving") 
        print(data)
    end
    table = textutils.unserialiseJSON(data)
    if(table["status"]) then
        if(not(reactor.getStatus())) then
            reactor.activate()
        end
    else
        if(reactor.getStatus()) then
            reactor.scram()
        end
    end
    reactor.setBurnRate(table["burnRate"])
end
while true  do
    sendData()
    updateData()
    sleep(1) 
end
