/*
Where Statements
*/

--Select *
--from EmployeeDemographics
--where Firstname <> 'Jim'

--Select * 
--from EmployeeDemographics
--where Age < 32  AND Gender = 'Male'

--Select *
-- from EmployeeDemographics
-- where LastName like 'S%c%'


--Select *
--from EmployeeDemographics
--where LastName is not null 

Select *
from EmployeeDemographics
where FirstName in ('Jim','Michael')