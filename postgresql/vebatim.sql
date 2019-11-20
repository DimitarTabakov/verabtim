CREATE OR REPLACE FUNCTION public.verbatim(num numeric)
 RETURNS text
 LANGUAGE sql
AS $function$
select

	
case  
	/* Уникални, малки числа */
    when num between 0 and 19 then 
		case num
			when 1 then 'Едно'	 when 6  then 'Шест'	when 11 then 'Единадесет'	 when 16 then 'Шестнадесет'
			when 2 then 'Две'	 when 7  then 'Седем'	when 12 then 'Дванадесет'	 when 17 then 'Седемнадесет'
			when 3 then 'Три'	 when 8  then 'Осем'	when 13 then 'Тринадесет'	 when 18 then 'Осемнадесет'
			when 4 then 'Четири' when 9  then 'Девет'	when 14 then 'Четиринадесет' when 19 then 'Деветнадесет'
			when 5 then 'Пет'	 when 10 then 'Десет'	when 15 then 'Петнадесет'	 when 0  then 'Нула'
		end
    /* Десетици */
	when (num between 20 and 90) and (num % 10 = 0) then 
		case num
			when 20 then 'Двадесет' 	when 60 then 'Шестдесет' 
			when 30 then 'Тридесет'		when 70 then 'Седемдесет'
			when 40 then 'Четиридесет'	when 80 then 'Осемдесет'
			when 50 then 'Петдесет'		when 90 then 'Деветдесет'
		end
    /* Между десетиците */
	when (num between 20 and 99) and (num % 10 != 0) then verb((num::integer / 10) * 10) || ' И ' || verb(num % 10) 
	/* Стотици, кръгли */
	when (num between 100 and 900) and (num % 100 = 0) then 
		case num
			when 100 then 'Сто' 		 when 600 then 'Шестстотин'
			when 200 then 'Двеста' 		 when 700 then 'Седемстотин'	
			when 300 then 'Триста' 		 when 800 then 'Осемстотин'
			when 400 then 'Четиристотин' when 900 then 'Деветстотин'
			when 500 then 'Петстотин'
		end
    /* Стотици, не кръгли */
	when (num between 100 and 999) and (num % 100 != 0) then 
		case 
			/* Стотици, които завършват на уникално число, или на кръгло 10 */
			when (num % 100 between 1 and 19) or (num % 10 = 0) then verb((num::integer / 100) * 100) || ' И ' || verb(num % 100)
			/* Стотици, останали */  
			else verb((num::integer / 100) * 100) || ' ' || verb(num::integer % 100)
		end
    /* 1000 */
	when num = 1000 then 'Хиляда'
	/* Между 1000 и 2000 */
	when num between 1001 and 1999 then
		case 
			/* Които завършват на кръгло 100, кръгло 10 или уникално число */
			when (num % 1000 between 1 and 19) or (num % 1000 < 100 and num % 10 = 0) or (num % 100 = 0) then 'Хиляда' || ' и ' || verb(num % 1000)
			/* Останалите */
			else 'Хиляда' || ' ' || verb(num % 1000)
		end
    /* Между 2000 и милион-без-едно */
	when num between 2000 and 999999 then 
		case 
			/* Кръгли хиляди */
			when num % 1000 = 0 then verb(num::integer / 1000) || ' Хиляди '
			/* Които завършват на кръгло 100, кръгло 10 или уникално число */
			when (num % 1000 != 0) and ((num % 1000 between 1 and 19) or (num % 1000 < 100 and num % 10 = 0) or (num % 100 = 0)) then verb(num::integer / 1000) || ' Хиляди И ' || verb(num % 1000)
			/* Останалите */
			else verb(num::integer / 1000) || ' Хиляди ' || verb(num % 1000)
		end
    /* Милион */
	when num = 1000000 then 'Един Милион'
    /* Между един и два милиона */
	when num between 1000001 and 1999999 then 
		case 
			/* Които завършват на кръгли или уникални */
			when (num % 1000000 between 1 and 19) or ((num % 1000000) % 10 = 0 and (num % 1000000) < 100) or (num % 100 = 0) then verb((num::integer / 1000000) * 1000000) || ' И ' || verb(num % 1000000)
			else verb((num::integer / 1000000) * 1000000) || ' ' || verb(num % 1000000)
		end
    /* Два милиона */
	when num = 2000000 then 'Два Милиона'
    /* Между 2 и 3 милиона */
	when num between 2000001 and 2999999 then verb((num::integer / 1000000) * 1000000) || ' ' || verb(num % 1000000)
    /* Между 3 милиона и милиард-без-едно */
	when num between 3000000 and 999999999 then verb(num::integer / 1000000) || ' Милиона ' || verb(num % 1000000)
	
end
$function$
;
