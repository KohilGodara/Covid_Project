Select *
From PortfolioProject.dbo.CovidDeaths
Where continent is Not Null
Order by 3,4

Alter Table CovidDeaths
Add Population Float

Update t1
set t1.Population = t2.Population
from CovidDeaths t1 inner join CovidVaccination t2 on t1.location = t2.location and t1.date = t2.date

Select Location, date, Total_cases, Total_deaths, Population
From PortfolioProject..CovidDeaths
Where continent is Not Null
order by 1,2

-- Looking at Total Cases vs Total Deaths

Alter table PortfolioProject..CovidDeaths
Add FloatTotal_deaths float

Update PortfolioProject..CovidDeaths
set FloatTotal_deaths = CONVERT(float, total_deaths)


Alter table PortfolioProject..CovidDeaths
Add FloatTotal_Cases float

Update PortfolioProject..CovidDeaths
set FloatTotal_Cases = CONVERT(float, total_Cases)

-- Shows Likelihood of dying if you contract covid in your country

Select Location, date, Total_cases, Total_deaths, (Floattotal_deaths/Floattotal_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
-- where Location = 'India'
Where continent is Not Null
order by 1,2

-- Looking at Total_cases vs Population 
-- Shows what percentage of population got Covid

Select Location, date, Total_cases, Population, (Floattotal_Cases/Population)*100 as Percentagepopulationinfected
From PortfolioProject..CovidDeaths
-- where Location = 'India'
Where continent is Not Null
order by 1,2 

-- Looking at country with Highest  Infection Rate Compared to Population

Select Location ,Population ,Max(FloatTotal_cases) as HighestInfectedCount ,Max((Floattotal_Cases/Population)*100) as Percentagepopulationinfected
From PortfolioProject..CovidDeaths
-- where Location = 'India'
Where continent is Not Null
group by location, Population
order by Percentagepopulationinfected Desc

-- Showing Countries  with Highest Death Count per Population

Select Location, Population, Max(FloatTotal_deaths) as TotalDeathCount, Max((Floattotal_deaths/Population)*100) as DeathPercentage
From PortfolioProject..CovidDeaths
-- where Location = 'India'
Where continent is Not Null
Group by location, Population
order by TotalDeathCount Desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

 -- Showing continents with the highest death count per population


Select Location, Max(FloatTotal_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is Null
Group by location 
order by TotalDeathCount Desc

-- Global Numbers


Select date, Sum(new_cases) as Total_cases, Sum(new_deaths) as total_deaths, Sum(new_deaths)/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
-- where Location = 'India'
Where continent is Not Null 
Group by date
having Sum(new_cases) <> 0
order by 1,2


-- Looking at total Population vs Vaccinations

With PopvsVac  as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccination vac
    on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and dea.location = 'India'
--order by 2,3
)
Select * , (RollingPeopleVaccinated/Population)*100
From PopvsVac


select location, sum(cast(new_Deaths as int)) as total
From PortfolioProject..CovidDeaths
where continent is not null
group by location
order by total Desc

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
join  PortfolioProject..CovidVaccination vac
    on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and dea.location = 'India'
--order by 2,3

Select * 
From PercentPopulationVaccinated






