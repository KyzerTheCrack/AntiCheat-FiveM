Anticheat = Anticheat or {}

Anticheat.ServerName = ""
Anticheat.ServerLogo = ""

Anticheat.lastHealthData = { health = 0, armor = 0 }
Anticheat.ReportsDone = {}
Anticheat.CamerasEdit = {}
Anticheat.AntiCreateCam = CreateCam
Anticheat.AntiCreateCamera = CreateCamera
Anticheat.AntiDestroyCam = DestroyCam
Anticheat.AntiDestroyAllCams = DestroyAllCams

Anticheat.ESX = true -- Si vous utilisez ESX

Anticheat.AntiCarkill = true -- Anti carkill
Anticheat.BlockWheelWeapons = false -- Bolquer la roue des armes sur TAB

Anticheat.IsSpawned = false -- Ne pas toucher

Anticheat.BlockTiny = true -- Bloquer les joueurs en petits
Anticheat.AntiGodmod = true -- Bloquer le godmod
Anticheat.AntiHeal = false -- Bloquer le heal
Anticheat.AntiAmmoComplete = false -- Bloquer le Ammo Complete

Anticheat.CanRagdoll = false -- Si le ped ne peut pas ragdoll sa ban

Anticheat.AntiExplosiveBullets = true -- Anti explosive bullet

Anticheat.AntiLicenseClears = true -- Anti License Clear

Anticheat.AntiKeyboardNativeInjections = true -- Anti Injection via Keyboard

Anticheat.AntiCheatEngine = true -- Anti Engine Cheat

Anticheat.AntiPedChange = false -- Anti Ped Change

Anticheat.AntiStopResource = true

Anticheat.MaxResourceNameLength = 68 -- Vos resources max (Si sa vous ban, changer jusqu'a tombé sur le bon)

Anticheat.AntiResourceStartorStop = true -- Anti resource

Anticheat.DeleteExplodedCars = true -- Delete vehicle if engine health == 0

Anticheat.AntiPedAttack = true -- Delete one ped when he attacks you

Anticheat.AntiGiveWeapon = false -- Anti Give weapon

Anticheat.AntiSuicide = false -- Anti Suicide

Anticheat.ModeBase = "a_m_y_skater_01"

Anticheat.AntiCarjack = true -- Bloquer le carjack
Anticheat.NoReloadLife = true -- Bloquer la vie qui remonte
Anticheat.BlockNightVision = false -- Bloquer la vision nocturne
Anticheat.BlockThermalVision = false -- Bloquer la vision thermique
Anticheat.AntiInfiniteAmmo = false -- Bloquer les armes avec munitions infini
Anticheat.AntiSprintMultiplier = false -- Bloquer le sprint multiplier
Anticheat.AntiSwimMultiplier = false -- Bloquer le swim multiplier

Anticheat.ResourceCount = true

Anticheat.PowerVehicle = false

Anticheat.ExplosionProof = false -- Si les joueur peuvent se faire exploser ou non
Anticheat.CollisionProof = true -- Si les joueurs prennent des dégats lors des collision

Anticheat.AntiTrigger = true -- Bloquer les trigger
Anticheat.Superjump = false -- Bloquer le superjump

Anticheat.AntiFreecam = false -- Bloquer les freecam

Anticheat.AntiChatMessage = true -- Bloquer des mots blacklist dans le chat

Anticheat.AntiExplosion = true -- Bloquer des explosion

Anticheat.AntiSpectate = false -- Bloquer le spectate

Anticheat.AntiStamina = true

Anticheat.Endpoints = {
    ["GetTextureResolution"] = true,
	["SetPedInfiniteAmmo"] = true,
	["ShootSingleBulletBetweenCoords"] = true,
	["ShootSingleBulletBetweenCoordsIgnoreEntity"] = true,
	["ShootSingleBulletBetweenCoordsIgnoreEntityNew"] = true,
	["SetSuperJumpThisFrame"] = true,
	["SetExplosiveMeleeThisFrame"] = true,
	["SetExplosiveAmmoThisFrame"] = true,
	["SetPedShootsAtCoord"] = true,
	["SetHandlingField"] = true,
	["SetHandlingInt"] = true,
	["SetHandlingFloat"] = true,
	["SetHandlingVector"] = true,
	["AddExplosion"] = true,
	["NetworkExplodeVehicle"] = true,
	["ShowHeadingIndicatorOnBlip"] = true,
	["SetBlipNameToPlayerName"] = true,
	["SetBlipCategory"] = true,
	["ApplyForceToEntity"] = true,
	["LoadResourceFile"] = true,
	["SetEntityRotation"] = true,
	["StartShapeTestRay"] = true,
	["SetPedAlertness"] = true,
	["DrawLine"] = true,
	["ResetPlayerStamina"] = Anticheat.AntiStamina,
	["GetPedBoneCoords"] = true,
	
}

Anticheat.GlobalEndpoints = {
	["KeyboardInput"] = true,
	["GetKeyboardInput"] = true,
	["_Executor"] = true,
	["_Executor_Strings"] = true,
}


AnticheatConfig = AnticheatConfig or {}

AnticheatConfig.BlacklistedCaracters = { -- Caractères blacklist dans les noms steam
    "'",
    "·",
    "’",
    "“",
    "”",
    "•",
    "«",
    "»",
    "•",
    "–",
    "—",
    "±",
    "×",
    "²",
    "³",
    "†",
    "‡",
    "_",
    "¹",
    "⁴",
    "⁰",
}

AnticheatConfig.BlacklistedWords = { -- Mots blacklist dans le chat
	'Desudo',
	'Brutan',
	'EulenCheats',
	"discord.gg/",
	"lynxmenu",
	"HamHaxia",
	"Ham Mafia",
	"www.renalua.com",
	"Fallen#0811",
	"Rena 8",
	"HamHaxia", 
	"Ham Mafia", 
	"Xanax#0134", 
	">:D Player Crash", 
	"discord.gg", 
	"34ByTe Community", 
	"lynxmenu.com", 
	"Anti-LRAC",
	"Baran#8992",
    "fdp",
    "ntm",
    "nique",
    "fils",
    "vas trouver",
    "cancer",
    "encule",
    "sucer",
    "mere",
    "mère",
    "sale",
	"iLostName#7138",
	"85.190.90.118",
	"Melon#1379",
	"hammafia.com",
	"AlphaV ~ 5391",
	"vjuton.pl",
	"Soviet Bear",
	"XARIES",
	"xaries",
	"dc.xaries.pl",
	"aries",
	"aries.pl",
	"youtube.com",
	"Aries98",
	"yo many",
	"dezet",
	"333",
	"333GANG",
    "chocolate",
	"panickey",
	"killmenu",
	"panik",
	"lynx",
	"brutan",
	"saucy",
    "negro",
    "quit",
    "uit",
    "tuck",
    "register",
    "inventory",
    "report",
    "pd",
    "juif",
    "arabe",
    "bougnoule",
    "revive",
    "pute",
    "ftg",
    "ferme",
}

AnticheatConfig.Webhook = "https://discord.com/api/webhooks/861433013005713419/4tFgml0f6LXjmdVeMZTMfKvtr0Av8QTYKofNzABr2ItSB9X3iVoJHPgVFvNuh3lHZgY6" -- WebHook pour vos logs

AnticheatConfig.Discord = "discord.gg/WgGrfsmjYz" -- Discord quand le joueur se connecte et qu'il est ban

AnticheatConfig.UseDiscord = false -- Si votre serveur utilise discord
AnticheatConfig.UseSteam = true -- Si votre serveur utilise steam

AnticheatConfig.BlacklistedEventsAntiESX = { -- Trigger Blacklist (Ajouter vous meme si vous voulez)
    "gcPhone:_internalAddMessage",
}

Anticheat.BlacklistExposion = {
	0,
	1,
	2,
	3,
	4,
	5,
	7,
	9,
	12,
	13,
	25,
	31,
	32,
	33,
	35,
	36,
	37,
	38
}

Anticheat.WhitelistedProps = {
	"prop_ballistic_shield",
	"prop_amb_phone",
	"xm_prop_x17_tem_control_01",
	"player_zero",
	"prop_bowling_ball",
	"p_parachute1_mp_s"
}

Anticheat.ClearPedsAfterDetection = true

Anticheat.GarageList = { -- Place all of the garage coordinates right here.
	{x = 217.89, y = -804.99, z = 30.91},
}

Anticheat.ClearVehiclesAfterDetection = true
Anticheat.ClearObjectsAfterDetection = true

Anticheat.MaxPedsPerUser = 3
Anticheat.MaxPropsPerUser = 10
Anticheat.MaxVehiclesPerUser = 5
Anticheat.MaxEntitiesPerUser = 10
Anticheat.MaxParticlesPerUser = 3

Anticheat.BlacklistedVehicles = true

Anticheat.BlacklistedModels = { -- Only peds or vehicles
	-- Vehicles
	"skylift","valkyrie2","airbus","hunter","bus","armytanker","armytrailer","armytrailer2","baletrailer","boattrailer","cablecar","docktrailer","freighttrailer","graintrailer","proptrailer","raketrailer","tr2","tr3","tr4","trflat","tvtrailer","tanker","tanker2","tankercar","trailerlarge","trailerlogs","trailersmall","trailers3","trailers4",'RHINO','AKULA','SAVAGE','HUNTER','BUZZARD','ANNIHILATOR','VALKYRIE','HYDRA','APC','Trailersmall2','Lazer','oppressor','mogul','barrage','Khanjali','volatol','chernobog','avenger','stromberg','nightshark','besra','babushka ','starling','insurgent','cargobob','cargobob2','cargobob3','cargobob4','caracara','deluxo','menacer','scramjet','oppressor2','revolter','viseris','savestra','thruster','ardent','dune3','tampa3','halftrack','nokota','strikeforce','bombushka','molotok','pyro','ruiner2','limo2','technical','technical2','technical3','jb700w','blazer5','insurgent3','boxville5','bruiser','bruiser2','bruiser3','brutus','brutus2','brutus3','cerberus','cerberus2','cerberus3','dominator4','dominator5','dominator6','impaler2','impaler3','impaler4','imperator','imperator2','imperator3','issi4','issi5','issi6','monster3','monster4','monster5','scarab','scarab2','scarab3','slamvan4','slamvan5','slamvan6','zr380','zr3802','zr3803','alphaz1','avenger2','blimp','blimp2','blimp3','cargoplane','cuban800','dodo','duster','howard','jet','luxor','luxor2','mammatus','microlight','miljet','nimbus','rogue','seabreeze','shamal','stunt','titan','tula','velum','velum2','vestra',

	-- PEDS
	"s_m_y_swat_01","a_m_o_acult_01","ig_wade","s_m_y_hwaycop_01","A_M_Y_ACult_01",'s_m_m_movalien_01','s_m_m_movallien_01','u_m_y_babyd','CS_Orleans','A_M_Y_ACult_01','S_M_M_MovSpace_01','U_M_Y_Zombie_01','s_m_y_blackops_01','a_f_y_topless_01','a_c_boar','a_c_cat_01','a_c_chickenhawk','a_c_chimp','a_c_chop','a_c_cormorant','a_c_cow','a_c_coyote','a_c_crow','a_c_dolphin','a_c_fish','a_c_hen','a_c_humpback','a_c_husky','a_c_killerwhale','a_c_mtlion','a_c_pigeon','a_c_poodle','a_c_pug','a_c_rabbit_01','a_c_rat','a_c_retriever','a_c_rhesus','a_c_rottweiler','a_c_sharkhammer','a_c_sharktiger','a_c_shepherd','a_c_stingray','a_c_westy','CS_Orleans',
}

Anticheat.AntiClearPedTasks = true
Anticheat.AntiProjectile = true
Anticheat.AntiBlacklistedWeapons = true

Anticheat.BlacklistedWeapons = {
	"WEAPON_BULLPUPSHOTGUN",
	"WEAPON_GRENADELAUNCHER",
	"WEAPON_GRENADELAUNCHER_SMOKE",
	"WEAPON_RPG",
	"WEAPON_STINGER",
	"WEAPON_MINIGUN",
	"WEAPON_HEAVYSHOTGUN",
	"WEAPON_RAILGUN",
	"WEAPON_RAILPISTOL",
	"WEAPON_RAYPISTOL", 
	"WEAPON_RAYCARBINE", 
	"WEAPON_RAYMINIGUN",
	"WEAPON_DIGISCANNER",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_BULLPUPRIFLE_MK2",
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_MARKSMANRIFLE_MK2",
	"WEAPON_COMPACTLAUNCHER",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_REVOLVER_MK2",
	"WEAPON_FIREWORK",
	"WEAPON_HOMINGLAUNCHER", 
	"WEAPON_SMG_MK2"
}