-- First look at the database
Select * 
From [Covid exploration]..CovidDeaths 
Order by 3, 4

-- Selecting data that's going to be used 
Select Location, date, total_cases, total_deaths, population
From [Covid exploration]..CovidDeaths
Order by 1, 2

-- Looking at: Total_Cases vs Total_Deaths in Brazil
-- Likelihood of death in Brazil 
Select Location, date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases, 0))*100 as death_percentage
From [Covid exploration]..CovidDeaths
Where Location = 'Brazil'
Order by 1, 2

-- Looking at: Total_Cases vs Population in Brazil
-- Percentage of infected population
Select Location, date, Population, total_cases, (total_cases/NULLIF(population, 0))*100 as pop_infected_percentage
From [Covid exploration]..CovidDeaths
Where Location = 'Brazil'
Order by 1, 2

-- Looking at: Highest infection rate countries
Select Location, Population, MAX(total_cases) as highest_infection_count, MAX((total_cases/NULLIF(population, 0)))*100 as pop_infected_percentage
From [Covid exploration]..CovidDeaths
Group by Location, Population
Order by pop_infected_percentage desc -- descendent

-- Looking at: Highest death count vs Population
Select Location, MAX(total_deaths) as total_death_count
From [Covid exploration]..CovidDeaths
Where continent is not null -- removing continent's dataset view
Group by Location
Order by total_death_count desc 

-- BY CONTINENT
-- Looking at: Highest death count vs Population
Select continent, MAX(total_deaths) as total_death_count
From [Covid exploration]..CovidDeaths
Where continent is not null -- removing continent's dataset view
Group by continent
Order by total_death_count desc 


-- Looking at: Population vs Vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as total_vaccinations, total_vaccinations/NULLIF(dea.population,0)*100 as vac_pop_percentage
From [Covid exploration]..CovidDeaths as dea
Join [Covid exploration]..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


-- Creating a view of Infection rate
Create View LocationInfectionRate as
Select Location, Population, MAX(total_cases) as highest_infection_count, MAX((total_cases/NULLIF(population, 0)))*100 as pop_infected_percentage
From [Covid exploration]..CovidDeaths
Group by Location, Population





