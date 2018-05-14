// Pascal bankOS (Client side)

program clientside;
uses crt;

// ----------------------------------------------------------------------------------------------------

// Vars & Labels
label main,auth,editAccountInfo,editAccountTransfer,editAccountChangePass,editAccountDelete;

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

					textcolor(darkgray);
					writeln('Введите пароль: ');
					textcolor(white);
					readln(passwd);

					reset(f2);
					readln(f2,passwdstr);
					close(f2);

					textcolor(lightgray);
					writeln();
					write('[');

					for i := 1 to 20 do
						begin
							write('█');
							sleep(100);
						end;

					write(']');writeln();writeln();

					if passwdstr = passwd then
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
	textcolor(darkgray);write('Добро пожаловать, ');textcolor(white);write(ident,'!');

	textcolor(lightgray);
	writeln();
	writeln();
	textcolor(darkgray);write('1 - ');textcolor(lightgray);write('Посмотреть информацию об аккаунте');
	writeln();
	textcolor(darkgray);write('2 - ');textcolor(lightgray);write('Перевести выборочную сумму с этого аккаунта на другой');
	writeln();
	textcolor(darkgray);write('3 - ');textcolor(lightgray);write('Изменить пароль');
	writeln();
	textcolor(darkgray);write('4 - ');textcolor(lightgray);write('Удалить аккаунт');
	writeln();
	textcolor(darkgray);write('5 - ');textcolor(lightgray);write('Выход');
	writeln();writeln();
	textcolor(white);
	readln(action);

	case action of
		'1':goto editAccountInfo;
		'2':goto editAccountTransfer;
		'3':goto editAccountChangePass;
		'4':goto editAccountDelete;
		'5':exit();
	else
		writeln('Ошибка. Попробуйте снова');
		sleep(3000);
		goto main;
	end;

// ----------------------------------------------------------------------------------------------------

	editAccountInfo: // Account full information [1]
	clrscr;
	reset(f);
	readln(f,str);
	close(f);

	textcolor(darkgray);write('Аккаунт: ');textcolor(lightgray);write(ident);
	writeln();
	textcolor(darkgray);write('Баланс: ');textcolor(lightgray);write('$',str);
	writeln();
	textcolor(darkgray);write('Статус: ');textcolor(lightgray);write(status);
	writeln();writeln();
	textcolor(darkgray);write('0 - ');textcolor(lightgray);write('Вернуться на главную');
	writeln();writeln();
	textcolor(white);
	readln(action);

	if action = '0' then
		goto main;

// ----------------------------------------------------------------------------------------------------

	editAccountTransfer: // Transfer balance to another account [2]
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

				textcolor(darkgray);write('Введенная выше информация верна?');textcolor(lightgreen);write(' Y - Да');textcolor(darkgray);write(' | ');textcolor(lightred);write('N - Нет');
				textcolor(white);
				writeln();writeln();
				readln(confirm);

				if confirm = 'Y' then
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
								writeln();

								textcolor(lightgray);
								write('[');

								for i := 1 to 20 do
									begin
								    	write('█');
								    	sleep(100);
									end;

								  	write(']');

								writeln();writeln();

								textcolor(darkgray);write('Новый баланс аккаунта ',ident);textcolor(lightgray);write(': $',newbal);
								writeln();
								textcolor(darkgray);write('Переведено на аккаунт ',ident2);textcolor(lightgray);write(': $',amount);

								sleep(5000);

								goto main;
							end;
					end
				else
					goto editAccountTransfer;
			end;

// ----------------------------------------------------------------------------------------------------

	editAccountChangePass: // Change account password [3]
	clrscr;
	ff2:='passwds/'+ident+'.pass';
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

	editAccountDelete: // Delete account [4]
	clrscr;
	ff2:='passwds/'+ident+'.pass';
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
			goto auth;
		end
	else
		goto main;

// ----------------------------------------------------------------------------------------------------

end.