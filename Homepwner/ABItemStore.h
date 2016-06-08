//
//  ABItemStore.h
//  Homepwner
//
//  Created by Alexander Blokhin on 31.05.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABTableItem; // директива class существенно ускоряет время компиляции

@interface ABItemStore : NSObject

@property NSMutableArray *allItems;

+ (ABItemStore *)sharedInstance;

- (ABTableItem *)createItem;
- (void)removeItem:(ABTableItem *)item;
- (void)moveItemAtIndex:(int)from toIndex:(int)to;

- (NSString *)itemArchivePath;

- (BOOL)saveChanges;

@end

/* ---------- Песочница приложения ----------

 application bundle - В этом каталоге находятся все ресурсы и выполняемые файлы. Предназначен только для чтения.
 
 Library/Preferences - В данном каталоге находятся все настройки и здесь же приложение Settings ищет настройки приложения. Настройки Library/Preferences обрабатываются автоматически классом NSUserDefaults и резервируются при синхронизации устройства с iTunes либо с iCloud.
 
 tmp - В этом каталоге временно сохраняются данные во время выполнения приложения. По завершении работы с данными пользователь может удалить их, и после завершения выполнения приложения операционная система автоматически очищает этот каталог. Содержимое этого каталога не резервируется при синхронизации устройства с iTunes или iCloud. Чтобы получить путь к каталогу tmp в песочнице приложения, воспользуйтесь вспомогательной функцией NSTemporaryDirectory.
 
 Documents - В этом каталоге сохраняются данные, генерируемые приложением во время выполнения. Эти данные должны сохраняться между очередными сеансами выполнения приложения. Находящиеся в каталоге данные резервируются при синхронизации устройства с iTunes либо iCloud. Если с устройством возникают какие-либо проблемы, хранившиеся на нем данные могут быть восстановлены с iTunes или iCloud. Например, в игровом приложении могут быть восстановлены сохраненные файлы игры.
 
 Library/Caches - В этом каталоге сохраняются данные, генерируемые приложением во время выполнения. Эти данные должны сохраняться между очередными сеансами выполнения приложения. Но в отличие от каталога Documents, содержимое данного каталога не может резервироваться при синхронизации устройства с iTunes либо с iCloud. Основная причина отказа от резервирования кэшированных данных заключается втом, что объем этих данных может быть очень большим, а процесс синхронизации этих данных с устройством займет очень много времени. В этот каталог могут помещаться данные, сохраненные в других местах, например на веб-сервере. И если пользователю нужно восстановить устройство, эти данные могут быть повторно загружены с веб-сервера.
 
*/