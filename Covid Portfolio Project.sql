-- select data that we are going to be starting with

SELECT location, date, population, total_cases,total_deaths 
FROM coviddeath 
WHERE continent IS NOT null


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT location, date, population, total_cases,total_deaths, 
(cast(total_deaths as numeric)/cast(total_cases as numeric))*100 AS "Death Rate"
FROM coviddeath 
WHERE location = 'Malaysia'
AND continent IS NOT null
ORDER BY date

-- Total Cases vs Population
-- Shows the percentage of covid infection over population

SELECT location, date, total_cases, population, 
(CAST(total_cases AS numeric)/CAST(population AS numeric))*100 AS "Infection Rate"
FROM coviddeath
--WHERE location = 'Malaysia'
WHERE continent IS NOT null
ORDER BY 1,2

-- latest infection rate by location

SELECT location, max(total_cases) AS total_cases, population, 
max((cast(total_cases AS numeric)/cast(population AS numeric))*100) AS "Infection Rate"
FROM coviddeath
--where location = 'Malaysia'
WHERE continent IS NOT null
GROUP BY location , population
ORDER BY "Infection Rate" DESC

-- Country with Highest Death Count per polulation

SELECT location, max(total_deaths) AS total_death
FROM coviddeath
--where location = 'Malaysia'
WHERE continent IS NOT null
GROUP BY location
ORDER BY "total_death" DESC


-- BREAKING THINGS DOWN BY CONTINENT
-- Showing continents with highest death count per population

SELECT continent, max(total_deaths) AS total_death
FROM coviddeath
WHERE continent IS NOT null
GROUP BY continent
ORDER BY total_death DESC

-- Global number

SELECT 
SUM(new_cases) AS "total cases", 
SUM(new_deaths) AS "total deaths", 
CAST((SUM(new_deaths)) AS numeric)/CAST((SUM(new_cases)) AS numeric)*100 AS "Total death rate" 
FROM coviddeath
WHERE continent IS NOT null

-- Total Population vs Vaccinations
-- Percentage of Population received at least one dose of Covid Vacine

SELECT location, date, population,new_vaccinations, 
SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location,date) AS "total vaccine given", 
people_fully_vaccinated,
(CAST (people_fully_vaccinated AS numeric)/CAST(population AS numeric))*100 AS "Fully Vaccinated Rate",
(CAST ((SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location,date)) AS numeric)/CAST(population AS numeric))*100 AS "Vaccination Rate"
FROM covidvaccination
WHERE location = 'Malaysia'
AND continent IS NOT null
ORDER BY date

-- Using CTE to perform Calculation on Partition By in previous query

With Vaccination_Percentage 
(location,date,population,new_vaccinations,total_vaccine_given,people_fully_vaccinated) AS
(
SELECT 
  dea.location, 
  dea.date, 
  dea.population, 
  vac.new_vaccinations, 
  SUM(vac.new_vaccinations) OVER (PARTITION BY vac.location ORDER BY vac.location,vac.date) AS total_vaccine_given, 
  vac.people_fully_vaccinated
FROM coviddeath AS dea
LEFT JOIN covidvaccination AS vac
ON dea.location =vac.location 
  AND dea.date=vac.date
WHERE dea.continent IS NOT null
)
SELECT * , 
  (total_vaccine_given/population)*100 AS "Vaccination Rate", 
  (CAST (people_fully_vaccinated AS numeric)/CAST (population AS numeric))*100 AS "Fully Vaccinated Rate" 
FROM Vaccination_Percentage
WHERE location = 'Malaysia'
ORDER BY date

-- Creating View for Visualization

CREATE View PercentPopulationVaccinated AS
SELECT location, date, population,new_vaccinations, 
SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location,date) AS "total vaccine given", 
people_fully_vaccinated,
(CAST (people_fully_vaccinated AS numeric)/CAST(population AS numeric))*100 AS "Fully Vaccinated Rate",
(CAST ((SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location,date)) AS numeric)/CAST(population AS numeric))*100 AS "Vaccination Rate"
FROM covidvaccination
WHERE continent IS NOT null
