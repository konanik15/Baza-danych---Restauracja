USE EventCreator
GO

INSERT INTO [dbo].Settings(Name,Description,IntValue) 
	VALUES('StudentPercentageDiscount', 
		   'Procent o jaki zostanie obniżona cena warsztatów/konferencji dla studenta.', 
	       15)

EXEC [dbo].AddWorkshopType @name = 'Marten jako event store w postgresql.', @description = '', @price = 499.99;
EXEC [dbo].AddWorkshopType @name = 'Event storming w Twojej firmie.', @description = '', @price = 899.99;