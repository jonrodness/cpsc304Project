Doctor
+------------+---------------+-------------+-------------------------------------------------+-------------+--------------------+
| LicenseNum | FirstName     | LastName    | Address                                         | PhoneNumber | Type               |
+------------+---------------+-------------+-------------------------------------------------+-------------+--------------------+
| 1232131241 | Bob           | Smith       | 1164 Robson St, Vancouver, BC V6E 1B2           | 6049238292  | Gynecologist       |
| 2743873823 | Kaneonuskatew | Kawacatoose | 307-1220 Pender St E, Vancouver, BC V6A 1W8     | 7782391233  | Gastroenterologist |
| 3409389847 | Eoin          | Raghnall    | 104-350 Kent Ave South E, Vancouver, BC V5X 4N6 | 7783422341  | Oncologist         |
| 3422344543 | Tau           | Dubaku      | 7547 Cambie St, Vancouver, BC V6P 3H6           | 6043421923  | Obstetrician       |
| 5483843482 | Alex          | Lee         | 6139 Battison St, Vancouver, BC V5S 3M7         | 7782313223  | Neonatologist      |
+------------+---------------+-------------+-------------------------------------------------+-------------+--------------------+

Patient
+-------------+-----------+------------+------+--------+--------+-------------------------------------------+-------------+
| CareCardNum | FirstName | LastName   | Age  | Weight | Height | Address                                   | PhoneNumber |
+-------------+-----------+------------+------+--------+--------+-------------------------------------------+-------------+
| 1099282394  | Jane      | Doe        |   50 |     56 |    150 | 868 Rainbow Road, Richmond, BC V6R 2S1    | 7782132349  |
| 1234567890  | Anny      | Gakhokidze |   19 |     90 |    160 | 23 12746 102nd street, Surrey, BC, V3T1V9 | 7783334455  |
| 1457629875  | Jon       | Rodness    |   20 |     90 |    175 | 1413 Velvet Path, Richmond, BC, V5S 7D8   | 6048790877  |
| 2346528765  | Alfred    | Sin        |   54 |     90 |    178 | 9722 Hazy Highlands, Lick, BC, V2W 9U5    | 6045678765  |
| 3453438890  | Chris     | Louie      |   21 |     90 |    187 | 666 Deep Dark Road, Surrey, BC V6X 6H6    | 7783921833  |
+-------------+-----------+------------+------+--------+--------+-------------------------------------------+-------------+

Prescription
+------------+-------------+---------+--------------------------------------+-------------+----------------+-----------------+
| LicenseNum | PrescriptID | Refills | Dosage                               | CareCardNum | ReadyForPickUp | date_prescribed |
+------------+-------------+---------+--------------------------------------+-------------+----------------+-----------------+
| 1232131241 | 0001        |      10 | 4 pills 2 times per day for 10 days  | 1234567890  |              1 | 2012-08-22      |
| 1232131241 | 0002        |      10 | 4 pills 2 times per day for 10 days  | 1234567890  |              1 | 2012-08-23      |
| 1232131241 | 0003        |      10 | 4 pills 2 times per day for 10 days  | 1234567890  |              1 | 2012-08-24      |
| 5483843482 | 0004        |       0 | 1 tbsp 1 time per day for 1 day      | 2346528765  |              0 | 2014-05-10      |
| 5483843482 | 0005        |       0 | 1 tbsp 1 time per day for 1 day      | 2346528765  |              0 | 2014-05-10      |
| 5483843482 | 0006        |       0 | 1 tbsp 1 time per day for 1 day      | 2346528765  |              0 | 2014-05-10      |
| 5483843482 | 0007        |       0 | 1 tbsp 1 time per day for 1 day      | 2346528765  |              0 | 2014-05-10      |
| 5483843482 | 0008        |       0 | 1 tbsp 1 time per day for 1 day      | 2346528765  |              0 | 2014-05-10      |
| 3409389847 | 0045        |       3 | 1 pill 12 times per day for 3 days   | 1099282394  |              1 | 2012-12-21      |
| 2743873823 | 0098        |       2 | 1 pill 3 times per day for 10 days   | 3453438890  |              1 | 2012-12-12      |
| 2743873823 | 0198        |       2 | 1 pill 3 times per day for 10 days   | 3453438890  |              1 | 2012-12-12      |
| 2743873823 | 0298        |       2 | 1 pill 3 times per day for 10 days   | 3453438890  |              1 | 2012-12-12      |
| 2743873823 | 0398        |       2 | 1 pill 3 times per day for 10 days   | 3453438890  |              1 | 2012-12-12      |
| 2743873823 | 0498        |       2 | 1 pill 3 times per day for 10 days   | 3453438890  |              1 | 2012-12-12      |
| 1232131241 | 1111        |      10 | 4 pills 2 times per day for 10 days  | 1234567890  |              1 | 2012-08-24      |
| 1232131241 | 1112        |      10 | 4 pills 2 times per day for 10 days  | 1234567890  |              1 | 2012-08-24      |
| 1232131241 | 1113        |      10 | 4 pills 2 times per day for 10 days  | 1234567890  |              1 | 2012-08-24      |
| 1232131241 | 1114        |      10 | 4 pills 2 times per day for 10 days  | 1234567890  |              1 | 2012-08-24      |
| 1232131241 | 2345        |      10 | 4 pills 2 times per day for 10 days  | 1234567890  |              1 | 2015-03-21      |
| 1232131241 | 2959        |       5 | 2 pills 4 times per day for 5 days   | 1234567890  |              1 | 2012-10-26      |
| 5483843482 | 3456        |      10 | 1 tbsp 1 time per day for 1 day      | 2346528765  |              1 | 2014-05-10      |
| 5483843482 | 3457        |      10 | 1 tbsp 1 time per day for 1 day      | 2346528765  |              1 | 2014-05-10      |
| 3422344543 | 9876        |     200 | 12 pills 8 times per day for 45 days | 1457629875  |              0 | 2013-12-16      |
+------------+-------------+---------+--------------------------------------+-------------+----------------+-----------------+

Drug
+-------------+--------------------+---------------------------+-------+
| BrandName   | GenericName        | CompanyName               | Price |
+-------------+--------------------+---------------------------+-------+
| Advil       | Ibuprofen          | Pfizer                    |    11 |
| Aubagio     | Teriflunomide      | Sanofi                    |    10 |
| Avapro      | irbesartan         | Bristol-Myers Squibb      |    10 |
| Biaxin      | Clarithromycin     | Abbott Laboratories       |    50 |
| Coumadin    | Warfarin           | Bristol-Myers Squibb      |    40 |
| Klor-Con    | Potassium Chloride | Upsher-Smith Laboratories |    35 |
| Lipitor     | Atorvastatin       | Pfizer                    |    30 |
| Lovenox     | Clopidogrel        | Sanofi                    |    10 |
| MagicDrug   | Clindamycin        | DatabaseDrugs Inc.        |    60 |
| Mipomereson | Kynamro            | Sanofi                    |    10 |
| Niaspan     | Niacin             | Abbott Laboratories       |    45 |
| Plavix      | Clopidogrel        | Sanofi                    |    20 |
| Ritalin     | Methylphenidate    | Novartis                  |    50 |
| Tylenol     | Acetaminophen      | Johnson and Johnson       |    10 |
| Viagra      | Sildenafil         | Pfizer                    |    40 |
| Zestril     | Lisinopril         | Apotex Inc.               |    50 |
| Zocor       | Simvastatin        | Pfizer                    |    99 |
+-------------+--------------------+---------------------------+-------+


Includes
+-------------+-------------+-----------------+
| PrescriptID | BrandName   | GenericName     |
+-------------+-------------+-----------------+
| 0001        | Advil       | Ibuprofen       |
| 0004        | Advil       | Ibuprofen       |
| 3456        | Advil       | Ibuprofen       |
| 1111        | Aubagio     | Teriflunomide   |
| 1114        | Avapro      | irbesartan      |
| 0002        | Coumadin    | Warfarin        |
| 0003        | Coumadin    | Warfarin        |
| 0045        | Coumadin    | Warfarin        |
| 0005        | Lipitor     | Atorvastatin    |
| 0198        | Lipitor     | Atorvastatin    |
| 1112        | Lovenox     | Clopidogrel     |
| 3457        | Lovenox     | Clopidogrel     |
| 1113        | Mipomereson | Kynamro         |
| 0098        | Plavix      | Clopidogrel     |
| 9876        | Ritalin     | Methylphenidate |
| 2345        | Tylenol     | Acetaminophen   |
| 0007        | Viagra      | Sildenafil      |
| 0398        | Viagra      | Sildenafil      |
| 0006        | Zocor       | Simvastatin     |
| 0298        | Zocor       | Simvastatin     |
+-------------+-------------+-----------------+


InteractsWith
+------------+--------------------+------------+----------------+
| dBrandName | dGenericName       | iBrandName | iGenericName   |
+------------+--------------------+------------+----------------+
| Viagra     | Sildenafil         | Biaxin     | Clarithromycin |
| Advil      | Ibuprofen          | Coumadin   | Warfarin       |
| Zocor      | Simvastatin        | Coumadin   | Warfarin       |
| Niaspan    | Niacin             | Lipitor    | Atorvastatin   |
| Klor-Con   | Potassium Chloride | Zestril    | Lisinopril     |
+------------+--------------------+------------+----------------+


Pharmacy
+------------------------------------------+------------------------------+-------------+---------------------+---------------------+---------------------+---------------------+
| Address                                  | Name                         | PhoneNumber | WeekdayHoursOpening | WeekdayHoursClosing | WeekendHoursOpening | WeekendHoursClosing |
+------------------------------------------+------------------------------+-------------+---------------------+---------------------+---------------------+---------------------+
| 102-888 8th Ave W, Vancouver, BC V5Z 3Y1 | Costco Wholesale Pharmacy    | 7782313849  | 09:00:00            | 20:00:00            | 10:00:00            | 18:00:00            |
| 3303 Main St, Vancouver, BC V5V 3M8      | Shoppers Drug Mart           | 7783289580  | 08:30:00            | 22:00:00            | 10:30:00            | 18:00:00            |
| 4255 Arbutus St, Vancouver, BC V6J 4R1   | Safeway Pharmacy             | 6047316252  | 08:30:00            | 22:00:00            | 08:30:00            | 22:00:00            |
| 6180 Fraser St, Vancouver, BC V5W 3A1    | The Medicine Shoppe Pharmacy | 6042333233  | 08:00:00            | 22:30:00            | 11:00:00            | 18:00:00            |
| 885 Broadway W, Vancouver, BC V5Z 1J9    | Shoppers Drug Mart           | 6047081135  | 08:00:00            | 22:00:00            | 10:00:00            | 18:00:00            |
+------------------------------------------+------------------------------+-------------+---------------------+---------------------+---------------------+---------------------+


OrderedFrom;
+-------------+------------------------------------------+-------------+
| PrescriptID | PharmacyAddress                          | OrderNo     |
+-------------+------------------------------------------+-------------+
| 2345        | 885 Broadway W, Vancouver, BC V5Z 1J9    | 03457436534 |
| 0003        | 6180 Fraser St, Vancouver, BC V5W 3A1    | 41327584123 |
| 0002        | 6180 Fraser St, Vancouver, BC V5W 3A1    | 41327584321 |
| 9876        | 4255 Arbutus St, Vancouver, BC V6J 4R1   | 41327584378 |
| 0001        | 6180 Fraser St, Vancouver, BC V5W 3A1    | 41327584379 |
| 3456        | 3303 Main St, Vancouver, BC V5V 3M8      | 54362785237 |
| 0098        | 102-888 8th Ave W, Vancouver, BC V5Z 3Y1 | 64389564389 |
+-------------+------------------------------------------+-------------+


TimeBlock;
+---------------+-----------+----------+
| TimeBlockDate | StartTime | EndTime  |
+---------------+-----------+----------+
| 2015-04-03    | 09:00:00  | 10:00:00 |
| 2015-04-03    | 10:30:00  | 11:00:00 |
| 2015-04-03    | 11:30:00  | 12:00:00 |
| 2015-07-04    | 16:00:00  | 16:30:00 |
| 2015-07-14    | 13:00:00  | 15:00:00 |
| 2015-10-24    | 15:00:00  | 16:00:00 |
| 2874-06-07    | 09:00:00  | 12:00:00 |
+---------------+-----------+----------+


MakesAppointmentWith;
+----------+------------+------------+---------------+-----------+----------+-------------+
| TimeMade | DateMade   | LicenseNum | TimeBlockDate | StartTime | EndTime  | CareCardNum |
+----------+------------+------------+---------------+-----------+----------+-------------+
| 09:00:00 | 2015-04-03 | 1232131241 | 2015-04-03    | 09:00:00  | 10:00:00 | 1234567890  |
| 09:30:00 | 2015-04-02 | 1232131241 | 2015-04-03    | 10:30:00  | 11:00:00 | 1234567890  |
| 09:00:00 | 2015-04-01 | 1232131241 | 2015-04-03    | 11:30:00  | 12:00:00 | 1234567890  |
| 08:30:00 | 2015-07-04 | 2743873823 | 2015-07-04    | 16:00:00  | 16:30:00 | 1099282394  |
| 14:30:00 | 2015-10-24 | 3409389847 | 2015-10-24    | 15:00:00  | 16:00:00 | 3453438890  |
| 11:30:00 | 2015-07-14 | 3422344543 | 2015-07-14    | 13:00:00  | 15:00:00 | 1457629875  |
| 10:00:00 | 2874-06-08 | 5483843482 | 2874-06-07    | 09:00:00  | 12:00:00 | 2346528765  |
+----------+------------+------------+---------------+-----------+----------+-------------+