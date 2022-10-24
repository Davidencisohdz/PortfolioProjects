select *
FROM
Portfolio_project.dbo.CovidDeaths
Where continent is not null 
order by location, date


--select *
--FROM
--Portafolio_project.dbo.CovidVaccinations
--order by location, date

select location, date, total_cases, new_cases, total_deaths, population 
FROM Portfolio_project..CovidDeaths
order by location, date

-- Percentage of total_deaths per total_cases
-- precentage in every country

select location, date, total_cases, new_cases, total_deaths, (total_deaths / total_cases)*100 as Death_Percentage 
FROM Portfolio_project..CovidDeaths
where location like '%norway%'
order by location, date

-- Total cases vs population
-- Shows what percentage pf population got covid

select location, date, total_cases, population, (total_cases / population)*100 as cases_percentage 
FROM Portfolio_project..CovidDeaths
where location like '%States%'
order by location, date

-- highest infection rate in the world

select location, population, max(total_cases) as highest_infectionCount , max((total_cases / population))*100 as  max_cases_percentage 
FROM Portfolio_project..CovidDeaths

Group by population, location
order by max_cases_percentage desc


-- Highest death count in a certain location 

select location, Max( cast(total_deaths as int)) as TotalDeathCount 
FROM Portfolio_project..CovidDeaths
WHERE continent is not NULL
Group by location
order by TotalDeathCount Desc

-- Total death count by continent or region

select location, Max( cast(total_deaths as int)) as TotalDeathCount 
FROM Portfolio_project..CovidDeaths
WHERE continent is NULL
Group by location
order by TotalDeathCount Desc


-- Global Numbers

select SUM(new_cases) as total_cases_sum, sum(cast(new_deaths as int)) as total_new_deaths, 
   sum(cast(new_deaths as int)) /sum(new_cases)*100 as DeathPercentage
FROM Portfolio_project..CovidDeaths
WHERE continent is not NULL
order by 1,2



-- Joining both files by date

select *
from Portfolio_project..CovidDeaths dea
join Portfolio_project..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date

-- Display the continent, location, date, population, and new vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from Portfolio_project..CovidDeaths dea
join Portfolio_project..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not  NULL
order by dea.location, dea.date

-- Display the sum of total vaccinations per date and per location 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
from Portfolio_project..CovidDeaths dea
join Portfolio_project..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not  NULL
order by dea.location, dea.date



-- Temp table
Drop table if exists #PercentPopulationVaccinated

Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
from Portfolio_project..CovidDeaths dea
join Portfolio_project..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not  NULL
order by dea.location, dea.date

Select *, (RollingPeopleVaccinated / Population ) *100 AS percentage_of_population_vaccinated
FROM #PercentPopulationVaccinated 

--	Creating view to store data for later visualizations


Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
from Portfolio_project..CovidDeaths dea
join Portfolio_project..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not  NULL














  






-- 


