Select *
From PortfolioProject..coviddeaths
Where continent is not null
order by 3, 4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3, 4

--Select Data that we are going to be using


Select Location, date, total_cases, new_cases, total_deaths, population  
From PortfolioProject..coviddeaths
order by 1, 2

-- Looking at the Total Cases vs Total Deaths
-- Shows likelyhood of dying if you contract covid in your country

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..covidDeaths
Where location like '%states%'
order by 1,2


-- Looking at the Total Cases vs Population 
-- Shows what percentage of population got covid


Select location, date, total_cases,population, 
(CONVERT(float, population) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..covidDeaths
--Where location like '%states%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population


Select location, Population, MAX(total_cases) as HighestInfectionCount, MAX((Total_cases/population))*100 as
PercentPopulationInfected
from PortfolioProject..covidDeaths
--Where location like '%states%'
Group by location, Population
order by PercentPopulationInfected desc


--Showing Countries with Highest Death Count per Population 


Select location,  MAX(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

Select continent,  MAX(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeaths
--Where location like '%states%'
Where continent is  not null
Group by continent
order by TotalDeathCount desc  


-- Showing continents with the highest death count per population 


Select continent,  MAX(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..covidDeaths
--Where location like '%states%'
Where continent is  not null
Group by continent
order by TotalDeathCount desc 



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..covidDeaths
--Where location like '%states%'
Where continent is  not null
Group By date
order by 1,2


-- Looking at Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CAST(vac.new_vaccinations as Float)) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From PortfolioProject..coviddeaths dea
Join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- USE CTE

With PopvsVac ( Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CAST(vac.new_vaccinations as Float)) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..coviddeaths dea
Join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CAST(vac.new_vaccinations as Float)) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..coviddeaths dea
Join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(CAST(vac.new_vaccinations as Float)) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..coviddeaths dea
Join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3























