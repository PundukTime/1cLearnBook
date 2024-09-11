Процедура ОбработкаПроведения(Отказ,Режим)

	Движения.ОстаткиМатериалов.Записывать   = Истина;
	Движения.СтоимостьМатериалов.Записывать = Истина;
	Движения.Управленческий.Записывать      = Истина;
	
	Для Каждого ТекСтрокаМатериалы из Материалы Цикл

		// регистр ОстаткиМатериалов Приход
		Движение = Движения.ОстаткиМатериалов.Добавить();
		Движение.Период       = Дата;
		Движение.ВидДвижения  = ВидДвиженияНакопления.Приход;
		Движение.Материал     = ТекСтрокаМатериалы.Материал;
		Движение.НаборСвойств = ТекСтрокаМатериалы.НаборСвойств;
		Движение.Склад        = Склад;
		Движение.Количество   = ТекСтрокаМатериалы.Количество;
		
		// Регистр Стоимость Материалов Приход
		Движение = Движения.СтоимостьМатериалов.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период      = Дата;
		Движение.Материал    = ТекСтрокаМатериалы.Материал;
		Движение.Стоимость   = ТекСтрокаМатериалы.Сумма;
		
		// Регистр Управленческий 
		Движение = Движения.Управленческий.Добавить();
		Движение.СчетДт = ПланыСчетов.Основной.Товары;
		Движение.СчетКт = ПланыСчетов.Основной.РасчетыСПоставщиками;
		Движение.Период = Дата;
		Движение.Сумма  = ТекСтрокаМатериалы.Сумма;
		Движение.КоличествоДт = ТекСтрокаМатериалы.Количество;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Материалы] = ТекСтрокаМатериалы.Материал;
		
	КонецЦикла;

КонецПроцедуры