life_fnc_sidechat =
compileFinal "
	if(life_sidechat) then {life_sidechat = false;} else {life_sidechat = true;};
	[[player,life_sidechat,playerSide],""TON_fnc_managesc"",false,false] spawn life_fnc_MP;
	[] call life_fnc_settingsMenu;
";

publicVariable "life_fnc_sidechat";

TON_fnc_index =
compileFinal "
	private[""_item"",""_stack""];
	_item = _this select 0;
	_stack = _this select 1;
	_return = -1;

	{
		if(_item in _x) exitWith {
			_return = _forEachIndex;
		};
	} foreach _stack;

	_return;
";

TON_fnc_player_query =
compileFinal "
	private[""_ret""];
	_ret = _this select 0;
	if(isNull _ret) exitWith {};
	if(isNil ""_ret"") exitWith {};

	[[life_atmcash,life_cash,owner player,player],""life_fnc_admininfo"",_ret,false] spawn life_fnc_MP;
";
publicVariable "TON_fnc_player_query";

publicVariable "TON_fnc_index";

TON_fnc_clientWireTransfer =
compileFinal "
	private[""_unit"",""_val"",""_from""];
	_val = _this select 0;
	_from = _this select 1;
	if(!([str(_val)] call TON_fnc_isnumber)) exitWith {};
	if(_from == """") exitWith {};
	life_atmcash = life_atmcash + _val;
	hint format[""%1 Transferiu %2 R$ para Você."",_from,[_val] call life_fnc_numberText];

";
publicVariable "TON_fnc_clientWireTransfer";

TON_fnc_isnumber =
compileFinal "
	private[""_valid"",""_value"",""_compare""];
	_value = _this select 0;
	_valid = [""0"",""1"",""2"",""3"",""4"",""5"",""6"",""7"",""8"",""9""];
	_array = [_value] call KRON_StrToArray;
	_return = true;

	{
		if(_x in _valid) then
		{}
		else
		{
			_return = false;
		};
	} foreach _array;
	_return;
";

publicVariable "TON_fnc_isnumber";

TON_fnc_clientGangKick =
compileFinal "
	private[""_unit"",""_group""];
	_unit = _this select 0;
	_group = _this select 1;
	if(isNil ""_unit"" OR isNil ""_group"") exitWith {};
	if(player == _unit && (group player) == _group) then
	{
		life_my_gang = ObjNull;
		[player] joinSilent (createGroup civilian);
		hint ""Você foi expulso da Gangue."";

	};
";
publicVariable "TON_fnc_clientGangKick";

TON_fnc_clientGetKey =
compileFinal "
	private[""_vehicle"",""_unit"",""_giver""];
	_vehicle = _this select 0;
	_unit = _this select 1;
	_giver = _this select 2;
	if(isNil ""_unit"" OR isNil ""_giver"") exitWith {};
	if(player == _unit && !(_vehicle in life_vehicles)) then
	{
		_name = getText(configFile >> ""CfgVehicles"" >> (typeOf _vehicle) >> ""displayName"");
		hint format[""%1 has gave you keys for a %2"",_giver,_name];
		life_vehicles pushBack _vehicle;
		[[getPlayerUID player,playerSide,_vehicle,1],""TON_fnc_keyManagement"",false,false] spawn life_fnc_MP;
	};
";

publicVariable "TON_fnc_clientGetKey";

TON_fnc_clientGangLeader =
compileFinal "
	private[""_unit"",""_group""];
	_unit = _this select 0;
	_group = _this select 1;
	if(isNil ""_unit"" OR isNil ""_group"") exitWith {};
	if(player == _unit && (group player) == _group) then
	{
		player setRank ""COLONEL"";
		_group selectLeader _unit;
		hint ""Você é o novo líder da Gangue."";
	};
";

publicVariable "TON_fnc_clientGangLeader";

//Cell Phone Messaging
/*
	-fnc_cell_textmsg
	-fnc_cell_textcop
	-fnc_cell_textadmin
	-fnc_cell_adminmsg
	-fnc_cell_adminmsgall
*/

//To EMS
TON_fnc_cell_emsrequest =
compileFinal "
private[""_msg"",""_to""];
	ctrlShow[3022,false];
	_msg = ctrlText 3003;
	_to = ""EMS Units"";
	if(_msg == """") exitWith {hint ""Você deve digitar uma mensagem para enviar!"";ctrlShow[3022,true];};

	[[_msg,name player,5],""TON_fnc_clientMessage"",independent,false] spawn life_fnc_MP;
	[] call life_fnc_cellphone;
	hint format[""Você enviou uma mensagem para todas as Unidades do SAMU."",_to,_msg];
	ctrlShow[3022,true];
";
//To One Person
TON_fnc_cell_textmsg =
compileFinal "
	private[""_msg"",""_to""];
	ctrlShow[3015,false];
	_msg = ctrlText 3003;
	if(lbCurSel 3004 == -1) exitWith {hint ""Você deve escolher um jogador que está na lista para enviar a mensagem!""; ctrlShow[3015,true];};
	_to = call compile format[""%1"",(lbData[3004,(lbCurSel 3004)])];
	if(isNull _to) exitWith {ctrlShow[3015,true];};
	if(isNil ""_to"") exitWith {ctrlShow[3015,true];};
	if(_msg == """") exitWith {hint ""Você deve digitar uma mensagem para enviar!"";ctrlShow[3015,true];};

	[[_msg,name player,0],""TON_fnc_clientMessage"",_to,false] spawn life_fnc_MP;
	[] call life_fnc_cellphone;
	hint format[""Você enviou para %1 a mensagem: %2"",name _to,_msg];
	ctrlShow[3015,true];
";
//To All Cops
TON_fnc_cell_textcop =
compileFinal "
	private[""_msg"",""_to""];
	ctrlShow[3016,false];
	_msg = ctrlText 3003;
	_to = ""The Police"";
	if(_msg == """") exitWith {hint ""Você deve digitar uma mensagem para enviar!"";ctrlShow[3016,true];};

	[[_msg,name player,1],""TON_fnc_clientMessage"",true,false] spawn life_fnc_MP;
	[] call life_fnc_cellphone;
	hint format[""Você enviou para %1 a mensagem: %2"",_to,_msg];
	ctrlShow[3016,true];
";
//To All Admins
TON_fnc_cell_textadmin =
compileFinal "
	private[""_msg"",""_to"",""_from""];
	ctrlShow[3017,false];
	_msg = ctrlText 3003;
	_to = ""The Admins"";
	if(_msg == """") exitWith {hint ""Você deve digitar uma mensagem para enviar!"";ctrlShow[3017,true];};

	[[_msg,name player,2],""TON_fnc_clientMessage"",true,false] spawn life_fnc_MP;
	[] call life_fnc_cellphone;
	hint format[""Você enviou para %1 a mensagem: %2"",_to,_msg];
	ctrlShow[3017,true];
";
//Admin To One Person
TON_fnc_cell_adminmsg =
compileFinal "
	if(isServer) exitWith {};
	if((call life_adminlevel) < 1) exitWith {hint ""Você não é um administrador!"";};
	private[""_msg"",""_to""];
	_msg = ctrlText 3003;
	_to = call compile format[""%1"",(lbData[3004,(lbCurSel 3004)])];
	if(isNull _to) exitWith {};
	if(_msg == """") exitWith {hint ""Você deve digitar uma mensagem para enviar!"";};

	[[_msg,name player,3],""TON_fnc_clientMessage"",_to,false] spawn life_fnc_MP;
	[] call life_fnc_cellphone;
	hint format[""ADMIN MENSAGEM PARA: %1 - MENSAGEM: %2"",name _to,_msg];
";

TON_fnc_cell_adminmsgall =
compileFinal "
	if(isServer) exitWith {};
	if((call life_adminlevel) < 1) exitWith {hint ""Você não é um administrador!"";};
	private[""_msg"",""_from""];
	_msg = ctrlText 3003;
	if(_msg == """") exitWith {hint ""Você deve digitar uma mensagem para enviar!"";};

	[[_msg,name player,4],""TON_fnc_clientMessage"",true,false] spawn life_fnc_MP;
	[] call life_fnc_cellphone;
	hint format[""MENSAGEM DO ADMINISTRADOR PARA TODOS: %1"",_msg];
";

publicVariable "TON_fnc_cell_textmsg";
publicVariable "TON_fnc_cell_textcop";
publicVariable "TON_fnc_cell_textadmin";
publicVariable "TON_fnc_cell_adminmsg";
publicVariable "TON_fnc_cell_adminmsgall";
publicVariable "TON_fnc_cell_emsrequest";
publicVariable "TON_fnc_cell_adacrequest";
//Client Message
/*
	0 = private message
	1 = police message
	2 = message to admin
	3 = message from admin
	4 = admin message to all
	5 = ems
	6 = ADAC
*/
TON_fnc_clientMessage =
compileFinal "
	if(isServer) exitWith {};
	private[""_msg"",""_from"", ""_type""];
	_msg = _this select 0;
	_from = _this select 1;
	_type = _this select 2;
	if(_from == """") exitWith {};
	switch (_type) do
	{
		case 0 :
		{
			private[""_message""];
			_message = format["">>>MESSAGE FROM %1: %2"",_from,_msg];
			hint parseText format [""<t color='#FFCC00'><t size='2'><t align='center'>Nova Mensagem<br/><br/><t color='#33CC33'><t align='left'><t size='1'>Para: <t color='#ffffff'>Você<br/><t color='#33CC33'>De: <t color='#ffffff'>%1<br/><br/><t color='#33CC33'>Mensagem:<br/><t color='#ffffff'>%2"",_from,_msg];
			player say3D ""alert"";
			systemChat _message;
		};

		case 1 :
		{
			if(side player != west) exitWith {};
			private[""_message""];
			_message = format[""---MENSAGEM DE EMERGENCIA DE %1: %2"",_from,_msg];
			hint parseText format [""<t color='#316dff'><t size='2'><t align='center'>Nova Mensagem<br/><br/><t color='#33CC33'><t align='left'><t size='1'>Para: <t color='#ffffff'>Todos os Policias<br/><t color='#33CC33'>De: <t color='#ffffff'>%1<br/><br/><t color='#33CC33'>Mensagem:<br/><t color='#ffffff'>%2"",_from,_msg];
			player say3D ""alert"";
			systemChat _message;
		};

		case 2 :
		{
			if((call life_adminlevel) < 1) exitWith {};
			private[""_message""];
			_message = format[""???MENSAGEM PARA O ADMIN DE %1: %2"",_from,_msg];
			hint parseText format [""<t color='#ffcefe'><t size='2'><t align='center'>ADMIN MENSAGEM<br/><br/><t color='#33CC33'><t align='left'><t size='1'>Para: <t color='#ffffff'>Admins<br/><t color='#33CC33'>De: <t color='#ffffff'>%1<br/><br/><t color='#33CC33'>Mensagem:<br/><t color='#ffffff'>%2"",_from,_msg];
			player say3D ""alert"";
			systemChat _message;
		};

		case 3 :
		{
			private[""_message""];
			_message = format[""!!!ADMIN MESSAGE: %1"",_msg];
			_admin = format[""Sent by admin: %1"", _from];
			hint parseText format [""<t color='#FF0000'><t size='2'><t align='center'>ADMIN MENSAGEM<br/><br/><t color='#33CC33'><t align='left'><t size='1'>Para: <t color='#ffffff'>Você<br/><t color='#33CC33'>De: <t color='#ffffff'>O ADMIN<br/><br/><t color='#33CC33'>Mensagem:<br/><t color='#ffffff'>%1"",_msg];
			player say3D ""alert"";
			systemChat _message;
			if((call life_adminlevel) > 0) then {systemChat _admin;};
		};

		case 4 :
		{
			private[""_message"",""_admin""];
			_message = format[""!!!MENSAGEM DO ADMINISTRADOR: %1"",_msg];
			_admin = format[""Sent by admin: %1"", _from];
			hint parseText format [""<t color='#FF0000'><t size='2'><t align='center'>ADMIN MENSAGEM<br/><br/><t color='#33CC33'><t align='left'><t size='1'>Para: <t color='#ffffff'>TODOS OS JOGADORES<br/><t color='#33CC33'>De: <t color='#ffffff'>O ADMIN<br/><br/><t color='#33CC33'>Mensagem:<br/><t color='#ffffff'>%1"",_msg];
			player say3D ""alert"";
			systemChat _message;
			if((call life_adminlevel) > 0) then {systemChat _admin;};
		};

		case 5: {
			private[""_message""];
			_message = format[""!!!SAMU MENSAGEM: %1"",_msg];
			hint parseText format [""<t color='#FFCC00'><t size='2'><t align='center'>SAMU MENSAGEM<br/><br/><t color='#33CC33'><t align='left'><t size='1'>Para: <t color='#ffffff'>Você<br/><t color='#33CC33'>De: <t color='#ffffff'>%1<br/><br/><t color='#33CC33'>Mensagem:<br/><t color='#ffffff'>%2"",_from,_msg];
			player say3D ""alert"";
		};

		case 6: {
			private[""_message""];
			_message = format[""Mecanico: %1"",_msg];
			hint parseText format [""<t color='#FFCC00'><t size='2'><t align='center'>MENSAGEM DO MECANICO<br/><br/><t color='#33CC33'><t align='left'><t size='1'>Para: <t color='#ffffff'>Você<br/><t color='#33CC33'>DE: <t color='#ffffff'>%1<br/><br/><t color='#33CC33'>Mensagem:<br/><t color='#ffffff'>%2"",_from,_msg];
			player say3D ""alert"";
		};
	};
";
publicVariable "TON_fnc_clientMessage";