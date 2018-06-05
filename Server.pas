// Pascal bankOS (Server side)

program serverside;
uses crt;

// ----------------------------------------------------------------------------------------------------

// Vars & Labels
label main,auth,createAccount,editAccount,editAccountAction,editAccountChangeBal,editAccountDelete,editAccountChangeIdent,editAccountTransfer,editAccountInfo,editAccountChangePass;

var user,passwd,confirm: String; // General vars
var	status: string = 'Обычный';
var	action: char;
var	i: integer;
var	len: byte;

var	f,f2: Text; // Vars for file reading (DO NOT EDIT)
var	str,str2,newbal,newbal2,amount: real;
var	new,ff,ff2,ident,ident2: string;

var	s: String; // Vars for errors check (DO NOT EDIT)
var	code: Integer;
var	error001: boolean = false; // Unacceptable symbols
var	error002: boolean = false; // Negative balance
var	error003: boolean = false; // File not found

// Vars for encrypt and decrypt procedures (DO NOT EDIT)
var chars: array [1..55] of char = ('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','P','Q','R','S','T','U','V','W','X','Y','Z');
var	enc: array [1..91] of string;
var	z: string;
var	encrypted: string;

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

procedure error; // Error #001 (Unacceptable symbols)
begin
	if code <> 0 then
		begin
			error001 := true;
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
	writeln('Введите имя пользователя:');
	readln(user);
	writeln('Введите пароль:');
	readln(passwd);

	writeln();
	write('[');

	for i := 1 to 20 do
		begin
			write('█');
			sleep(100);
		end;

	write(']');writeln();writeln();

	if (user = 'osx11') and (passwd = 'z4z2234') then
		begin
			sleep(500);
			goto main;
		end
	else
		begin
			clrscr;
			writeln('Неверный пароль');
			sleep(3000);
			goto auth;
		end;

// ----------------------------------------------------------------------------------------------------

	// Main part
	main:
	clrscr;
	writeln('Добро пожаловать в систему управления аккаунтами');
	writeln('1 - Создать новый аккаунт');
	writeln('2 - Редактировать существующий аккаунт');
	writeln('3 - Выход');
	readln(action);

	case action of
		'1':goto createAccount;
		'2':goto editAccount;
		'3':exit();
	else
		writeln('Ошибка. Попробуйте снова');
		sleep(3000);
		goto main;
	end;

// ----------------------------------------------------------------------------------------------------

	// Create account part
	createAccount:
	clrscr;
	writeln('Введите новый идентификатор аккаунта');
	readln(ident); // Receiving new account name
	ff:='users/'+ident;

	if FileExists(ff) then
		begin
			writeln('Данный аккаунт уже существует.');
			writeln('Если Вы хотите пересоздать аккаунт, сначала удалите его в соответствующем разделе');
			sleep(5000);
			goto main;
		end
	else
		begin
			assign(f,ff);
			writeln('Введите новый баланс аккаунта (по умолчанию: 0)');
			readln(s); // Receiving new account balance
			val(s,amount,code);
			error;

			if error001 = true then
				goto createAccount
			else

			checkamount;

			if error002 = true then
				goto createAccount
			else

			writeln('Введите новый пароль аккаунта');
			readln(z);
			len:=length(z);

			if len > 20 then
				begin
					writeln('Пароль не может содержать больше 20 симолов');
					sleep(3000);
					goto editAccountChangePass;
				end
			else

			ff2:='passwds/'+ident+'.pass';
			assign(f2,ff2);

			writeln('Введенная выше информация верна? Y - Да, N - Нет: ');
			readln(confirm);

			if confirm = 'Y' then
				begin
					rewrite(f);
					writeln(f,amount);
					close(f);

					encrypt();

					writeln('Аккаунт успешно создан');
					sleep(3000);
					goto main;
				end
			else
				goto createAccount;
		end;
// ----------------------------------------------------------------------------------------------------

	// Edit account part
	editAccount:
	clrscr;
	writeln('Введите идентификатор аккаунта');
	readln(ident);
	ff:='users/'+ident;
	ff2:='passwds/'+ident+'.pass';
	checkexists;

	if error003 = true then // Check error #003
		goto main
	else

	assign(f,ff);
	assign(f2,ff2);

	clrscr;
	writeln('Аккаунт: ',ident);
	writeln();
	writeln('Выберите действие для этого аккаунта: ');
	writeln('1 - Перевести выборочную сумму с этого аккаунта на другой');
	writeln('2 - Изменить баланс аккаунта');
	writeln('3 - Изменить идентификатор аккаунта');
	writeln('4 - Изменить пароль');
	writeln('5 - Получить полную информацию об аккаунте');
	writeln('6 - Удалить аккаунт');
	writeln('7 - Вернуться на главную');
	readln(action);

	case action of
		'1':goto editAccountTransfer;
		'2':goto editAccountChangeBal;
		'3':goto editAccountChangeIdent;
		'4':goto editAccountChangePass;
		'5':goto editAccountInfo;
		'6':goto editAccountDelete;
		'7':goto main;
	else
		writeln('Ошибка. Попробуйте снова');
		sleep(3000);
		goto editAccount;
	end;

// ----------------------------------------------------------------------------------------------------

	editAccountTransfer: // Transfer balance to another account [1]
	clrscr;
	writeln('Введите сумму перевода');
	readln(s);
	val(s,amount,code);

	error;

	if error001 = true then // Check error #001
		goto editAccountTransfer;

	checkamount;

	if error002 = true then // Check error #002
		goto editAccountTransfer;

	writeln('Введите идентификатор аккаунта, на который хотите перевести $',amount,':');
	readln(ident2);
	ff2:='users/'+ident2;
	
	if not FileExists(ff2) then
		begin
			writeln('Данный идентификатор аккаунта не существует');
			sleep(3000);
			goto editAccountTransfer;
		end
	else

	if ident = ident2 then
		begin
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
			writeln('Текущий баланс аккаунта ',ident,': $',str);
			writeln('Перевод на аккаунт: ',ident2);
			writeln('Сумма перевода: $',amount);
			writeln();

			writeln('Введенная выше информация верна? Y - Да, N - Нет: ');
			readln(confirm);

			if confirm = 'Y' then
				begin
					newbal:=str-amount; // Set first account balance
					newbal2:=str2+amount; // Set second account balance
					

					if newbal < 0 then
						begin
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
							writeln();

							write('[');

							for i := 1 to 20 do
								begin
							    	write('█');
							    	sleep(100);
								end;

							write('] 100%');

							writeln();
							writeln('Новый баланс аккаунта ',ident,': $',newbal);
							writeln('Новый баланс аккаунта ',ident2,': $',newbal2);

							sleep(5000);

							goto main;
						end;
				end
			else
				goto editAccountTransfer;
		end;

// ----------------------------------------------------------------------------------------------------

	editAccountChangeBal: // Change account balance [2]
	clrscr;
	reset(f);
	readln(f,str);
	close(f);
	writeln('Аккаунт: ',ident);
	writeln('Текущий баланс аккаунта: $', str);
	writeln('Введите новый баланс аккаунта: ');
	readln(s);
	val(s,amount,code);
	error;

	if error001 = true then // Check error #001
		goto editAccountChangeBal
	else

	checkamount;

	if error002 = true then // Check error #002
		goto editAccountChangeBal
	else
		begin
			writeln();
			writeln('Введенная выше информация верна? Y - Да, N - Нет: ');
			readln(confirm);

			if confirm = 'Y' then
				begin
					rewrite(f);
					writeln(f,amount);
					writeln('Новый баланс аккаунта: $',amount);
					sleep(3000);
					close(f);
					goto main;
				end
			else
				goto editAccountChangeBal;
		end;

// ----------------------------------------------------------------------------------------------------

	editAccountChangeIdent: // Change account ident [3]
	clrscr;
	writeln('Аккаунт: ',ident);
	writeln('Введите новый идентификатор аккаунта: ');
	readln(new);
	ff:='users/'+new;
	ff2:='passwds/'+new+'.pass';
	writeln();
	writeln('Вы уверены, что изменить идентификатор аккаунта ',ident,' на ',new,'? Y - Да, N - Нет: ');
	readln(confirm);

	if confirm = 'Y' then
		begin
			rename(f,ff);
			rename(f2,ff2);
			writeln('Идентификатор аккаунта ',ident,' изменен на ',new);
			sleep(3000);
			goto main;
		end
	else
		goto editAccountChangeIdent;

// ----------------------------------------------------------------------------------------------------

	editAccountChangePass: // Change account password [4]
	clrscr;
	writeln('Аккаунт: ',ident);
	writeln('Введите новый пароль:');
	readln(z);
	len:=length(z);

	if len > 20 then
		begin
			writeln('Пароль не может содержать больше 20 симолов');
			sleep(3000);
			goto editAccountChangePass;
		end
	else
		begin
			writeln('Введенная выше информация верна? Y - Да, N - Нет: ');
			readln(confirm);

			if confirm = 'Y' then
				begin
					encrypt();
					writeln('Пароль успешно изменен');
					sleep(3000);
					goto main;
				end
			else
				goto editAccountChangePass;
		end;

// ----------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------

	editAccountInfo: // Account full information [5]
	clrscr;
	reset(f);
	readln(f,str);
	close(f);

	writeln('Аккаунт: ',ident);
	writeln('Баланс: $',str);
	writeln('Статус: ',status);
	writeln();
	writeln('0 - Вернуться на главную');
	readln(action);

	if action = '0' then
		goto main;

// ----------------------------------------------------------------------------------------------------

	editAccountDelete: // Delete account [6]
	clrscr;
	writeln('Аккаунт: ',ident);
	writeln();
	writeln('Вы уверены, что хотите удалить аккаунт ',ident,'? Y - Да, N - Нет: ');
	readln(confirm);

	if confirm = 'Y' then
		begin
			erase(f);
			erase(f2);
			writeln('Аккаунт ',ident, ' удален');
			sleep(3000);
			goto main;
		end
	else
		goto main;

// ----------------------------------------------------------------------------------------------------

end.