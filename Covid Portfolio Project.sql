-- select data that we are going to be starting with

select location, date, population, total_cases,total_deaths 
from coviddeath where continent is not null


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select location, date, population, total_cases,total_deaths, 
(cast(total_deaths as numeric)/cast(total_cases as numeric))*100 as "Death Rate"
from coviddeath 
where location = 'Malaysia'
and continent is not null
order by date

-- Total Cases vs Population
-- Shows the percentage of covid infection over population

select location, date, total_cases, population, 
(cast(total_cases as numeric)/cast(population as numeric))*100 as "Infection Rate"
from coviddeath
--where location = 'Malaysia'
where continent is not null
order by 1,2

-- latest infection rate by location

select location, max(total_cases) as total_cases, population, 
max((cast(total_cases as numeric)/cast(population as numeric))*100) as "Infection Rate"
from coviddeath
--where location = 'Malaysia'
where continent is not null
group by location , population
order by "Infection Rate" desc

-- Country with Highest Death Count per polulation

select location, max(total_deaths) as total_death
from coviddeath
--where location = 'Malaysia'
where continent is not null
group by location
order by "total_death" desc


-- BREAKING THINGS DOWN BY CONTINENT
-- Showing continents with highest death count per population

select continent, max(total_deaths) as total_death
from coviddeath
where continent is not null
group by continent
order by total_death desc

-- Global number

select 
sum(new_cases) as "total cases", 
sum(new_deaths) as "total deaths", 
cast((sum(new_deaths)) as numeric)/cast((sum(new_cases)) as numeric)*100 as "Total death rate" 
from coviddeath
where continent is not null

-- Total Population vs Vaccinations
-- Percentage of Population received at least one dose of Covid Vacine

select location, date, population,new_vaccinations, 
sum(new_vaccinations) over (partition by location order by location,date) as "total vaccine given", 
people_fully_vaccinated,
(cast (people_fully_vaccinated as numeric)/cast(population as numeric))*100 as "Fully Vaccinated Rate",
(cast ((sum(new_vaccinations) over (partition by location order by location,date)) as numeric)/cast(population as numeric))*100 as "Vaccination Rate"
from covidvaccination
where location = 'Malaysia'
and continent is not null
order by date

-- Using CTE to perform Calculation on Partition By in previous query

With Vaccination_Percentage 
(location,date,population,new_vaccinations,total_vaccine_given,people_fully_vaccinated) as
(
Select 
dea.location, 
dea.date, 
dea.population, 
vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by vac.location order by vac.location,vac.date) as total_vaccine_given, 
vac.people_fully_vaccinated
from coviddeath as dea
left join covidvaccination as vac
on dea.location =vac.location and dea.date=vac.date
where dea.continent is not null
)
select * , (total_vaccine_given/population)*100 as "Vaccination Rate", (cast (people_fully_vaccinated as numeric)/cast (population as numeric))*100 as "Fully Vaccinated Rate" from Vaccination_Percentage
where location = 'Malaysia'
order by date

-- Creating View for Visualization

Create View PercentPopulationVaccinated as
select location, date, population,new_vaccinations, 
sum(new_vaccinations) over (partition by location order by location,date) as "total vaccine given", 
people_fully_vaccinated,
(cast (people_fully_vaccinated as numeric)/cast(population as numeric))*100 as "Fully Vaccinated Rate",
(cast ((sum(new_vaccinations) over (partition by location order by location,date)) as numeric)/cast(population as numeric))*100 as "Vaccination Rate"
from covidvaccination
where continent is not null
