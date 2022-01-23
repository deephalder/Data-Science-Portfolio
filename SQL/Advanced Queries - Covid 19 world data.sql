--select *
--from ['Covid Deaths']
--order by 3,4

--select * 
--from ['Covid Vaccinations']
--order by 3,4

-- select data tat we are going to use

select location,date,total_cases,new_cases,cast(total_deaths as int),population
from ['Covid Deaths']
where continent is not null
order by 5 DESC


-- Total cases/total deaths
-- Shows likelihood of dying if you contract covid in your country


--select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
--from ['Covid Deaths']
--where location like'%India%'
--order by Location, DeathPercentage desc


-- Looking  at total cases / population
--shows us what percentage of the population got covid

select location,date,total_cases,population,(total_cases/population)*100 as InfectionPercentage
from ['Covid Deaths']
where continent is not null
--where location like'%India%'
order by 1,2 desc


-- Looking at countries with highest infection rate compared to population.
select location,population, MAX(total_cases) as HighestInfectionDailyCount,Max(total_cases/population)*100 as HighestInfectionRate
from ['Covid Deaths']
where continent is not null
group by location,population
order by 4 desc
--where location like'%India%'


-- Looking at highest death count per population.

select location ,population, MAX(cast(total_deaths as int)) as HighestDeathsDailyCount,Max(total_deaths/population)*100 as HighestDeathRate
from ['Covid Deaths']
where continent is not null
group by location,population
order by 4 desc
--where location like'%India%'

-- Showing continents with highest death count 
select continent , MAX(cast(total_deaths as int)) as HighestDeathsDailyCount
from ['Covid Deaths']
where continent is not  null
group by continent
order by 2 desc
--where location like'%India%'


-- Global numbers

--Daily new cases . daily new deaths, daily death rate

select date, SUM(new_cases) as DailyNewCases,sum(cast(new_deaths as int)) as DailyTotalDeaths , (sum(cast(new_deaths as int))/SUM(new_cases))*100 as DailyDeathPercentage
from ['Covid Deaths']
where continent is not  null
group by date
order by 1
--where location like'%India%'

--total global cases and deaths.
select SUM(new_cases) as DailyNewCases,sum(cast(new_deaths as int)) as DailyTotalDeaths , (sum(cast(new_deaths as int))/SUM(new_cases))*100 as DailyDeathPercentage
from ['Covid Deaths']
where continent is not  null


-- Looking at the number of people in the world that has been vaccinated.

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(bigint,vac.new_vaccinations)) over( Partition by dea.location order by dea.location,dea.date) as CumalativePeopleVaccinated
from PortfolioProject..['Covid Deaths'] dea
join PortfolioProject..['Covid Vaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Using CTE

with Popsvac(Continent,Location,Date,Population,New_vaccinations,CumalativePeopleVaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(bigint,vac.new_vaccinations)) over( Partition by dea.location order by dea.location,dea.date) as CumalativePeopleVaccinated
from PortfolioProject..['Covid Deaths'] dea
join PortfolioProject..['Covid Vaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *,(CumalativePeopleVaccinated/Population)*100 as PopulationVaccinationPercantage
from Popsvac


-- Temp table
Drop table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(

Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations bigint,
CumalativePeopleVaccinated numeric
)

insert into #PercentagePopulationVaccinated

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(bigint,vac.new_vaccinations)) over( Partition by dea.location order by dea.location,dea.date) as CumalativePeopleVaccinated
from PortfolioProject..['Covid Deaths'] dea
join PortfolioProject..['Covid Vaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *,(CumalativePeopleVaccinated/Population)*100 as VaccinatedPercentage
from #PercentagePopulationVaccinated



-- Creating views

Create view PercentagePopulationVaccinated as

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(bigint,vac.new_vaccinations)) over( Partition by dea.location order by dea.location,dea.date) as CumalativePeopleVaccinated
from PortfolioProject..['Covid Deaths'] dea
join PortfolioProject..['Covid Vaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select * 
from PercentagePopulationVaccinated



Create view DailyDeathRate as 

select date, SUM(new_cases) as DailyNewCases,sum(cast(new_deaths as int)) as DailyTotalDeaths , (sum(cast(new_deaths as int))/SUM(new_cases))*100 as DailyDeathPercentage
from PortfolioProject..['Covid Deaths']
where continent is not  null
group by date
----where location like'%India%'

----total global cases and deaths.
--select SUM(new_cases) as DailyNewCases,sum(cast(new_deaths as int)) as DailyTotalDeaths , (sum(cast(new_deaths as int))/SUM(new_cases))*100 as DailyDeathPercentage
--from ['Covid Deaths']
--where continent is not  null