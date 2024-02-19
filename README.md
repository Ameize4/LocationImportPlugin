# Плагин для импорта и экспорта локаций

При запуске плагин скачивает актуальную версию и импортирует ее в работу как обычную библиотеку.

У сотрудников лежит только `LocationImporter.lua`, который является прокси к импорту плагина. 
Все что лежит в папке `LocationImporterCode` скачивается и импортируется после.

## Специфика кода и built-ins

В скриптах на первом уровне обычно импортируются сервисы встроенные в движок, и далее я постараюсь указать какие здесь используются сервисы и built-ins

1. game - ентри поинт для многих сервисов движка и информации о проекте
2. workspace - сцена в роблоксе. Окружение, объекты для взаимодействия, персонаж игрока будут находится тут
3. plugin - тоже built-in интерфейс к плагин тулзам
	, который в отличии от других доступен только на самом верхнем уровне скрипта. В импотрируемые модули его нужно передавать отдельно.
4. У каждого объекта могут быть дети, то есть каждый объект может работать как папка. 
	Чтобы отразить это вне роблокса, я буду создавать скрипт и одноименную папку - воспринимайте это как один объект

### Сервисы и библиотеки

Сервисы получаются через game:GetService("ServiceName") либо game.ServiceName


1. InsertService. Ассеты не хранятся в проекте - они загружаются на сервера роблокса и прокидываются в игру по id. К таким ассетам относятся изображения, аудио, меши и PackageLink.
	Последние являются внутриигровым объектом, упакованные в ассет синхронизирующийся между разными проектами.
2. PackageLink. Является дочерним объектом пакета, который хранит в себе метаданные. Является указателем на то, что родитель = пакет. 
3. ReplicatedStorage. Хранилище объектов, скриптов и конфигураций которые дублирются на сервер и клиент. Любой скрипт может получить доступ к этому хранилищу
4. ServerScriptService. Скрипты, ответственные за серверную логику.
5. ServerStorage. Хранилище сервера, не доступное клиенту, в отличии от ReplicatedStorage

## Примечания

1. Комменты, которые я добавил во время импортирования скриптов, я помечаю как `NEW_COM`, чтобы пояснять специфики принятых решений.
2. У игровых объектов которые наследуют `Instance` есть Аттрибуты. Это Read/Write параметры по ключам, можно сказать что у каждого объекта есть свой словарь.
	К сожалению, писать туда можно только простые объекты.