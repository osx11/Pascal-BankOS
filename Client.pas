// Pascal bankOS (Client side)

program clientside;
uses crt;

// ----------------------------------------------------------------------------------------------------

// Vars & Labels
label main,auth,editAccountInfo,editAccountTransfer,editAccountChangePass,editAccountDelete;

var user,passwd,confirm: string; // General vars
var	status: string = 'Обычный';
var	action: char;
var	i: integer;
var	len: byte;

var	f,f2: Text; // Vars for file reading (DO NOT EDIT)
var	str,str2,newbal,newbal2,amount: real;
var	ff,ff2,ident,ident2: string;

var	s: string; // Vars for errors check (DO NOT EDIT)
var	code: integer;
var	error001: boolean = false; // Unacceptable symbols
var	error002: boolean = false; // Negative balance
var	error003: boolean = false; // File not found

// Vars for encrypt and decrypt procedures (DO NOT EDIT)
var chars: array [1..55] of char = ('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','P','Q','R','S','T','U','V','W','X','Y','Z');
var	enc: array [1..91] of string;
var dec: array [1..612] of string;
var	empt: string = '';
var	z: string;
var	encrypted: string;
var	decrypted: string;

// ----------------------------------------------------------------------------------------------------

procedure encrypt; // Encryptor

var i: integer;

begin

	for i:=1 to length(z) do
	begin
	  if z[i] = ' ' then
	    begin
	      writeln('Нельзя использовать пробел в пароле');
	      exit();
	    end
	end;
  
	for i:=1 to length(z) do
	begin
	  case z[i] of
	    'a': enc[i]:='88d42';
	    'b': enc[i]:='31589';
	    'c': enc[i]:='28957';
	    'd': enc[i]:='9d209';
	    'e': enc[i]:='e5e08';
	    'f': enc[i]:='78c9d';
	    'g': enc[i]:='2a449';
	    'h': enc[i]:='dc16a';
	    'i': enc[i]:='005c1';
	    'j': enc[i]:='be086';
	    'k': enc[i]:='70463';
	    'l': enc[i]:='eec8d';
	    'm': enc[i]:='f1afc';
	    'n': enc[i]:='1d270';
	    'o': enc[i]:='998f0';
	    'p': enc[i]:='5a8cd';
	    'q': enc[i]:='83992';
	    'r': enc[i]:='d6c1d';
	    's': enc[i]:='95238';
	    't': enc[i]:='c5871';
	    'u': enc[i]:='0f76e';
	    'v': enc[i]:='68d0d';
	    'w': enc[i]:='2b26f';
	    'x': enc[i]:='4ad3e';
	    'y': enc[i]:='68d61';
	    'z': enc[i]:='5bad1';
	    'A': enc[i]:='e12e1';
	    'B': enc[i]:='23677';
	    'C': enc[i]:='4c4ef';
	    'D': enc[i]:='81c82';
	    'E': enc[i]:='e59e4';
	    'F': enc[i]:='61954';
	    'G': enc[i]:='67f34';
	    'H': enc[i]:='0cb0c';
	    'I': enc[i]:='0c943';
	    'J': enc[i]:='cc452';
	    'K': enc[i]:='4f2fe';
	    'L': enc[i]:='bcdb1';
	    'M': enc[i]:='c7f27';
	    'N': enc[i]:='39bb7';
	    'O': enc[i]:='8e82c';
	    'P': enc[i]:='741e6';
	    'Q': enc[i]:='3205e';
	    'R': enc[i]:='11400';
	    'S': enc[i]:='de532';
	    'T': enc[i]:='c57f0';
	    'U': enc[i]:='5a080';
	    'V': enc[i]:='6f93d';
	    'W': enc[i]:='65bd8';
	    'X': enc[i]:='bfd2e';
	    'Y': enc[i]:='b7198';
	    'Z': enc[i]:='b299b';
	    '0': enc[i]:='1be2e';
	    '1': enc[i]:='99a6a';
	    '2': enc[i]:='6bbb1';
	    '3': enc[i]:='f768e';
	    '4': enc[i]:='db2e7';
	    '5': enc[i]:='d2669';
	    '6': enc[i]:='b7cc7';
	    '7': enc[i]:='4795c';
	    '8': enc[i]:='cd70b';
	    '9': enc[i]:='4f45a';
	    '!': enc[i]:='1296b';
	    '@': enc[i]:='cdfdd';
	    '#': enc[i]:='5ca6a';
	    '$': enc[i]:='3715c';
	    '%': enc[i]:='0cf9b';
	    '^': enc[i]:='b9868';
	    '&': enc[i]:='aec06';
	    '*': enc[i]:='cac7b';
	    '(': enc[i]:='28260';
	    ')': enc[i]:='295a2';
	    '<': enc[i]:='efc77';
	    '>': enc[i]:='e31c3';
	    '[': enc[i]:='444a3';
	    ']': enc[i]:='84dd8';
	    '-': enc[i]:='d139c';
	    '+': enc[i]:='f15c9';
	    '_': enc[i]:='57612';
	    '=': enc[i]:='4adff';
	    '/': enc[i]:='cd01d';
	    '\': enc[i]:='69880';
	    '?': enc[i]:='d56f8';
	    '.': enc[i]:='c3533';
	    ',': enc[i]:='1fdce';
	    '`': enc[i]:='6fcf1';
	    '~': enc[i]:='efec6';
	    '|': enc[i]:='f7085';
	    ':': enc[i]:='f53c8';
	    ';': enc[i]:='311ce';
	    '"': enc[i]:='8a331';
	  end;
	end;

 	rewrite(f2);

	for i:=1 to 256 do
	write(f2,chars[1+random(55)]);

	for i:=1 to length(z) do
	write(f2,enc[i]);

	for i:=1 to 256 do
	write(f2,chars[1+random(55)]);

	close(f2);

end;

// ----------------------------------------------------------------------------------------------------

procedure decrypt; // Decryptor

var i: integer;
var n: integer = -4;
var z2: string;

begin

	reset(f2);
	readln(f2,z);
	close(f2);

	delete(z,1,256);
  
	for i:=1 to 100 do
		begin
		  n:=n+5;
		  z2:=copy(z,n,5);
		  dec[i]:=z2;
		end;

	for i:=1 to 100 do
	begin
		case dec[i] of
	    '88d42': dec[i]:='a';
	    '31589': dec[i]:='b';
	    '28957': dec[i]:='c';
	    '9d209': dec[i]:='d';
	    'e5e08': dec[i]:='e';
	    '78c9d': dec[i]:='f';
	    '2a449': dec[i]:='g';
	    'dc16a': dec[i]:='h';
	    '005c1': dec[i]:='i';
	    'be086': dec[i]:='j';
	    '70463': dec[i]:='k';
	    'eec8d': dec[i]:='l';
	    'f1afc': dec[i]:='m';
	    '1d270': dec[i]:='n';
	    '998f0': dec[i]:='o';
	    '5a8cd': dec[i]:='p';
	    '83992': dec[i]:='q';
	    'd6c1d': dec[i]:='r';
	    '95238': dec[i]:='s';
	    'c5871': dec[i]:='t';
	    '0f76e': dec[i]:='u';
	    '68d0d': dec[i]:='v';
	    '2b26f': dec[i]:='w';
	    '4ad3e': dec[i]:='x';
	    '68d61': dec[i]:='y';
	    '5bad1': dec[i]:='z';
	    'e12e1': dec[i]:='A';
	    '23677': dec[i]:='B';
	    '4c4ef': dec[i]:='C';
	    '81c82': dec[i]:='D';
	    'e59e4': dec[i]:='E';
	    '61954': dec[i]:='F';
	    '67f34': dec[i]:='G';
	    '0cb0c': dec[i]:='H';
	    '0c943': dec[i]:='I';
	    'cc452': dec[i]:='J';
	    '4f2fe': dec[i]:='K';
	    'bcdb1': dec[i]:='L';
	    'c7f27': dec[i]:='M';
	    '39bb7': dec[i]:='N';
	    '8e82c': dec[i]:='O';
	    '741e6': dec[i]:='P';
	    '3205e': dec[i]:='Q';
	    '11400': dec[i]:='R';
	    'de532': dec[i]:='S';
	    'c57f0': dec[i]:='T';
	    '5a080': dec[i]:='U';
	    '6f93d': dec[i]:='V';
	    '65bd8': dec[i]:='W';
	    'bfd2e': dec[i]:='X';
	    'b7198': dec[i]:='Y';
	    'b299b': dec[i]:='Z';
	    '1be2e': dec[i]:='0';
	    '99a6a': dec[i]:='1';
	    '6bbb1': dec[i]:='2';
	    'f768e': dec[i]:='3';
	    'db2e7': dec[i]:='4';
	    'd2669': dec[i]:='5';
	    'b7cc7': dec[i]:='6';
	    '4795c': dec[i]:='7';
	    'cd70b': dec[i]:='8';
	    '4f45a': dec[i]:='9';
	    '1296b': dec[i]:='!';
	    'cdfdd': dec[i]:='@';
	    '5ca6a': dec[i]:='#';
	    '3715c': dec[i]:='$';
	    '0cf9b': dec[i]:='%';
	    'b9868': dec[i]:='^';
	    'aec06': dec[i]:='&';
	    'cac7b': dec[i]:='*';
	    '28260': dec[i]:='(';
	    '295a2': dec[i]:=')';
	    'efc77': dec[i]:='<';
	    'e31c3': dec[i]:='>';
	    '444a3': dec[i]:='[';
	    '84dd8': dec[i]:=']';
	    'd139c': dec[i]:='-';
	    'f15c9': dec[i]:='+';
	    '57612': dec[i]:='_';
	    '4adff': dec[i]:='=';
	    'cd01d': dec[i]:='/';
	    '69880': dec[i]:='\';
	    'd56f8': dec[i]:='?';
	    'c3533': dec[i]:='.';
	    '1fdce': dec[i]:=',';
	    '6fcf1': dec[i]:='`';
	    'efec6': dec[i]:='~';
	    'f7085': dec[i]:='|';
	    'f53c8': dec[i]:=':';
	    '311ce': dec[i]:=';';
	    '8a331': dec[i]:='"';
		  else
		    dec[i]:='';
		  end;
	end;

	for i:=1 to 100 do
	decrypted:=decrypted+dec[i];

end;
// ----------------------------------------------------------------------------------------------------

procedure error; // Error #001 (Unacceptable symbols)
begin
	if code <> 0 then
		begin
			error001 := true;
			textcolor(lightred);
			writeln('Обнаружены недопустимые символы. Код ошибки: #001');
			sleep(3000);
		end
	else
		error001 := false;
end;

// ----------------------------------------------------------------------------------------------------

procedure checkamount; // Error #002 (Negative balance)
begin
	if amount <= 0 then
		begin
			error002 := true;
			textcolor(lightred);
			writeln('Баланс аккаунта (или переводимая сумма) не может быть отрицательным. Код ошибки: #002');
			sleep(3000);
		end
	else
		error002 := false;
end;

// ----------------------------------------------------------------------------------------------------

procedure checkexists; // Error #003 (File not exists)
begin
	if not FileExists(ff) then
		begin
			error003 := true;
			textcolor(lightred);
			writeln('Данный идентификатор аккаунта не существует. Код ошибки: #003');
			sleep(3000);
		end
	else
		error003 := false;
end;

// ----------------------------------------------------------------------------------------------------

begin

// ----------------------------------------------------------------------------------------------------
	
	// Authentication
	auth:
	clrscr;
	z:='';
	decrypted:='';
	passwd:='';
	textcolor(darkgray);
	writeln('Введите идентификатор аккаунта: ');
	textcolor(white);
	readln(ident);
	ff:='users/'+ident;
	ff2:='passwds/'+ident+'.pass';

	checkexists;

	if error003 = true then // Check error #003
		goto auth
	else
		begin
			if not FileExists(ff2) then
				begin
					textcolor(lightred);
					writeln('Пароль для данного аккаунта не установлен. Обратитесь к Администратору. Код ошибки: #003');
					sleep(3000);
					goto auth;
				end
			else
				begin
					assign(f,ff);
					assign(f2,ff2);

					reset(f);
					readln(f,str);
					close(f);

					writeln();
					textcolor(darkgray);
					writeln('Введите пароль: ');
					textcolor(white);
					readln(passwd);

					decrypt();

					textcolor(lightgray);
					writeln();
					write('[');

					for i := 1 to 20 do
						begin
							write('█');
							sleep(100);
						end;

					write(']');writeln();writeln();

					if decrypted = passwd then
						begin
							sleep(500);
							goto main;
						end
					else
						begin
							textcolor(lightred);
							writeln('Неверный пароль. Повторите попытку');
							sleep(3000);
							goto auth;
						end;
				end;
		end;

// ----------------------------------------------------------------------------------------------------

	// Main
	main:
	clrscr;
	textcolor(white);
	textcolor(lightgray);writeln('========================================================================================================================');
	textcolor(darkgray);write('Добро пожаловать, ');textcolor(white);write(ident,'!');
	writeln();
	textcolor(darkgray);write('Баланс: ');textcolor(lightgray);write('$',str);
	writeln();
	textcolor(darkgray);write('Статус: ');textcolor(lightgray);write(status);
	writeln();writeln();
	textcolor(lightgray);writeln('========================================================================================================================');
	textcolor(lightgray);
	textcolor(darkgray);write('1 - ');textcolor(lightgray);write('Перевести выборочную сумму с этого аккаунта на другой');
	writeln();
	textcolor(darkgray);write('2 - ');textcolor(lightgray);write('Изменить пароль');
	writeln();
	textcolor(darkgray);write('3 - ');textcolor(lightgray);write('Удалить аккаунт');
	writeln();
	textcolor(darkgray);write('4 - ');textcolor(lightgray);write('Выход');
	writeln();writeln();
	textcolor(white);
	readln(action);

	case action of
		'1':goto editAccountTransfer;
		'2':goto editAccountChangePass;
		'3':goto editAccountDelete;
		'4':exit();
	else
		writeln('Ошибка. Попробуйте снова');
		sleep(3000);
		goto main;
	end;

// ----------------------------------------------------------------------------------------------------

	editAccountTransfer: // Transfer balance to another account [1]
		clrscr;
		textcolor(darkgray);
		writeln('Введите сумму перевода');
		textcolor(white);
		readln(s);
		val(s,amount,code);

		error;

		if error001 = true then // Check error #001
			goto editAccountTransfer;

		checkamount;

		if error002 = true then // Check error #002
			goto editAccountTransfer;

		textcolor(darkgray);
		writeln('Введите идентификатор аккаунта, на который хотите перевести $',amount,':');
		textcolor(white);
		readln(ident2);
		ff2:='users/'+ident2;
		
		if not FileExists(ff2) then
			begin
				textcolor(lightred);
				writeln();
				writeln('Данный идентификатор аккаунта не существует');
				sleep(3000);
				goto editAccountTransfer;
			end
		else

		if ident = ident2 then
			begin
				textcolor(lightred);
				writeln();
				writeln('Вы не можете первести сумму на свой аккаунт');
				sleep(3000);
				goto editAccountTransfer;
			end
		else
			begin
				assign(f2,ff2);
				reset(f);
				readln(f,str);
				close(f);
				reset(f2);
				readln(f2,str2);
				close(f2);
				clrscr;

				textcolor(darkgray);write('Текущий баланс аккаунта ');textcolor(lightgray);write(ident,': $',str);
				writeln();
				textcolor(darkgray);write('Перевод на аккаунт: ');textcolor(lightgray);write(ident2);
				writeln();
				textcolor(darkgray);write('Сумма перевода: ');textcolor(lightgray);write('$',amount);

				writeln();writeln();

				textcolor(darkgray);write('Введите пароль для подтверждения: ');
				textcolor(white);
				writeln();
				readln(passwd);

				writeln();
				textcolor(lightgray);
				write('[');

				for i := 1 to 20 do
				begin
			    	write('█');
			    	sleep(100);
				end;

			  	write(']');

				if decrypted = passwd then
					begin
						newbal:=str-amount; // Set first account balance
						newbal2:=str2+amount; // Set second account balance

						if newbal < 0 then
							begin
								textcolor(lightred);
								writeln('Баланс аккаунта не может быть отрицательным');
								sleep(3000);
								goto editAccountTransfer;
							end
						else
							begin
								rewrite(f);
								writeln(f,newbal);
								close(f);
								rewrite(f2);
								writeln(f2,newbal2);
								close(f2);
								writeln();writeln();

								textcolor(darkgray);write('Новый баланс аккаунта ',ident);textcolor(lightgray);write(': $',newbal);
								writeln();
								textcolor(darkgray);write('Переведено на аккаунт ',ident2);textcolor(lightgray);write(': $',amount);

								sleep(5000);

								goto main;
							end;
					end
				else
					begin
						writeln();writeln();
						textcolor(lightred);
						writeln('Неверный пароль. Повторите попытку');
						sleep(3000);
						goto main;
					end;
			end;

// ----------------------------------------------------------------------------------------------------

	editAccountChangePass: // Change account password [2]
	clrscr;
	ff2:='passwds/'+ident+'.pass';
	textcolor(lightgray);writeln('========================================================================================================================');
	textcolor(darkgray);write('Аккаунт: ');textcolor(lightgray);write(ident);
	writeln();writeln();
	textcolor(lightgray);writeln('========================================================================================================================');
	textcolor(darkgray);writeln('Введите новый пароль:');
	textcolor(white);
	readln(z);writeln();
	len:=length(z);

	if (len > 20) or (len < 6) then
		begin
			textcolor(lightred);
			writeln('Пароль должен содержать не менее 6, но не более 20 символов');
			sleep(3000);
			goto editAccountChangePass;
		end
	else
		begin
			textcolor(darkgray);write('Введите старый пароль');
			textcolor(white);
			writeln();
			readln(passwd);

			writeln();
			textcolor(lightgray);
			write('[');

			for i := 1 to 20 do
			begin
		    	write('█');
		    	sleep(100);
			end;

			write(']');

			if decrypted = passwd then
				begin
					encrypt();
					writeln();writeln();
					textcolor(lightgreen);writeln('Пароль успешно изменен');
					sleep(3000);
					goto auth;
				end
			else
				writeln();writeln();
				textcolor(lightred);
				writeln('Неверный пароль. Повторите попытку');
				sleep(3000);
				goto main;
		end;

// ----------------------------------------------------------------------------------------------------

	editAccountDelete: // Delete account [3]
	clrscr;
	ff2:='passwds/'+ident+'.pass';
	assign(f2,ff2);
	textcolor(lightgray);writeln('========================================================================================================================');
	textcolor(darkgray);write('Аккаунт: ');textcolor(lightgray);write(ident);
	writeln();writeln();
	textcolor(lightgray);writeln('========================================================================================================================');
	writeln();
	textcolor(darkgray);write('Введите пароль для подтверждения: ');
	textcolor(white);
	writeln();
	readln(passwd);

	writeln();
	textcolor(lightgray);
	write('[');

	for i := 1 to 20 do
	begin
    	write('█');
    	sleep(100);
	end;

	write(']');

	if decrypted = passwd then
		begin
			erase(f);
			erase(f2);
			writeln();writeln();
			textcolor(darkgray);write('Аккаунт ');textcolor(white);write(ident);textcolor(darkgray);write(' удален');
			sleep(3000);
			goto auth;
		end
	else
		writeln();writeln();
		textcolor(lightred);
		writeln('Неверный пароль. Повторите попытку');
		sleep(3000);
		goto main;

// ----------------------------------------------------------------------------------------------------

end.