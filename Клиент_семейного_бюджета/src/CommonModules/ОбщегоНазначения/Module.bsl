
Процедура ПриНачалеработыСистемы() Экспорт
	
	ЭтоНепервоеПодключение = Ложь;
	Если Не Константы.ЭтоНеПервоеПодключение.Получить() Тогда
		Получениеданных.ВыполнитьЗагрузкуСЯндэксДиска();
		ПолучитьИУстановитьКодУзла();
		ЭтоНепервоеПодключение = Истина;
	КонецЕсли;	
	ФоновыеЗадания.Выполнить("Получениеданных.ВыполнитьСинхронизацию");
	Если ЭтоНепервоеПодключение Тогда
		ЖдатьДо = ТекущаяДата() + 2;
		Пока ТекущаяДата() < ЖдатьДо Цикл
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьИУстановитьКодУзла()
	
	Попытка
		ВСОпределение = Новый WSОпределения(Константы.АдресПодключения.Получить(),
		Константы.Логин.Получить(),
		Константы.Пароль.Получить(),,,);
		ВССервис = ВсОпределение.Сервисы.Получить("DataTransfer","ОбмеДанными");
		ВСТочкаВхода = ВССервис.ТочкиПодключения.Получить("ОбмеДаннымиSoap");
		ВСОперация = ВСТочкаВхода.Интерфейс.Операции.Получить("Синхронизация");  		
		Данные = Новый ХранилищеЗначения("ЭтоПервоеПодключение",Новый СжатиеДанных(9));
		ДанныеXDTO = ВСОпределение.ФабрикаXDTO.Создать(ВСОперация.Параметры.Получить("Данные").Тип,Данные);
		ВСПрокси = Новый WSПрокси(ВСОпределение,"DataTransfer","ОбмеДанными","ОбмеДаннымиSoap",); 
		ВСПрокси.Пользователь = Константы.Логин.Получить();
		ВСПрокси.Пароль = Константы.Пароль.Получить();
		Ответ = ВСПрокси.Синхронизация(ДанныеXDTO); 
		ПринятьИзмененияКода(Ответ.Получить());		
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;	
	
КонецПроцедуры

// Принять изменения кода.
// 
// Параметры:
//  Код Код
Процедура ПринятьИзмененияКода(Код)
	
	ЭтотУзелСсылка = ПланыОбмена.Мобильный.ЭтотУзел(); 
	ЭтотУзел = ЭтотУзелСсылка.ПолучитьОбъект();
	ЭтотУзел.Код = Строка(Код); 	
	ЭтотУзел.Наименование = Строка(Код);
	ЭтотУзел.Записать();
	НУзел = ПланыОбмена.Мобильный.СоздатьУзел();
	НУзел.Код = "ЦБ";
	НУзел.Наименование = "ЦБ";
	НУзел.Записать();
	Константы.ЭтонеПервоеПодключение.Установить(Истина);
	
КонецПроцедуры
