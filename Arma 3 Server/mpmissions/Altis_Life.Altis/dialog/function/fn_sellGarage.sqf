#include <macro.h>
/*
	File: fn_sellGarage.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Sells a vehicle from the garage.
*/
private["_vehicle","_vid","_pid","_unit","_price"];

life_nb_sell = life_nb_sell + 1;
if (life_nb_sell > 1) exitWith
	{
	[[[0,1],format["%1 está tentando dupar um veículo, avise a um admin !!!",name player]],"life_fnc_broadcast",true,false] spawn life_fnc_MP;
	};

disableSerialization;
if(lbCurSel 2802 == -1) exitWith {hint localize "STR_Global_NoSelection"};
_vehicle = lbData[2802,(lbCurSel 2802)];
_vehicle = (call compile format["%1",_vehicle]) select 0;
_vid = lbValue[2802,(lbCurSel 2802)];
_pid = getPlayerUID player;
_unit = player;

if(isNil "_vehicle") exitWith {hint localize "STR_Garage_Selection_Error"};
if(isNil "life_cgar_inUse") then {life_cgar_inUse = time - 301;};
if(life_cgar_inUse + (300) >= time) exitWith {closeDialog 0; hint format["Você pode vender um carro apenas a cada 5 minutos! %1:%2",4 - floor ((time - life_cgar_inUse) / 60),59 - round (time - life_cgar_inUse - (floor ((time - life_cgar_inUse) / 60)) * 60)];};

_price = [_vehicle,__GETC__(life_garage_sell)] call TON_fnc_index;
if(_price == -1) then {_price = 1000;} else {_price = (__GETC__(life_garage_sell) select _price) select 1;};

[[_vid,_pid,_price,player,life_garage_type],"TON_fnc_vehicleDelete",false,false] spawn life_fnc_MP;
hint format[localize "STR_Garage_SoldCar",[_price] call life_fnc_numberText];
life_atmcash = life_atmcash + _price;

closeDialog 0;
life_cgar_inUse = time;