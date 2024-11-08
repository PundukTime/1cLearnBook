Процедура ЗаписатьСообщениеСИзменениями() Экспорт
	
	Сообщить("-------- Выгрузка в узел " + Строка(ЭтотОбъект) + " ------------");
	Каталог = КаталогВременныхФайлов();

	 // Сформировать имя временного файла.
	ИмяФайла = Каталог + "Message" + СокрЛП(ПланыОбмена.Филиалы.ЭтотУзел().Код) + "_" + СокрЛП(Ссылка.Код) + ".xml";
		
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.ОткрытьФайл(ИмяФайла);
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	ЗаписьСообщения.НачатьЗапись(ЗаписьXML, Ссылка);
	Сообщить(" Номер сообщения: " + ЗаписьСообщения.НомерСообщения);
	
	ВыборкаИзменений = ПланыОбмена.ВыбратьИзменения(ЗаписьСообщения.Получатель, ЗаписьСообщения.НомерСообщения);
	
	Пока ВыборкаИзменений.Следующий() Цикл
		
		ЗаписатьXML(ЗаписьXML, ВыборкаИзменений.Получить());
		
	КонецЦикла;
	
	ЗаписьСообщения.ЗакончитьЗапись();
	ЗаписьXML.Закрыть();
	
	Сообщить("-------- Конец выгрузки ------------");
	
КонецПроцедуры

Процедура ПрочитатьСообщениеСИзменениями() Экспорт
	
	Каталог = КаталогВременныхФайлов();
	ИмяФайла = Каталог + "Message" + СокрЛП(Ссылка.Код) + "_" + СокрЛП(ПланыОбмена.Филиалы.ЭтотУзел().Код) + ".xml";
	
	Файл = Новый Файл(ИмяФайла);
	Если Не Файл.Существует() Тогда
		Возврат;
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	Попытка
		ЧтениеXML.ОткрытьФайл(ИмяФайла);
	
	Исключение
		Сообщить("Невозможно открыть файл обмена данными.");
	
		Возврат;
		
	КонецПопытки;
	
	Сообщить("-------- Загрузка из " + Строка(ЭтотОбъект) + " ------------");

	Сообщить(" – Считывается файл " + ИмяФайла);

	ЧтениеСообщения = ПланыОбмена.СоздатьЧтениеСообщения();
	
	ЧтениеСообщения.НачатьЧтение(ЧтениеXML);
	
	Если ЧтениеСообщения.Отправитель <> Ссылка Тогда
		ВызватьИсключение "Неверный узел";
	КонецЕсли;
		
	ПланыОбмена.УдалитьРегистрациюИзменений(ЧтениеСообщения.Отправитель, ЧтениеСообщения.НомерПринятого);
	
	Пока ВозможностьЧтенияXML(ЧтениеXML) Цикл
		Данные = ПрочитатьXML(ЧтениеXML);
		
		Если Не ЧтениеСообщения.Отправитель.Главный И ПланыОбмена.ИзменениеЗарегистрировано(ЧтениеСообщения.Отправитель, Данные) Тогда
			Сообщить(" - Изменения отклонены");
			
			Продолжить;
			
		КонецЕсли;
		
		Данные.ОбменДанными.Отправитель = ЧтениеСообщения.Отправитель;
		Данные.ОбменДанными.Загрузка = Истина;
		Данные.Записать();
		
	КонецЦикла;
	ЧтениеСообщения.ЗакончитьЧтение();
	
	ЧтениеXML.Закрыть();
	
	УдалитьФайлы(ИмяФайла);
	
	Сообщить("-------- Конец выгрузки ------------");
	
КонецПроцедуры