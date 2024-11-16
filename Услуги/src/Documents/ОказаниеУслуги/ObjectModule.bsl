Процедура ОбработкаЗаполнения(ДанныеЗаполнения,СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	//Данный фрагмент построен конструктором.
	//При повторном использовании конструктора, внесенные вручную данные будут утеряны!

	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Клиенты") Тогда
		// Заполнение шапки
		Клиент = ДанныеЗаполнения.Ссылка;
		ОбъектОснование = ДанныеЗаполнения.Ссылка;

	КонецЕсли;

	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ

КонецПроцедуры
Процедура ОбработкаПроведения(Отказ,Режим)

Движения.ОстаткиМатериалов.Записывать = Истина;
Движения.СтоимостьМатериалов.Записывать = Истина;
Движения.Продажи.Записывать = Истина;
Движения.Управленческий.Записывать = Истина;

МенеджерВТ = Новый МенеджерВременныхТаблиц;

#Область НоменклатураДокумента
Запрос = Новый Запрос;
Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
Запрос.Текст =

"ВЫБРАТЬ
|	ОказаниеУслугиПереченьНоменклатуры.Номенклатура,
|	ОказаниеУслугиПереченьНоменклатуры.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
|	ОказаниеУслугиПереченьНоменклатуры.НаборСвойств КАК НаборСвойств,
|	СУММА(ОказаниеУслугиПереченьНоменклатуры.Количество) КАК КоличествоВДокументе,
|	СУММА(ОказаниеУслугиПереченьНоменклатуры.Сумма) КАК СуммаВДокументе
|ПОМЕСТИТЬ НоменклатураДокумента
|ИЗ
|	Документ.ОказаниеУслуги.ПереченьНоменклатуры КАК ОказаниеУслугиПереченьНоменклатуры
|ГДЕ
|	ОказаниеУслугиПереченьНоменклатуры.Ссылка = &Ссылка
|СГРУППИРОВАТЬ ПО
|	ОказаниеУслугиПереченьНоменклатуры.Номенклатура,
|	ОказаниеУслугиПереченьНоменклатуры.Номенклатура.ВидНоменклатуры,
|	ОказаниеУслугиПереченьНоменклатуры.НаборСвойств";

Запрос.УстановитьПараметр("Ссылка", Ссылка);

РезультатЗапроса = Запрос.Выполнить();
#КонецОбласти

#Область ДвиженияДокумента
Запрос2 = Новый Запрос;
Запрос2.МенеджерВременныхТаблиц = МенеджерВТ;
Запрос2.Текст = "ВЫБРАТЬ
|	НоменклатураДокумента.Номенклатура,
|	НоменклатураДокумента.ВидНоменклатуры,
|	НоменклатураДокумента.НаборСвойств,
|	НоменклатураДокумента.КоличествоВДокументе,
|	НоменклатураДокумента.СуммаВДокументе,
|	ЕСТЬNULL(СтоимостьМатериаловОстатки.СтоимостьОстаток, 0) КАК Стоимость ,
|	ЕСТЬNULL(ОстаткиМатериаловОстатки.КоличествоОстаток, 0) КАК Количество
|ИЗ
|	НоменклатураДокумента КАК НоменклатураДокумента
|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьМатериалов.Остатки(&Период, Материал В
|			(ВЫБРАТЬ
|				НоменклатураДокумента.Номенклатура
|			ИЗ
|				НоменклатураДокумента)) КАК СтоимостьМатериаловОстатки
|		ПО НоменклатураДокумента.Номенклатура = СтоимостьМатериаловОстатки.Материал
|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОстаткиМатериалов.Остатки(&Период, Материал В
|			(ВЫБРАТЬ
|				НоменклатураДокумента.Номенклатура
|			ИЗ
|				НоменклатураДокумента)) КАК ОстаткиМатериаловОстатки
|		ПО НоменклатураДокумента.Номенклатура = ОстаткиМатериаловОстатки.Материал";




Запрос2.УстановитьПараметр("Период", МоментВремени());

// Установить необходимость блокировки данных в регистрах СтоимостьМатериалов и ОстаткиМатериалов.
Движения.СтоимостьМатериалов.БлокироватьДляИзменения = Истина;

Движения.ОстаткиМатериалов.БлокироватьДляИзменения = Истина;

РезультатЗапроса = Запрос2.Выполнить();

ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Если ВыборкаДетальныеЗаписи.Количество = 0 Тогда
		СтоимостьМатериала = 0;
	Иначе
		СтоимостьМатериала = ВыборкаДетальныеЗаписи.Стоимость / ВыборкаДетальныеЗаписи.Количество;
	КонецЕсли;
	
	Если ВыборкаДетальныеЗаписи.ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Материал Тогда
		
		Движение = Движения.ОстаткиМатериалов.Добавить();
		Движение.Период = Дата;
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Материал = ВыборкаДетальныеЗаписи.Номенклатура;
		Движение.НаборСвойств = ВыборкаДетальныеЗаписи.НаборСвойств;
		Движение.Склад = Склад;
		Движение.Количество = ВыборкаДетальныеЗаписи.КоличествоВДокументе;
	

		Движение = Движения.СтоимостьМатериалов.Добавить();
		Движение.Период = Дата;
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Материал = ВыборкаДетальныеЗаписи.Номенклатура;
		Движение.Стоимость = ВыборкаДетальныеЗаписи.КоличествоВДокументе * СтоимостьМатериала;
		
		// Регистр Управленческий 
		// Первая проводка:	 Д 62(ДебиторскаяЗадолженность) – К 90 (Капитал) Розничная сумма
		Движение = Движения.Управленческий.Добавить();
		Движение.СчетДт = ПланыСчетов.Основной.ДебиторскаяЗадолженность;
		Движение.СчетКт = ПланыСчетов.Основной.Капитал;
		Движение.Период = Дата;
		Движение.Сумма  = ВыборкаДетальныеЗаписи.СуммаВДокументе;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Клиенты] = Клиент;
		
			// Вторая проводка: Д 90 (Капитал) – К 41 (Товары) – себестоимость
		Движение = Движения.Управленческий.Добавить();
		Движение.СчетДт = ПланыСчетов.Основной.Капитал;
		Движение.СчетКт = ПланыСчетов.Основной.Товары;
		Движение.Период = Дата;
		Движение.Сумма  = СтоимостьМатериала * ВыборкаДетальныеЗаписи.КоличествоВДокументе;
		Движение.КоличествоКт = ВыборкаДетальныеЗаписи.КоличествоВДокументе;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Материалы] = ВыборкаДетальныеЗаписи.Номенклатура;

	КонецЕсли;

	// регистр Продажи
	
		Движение = Движения.Продажи.Добавить();
		Движение.Период = Дата;
		Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		Движение.Клиент = Клиент;
		Движение.Мастер = Мастер;
		Движение.Количество = ВыборкаДетальныеЗаписи.КоличествоВДокументе;
		Движение.Выручка = ВыборкаДетальныеЗаписи.СуммаВДокументе;
		Движение.Стоимость = ВыборкаДетальныеЗаписи.КоличествоВДокументе * СтоимостьМатериала;
КонецЦикла;

Движения.Записать();
#КонецОбласти

#Область КонтрольОстатков
Если Режим = РежимПроведенияДокумента.Оперативный Тогда
	Запрос3 = Новый Запрос;
	Запрос3.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос3.Текст = "ВЫБРАТЬ
	|	ОстаткиМатериаловОстатки.Материал,
	|	ОстаткиМатериаловОстатки.НаборСвойств,
	|	ОстаткиМатериаловОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ОстаткиМатериалов.Остатки(, (Материал, НаборСвойств) В
	|		(ВЫБРАТЬ
	|			НоменклатураДокумента.Номенклатура,
	|			НоменклатураДокумента.НаборСвойств
	|		ИЗ
	|			НоменклатураДокумента)
	|	И Склад = &Склад) КАК ОстаткиМатериаловОстатки
	|ГДЕ
	|	ОстаткиМатериаловОстатки.КоличествоОстаток < 0";

Запрос3.УстановитьПараметр("Склад", Склад);
РезультатЗапроса = Запрос3.Выполнить();

ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();


Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Сообщение = Новый СообщениеПользователю();
	Сообщение.Текст = "Не хватает " + Строка(- ВыборкаДетальныеЗаписи.КоличествоОстаток) + " единиц материала """ + ВыборкаДетальныеЗаписи.Материал + """" + " из набора свойств """ 
	+ ВыборкаДетальныеЗаписи.НаборСвойств + """";
	Сообщение.Сообщить();
	Отказ = Истина;
КонецЦикла;
	
	
КонецЕсли;
#КонецОбласти

КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Префикс = Обмен.ПолучитьПрефиксНомера();
	
КонецПроцедуры
