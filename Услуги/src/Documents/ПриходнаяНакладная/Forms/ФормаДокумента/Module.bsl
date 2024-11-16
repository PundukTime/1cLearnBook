&НаКлиенте
Перем ОтветПередДобавлением;

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыФормы = Новый Структура("МножественныйВыбор", Истина);
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы, Элементы.Материалы);
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура МатериалыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если ОтветПередДобавлением <> Истина Тогда
		СтандартнаяОбработка = Ложь;
		Результат = Ждать ВопросАсинх("Добавить номенклатуру в табличную часть?", РежимДиалогаВопрос.ДаНет);

		Если Результат = КодВозвратаДиалога.Да Тогда
			ОтветПередДобавлением = Истина;

			Для Каждого ВыбранныйЭлемент Из ВыбранноеЗначение Цикл
				НоваяСтрока = Объект.Материалы.Добавить();
				НоваяСтрока.Материал = ВыбранныйЭлемент;
				
			КонецЦикла;
			
		КонецЕсли;  

	Иначе
		Для Каждого ВыбранныйЭлемент Из ВыбранноеЗначение Цикл
			НоваяСтрока = Объект.Материалы.Добавить();
			НоваяСтрока.Материал = ВыбранныйЭлемент;
			
		КонецЦикла;
		
	КонецЕсли;  

КонецПроцедуры


&НаКлиенте
Процедура МатериалыКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Материалы.ТекущиеДанные;
	РаботаСДокументами.РассчитатьСумму(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура МатериалыЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Материалы.ТекущиеДанные;
	РаботаСДокументами.РассчитатьСумму(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Асинх Процедура ПодборВопрос(Команда)

	Результат = Ждать ВопросАсинх("Подобрать номенклатуру в документ?", РежимДиалогаВопрос.ДаНет);

	Если Результат = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура("МножественныйВыбор", Истина);
		ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы, Элементы.Материалы);
	КонецЕсли;  

КонецПроцедуры

&НаКлиенте
Процедура ПодборНоменклатуры(Команда)
	
	
	ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Истина);
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы, Элементы.Материалы);
	
КонецПроцедуры


&НаКлиенте
Процедура МатериалыМатериалОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для Каждого ВыбранныйЭлемент Из ВыбранноеЗначение Цикл
		НоваяСтрока = Объект.Материалы.Добавить();
		НоваяСтрока.Материал = ВыбранныйЭлемент;
		
	КонецЦикла;
	
КонецПроцедуры


