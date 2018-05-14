// Pascal bankOS (Server side)

program serverside;
uses crt;

// ----------------------------------------------------------------------------------------------------

// Vars & Labels
label main,auth,createAccount,editAccount,editAccountAction,editAccountChangeBal,editAccountDelete,editAccountChangeIdent,editAccountTransfer,editAccountInfo,editAccountChangePass;

var user,passwd,confirm: String; // General vars
	status: String = 'Обычный';
	action: Char;
	i: Integer = 0;
	len: Byte;

	f,f2: Text; // Vars for file reading (DO NOT EDIT)
	str,str2,newbal,newbal2,amount: Real;
	passwdstr,new,ff,ff2,ident,ident2: String;

	s: String; // Vars for errors check (DO NOT EDIT)
	code: Integer;
	error001: Boolean = false; // Unacceptable symbols
	error002: Boolean = false; // Negative balance
	error003: Boolean = false; // File not found

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
			readln(passwdstr);
			len:=length(passwdstr);

			if len > 20 then
				begin
					writeln('Пароль не может содержать больше 20 симолов');
					sleep(3000);
					goto editAccountChangePass;
				end
			else

			user:='passwds/'+ident+'.pass';
			assign(f2,user);

			writeln('Введенная выше информация верна? Y - Да, N - Нет: ');
			readln(confirm);

			if confirm = 'Y' then
				begin
					rewrite(f);
					writeln(f,amount);
					close(f);

					rewrite(f2);
					writeln(f2,passwdstr);
					close(f2);

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
	writeln();
	writeln('Вы уверены, что изменить идентификатор аккаунта ',ident,' на ',new,'? Y - Да, N - Нет: ');
	readln(confirm);

	if confirm = 'Y' then
		begin
			rename(f,ff);
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
	readln(passwdstr);
	len:=length(passwdstr);

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
					rewrite(f2);
					writeln(f2,passwdstr);
					close(f2);
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