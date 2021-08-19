AddCSLuaFile()

if SERVER then
	ACF = ACF or {}
	ACF.ClTraceCallbacks = ACF.ClTraceCallbacks or {}

	util.AddNetworkString( "acftool_cltrace" )

	net.Receive( "acftool_cltrace", function(_, ply)
		local trace = {
			Entity = net.ReadEntity(),
			HitNormal = net.ReadVector(),
			HitPos = net.ReadVector()
		}

		if not ACF.ClTraceCallbacks[ply] then return end
		ACF.ClTraceCallbacks[ply]( trace )
		ACF.ClTraceCallbacks[ply] = nil
	end )

	function ACF.ClTraceRequest(ply, cb)
		net.Start( "acftool_cltrace" )
		net.Send( ply )
		ACF.ClTraceCallbacks[ply] = cb
	end
end

if CLIENT then
	net.Receive( "acftool_cltrace", function()
		local trace = util.TraceLine( util.GetPlayerTrace( LocalPlayer() ) )

		net.Start( "acftool_cltrace" )
		net.WriteEntity( trace.Entity )
		net.WriteVector( trace.HitNormal )
		net.WriteVector( trace.HitPos )
		net.SendToServer()
	end )
end