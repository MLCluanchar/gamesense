

local anti_aim = require 'gamesense/antiaim_funcs'
local function velocity()
    local me = entity.get_local_player()
    local velocity_x, velocity_y = entity.get_prop(me, "m_vecVelocity")
    return math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)
end
local references = {
    yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    body_yaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
    yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    jitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
}
local vars = {
    y_reversed = 1,
    by_reversed = 1,

    by_vars = 0,
    y_vars = 0,
    chocke = 0

}

local function antiaim_yaw_jitter(a,b)

    if globals.tickcount() - vars.y_vars > 1  then
        vars.y_reversed = vars.y_reversed == 1 and 0 or 1
        vars.y_vars = globals.tickcount()
    end
    return vars.y_reversed >= 1 and a or b
end
local status
client.set_event_callback('setup_command', function(cmd)
    -----------Moving overlap
    if cmd.chokedcommands ~= 0 then return end
    if velocity() < 120 then return end
    if ui.get(references.jitter[2]) < 60 then
        ui.set(references.yaw[2], anti_aim.get_overlap(rotation) > 0.77 and antiaim_yaw_jitter(15,-25) or 0)
    end
    if ui.get(references.jitter[2]) > 60 then
        ui.set(references.yaw[2], anti_aim.get_overlap(rotation) > 0.97 and antiaim_yaw_jitter(15,-25) or 0)
    end
    end)

client.set_event_callback('setup_command', function(cmd)
    -----------Standing overlap
    if cmd.chokedcommands ~= 0 then return end
    if velocity() > 120 then return end
    if ui.get(references.jitter[2]) < 60 then
        ui.set(references.yaw[2], anti_aim.get_overlap(rotation) > 0.77 and antiaim_yaw_jitter(15,-25) or 0)
    end
    if ui.get(references.jitter[2]) > 60 then
        ui.set(references.yaw[2], anti_aim.get_overlap(rotation) > 0.84 and antiaim_yaw_jitter(15,-25) or 0)
    end
    if anti_aim.get_overlap(rotation) > 0.77 then
        status = "FAKE YAW"
    else
        status = "OVERLAP"
    end
    print(status..anti_aim.get_overlap(rotation))
end)