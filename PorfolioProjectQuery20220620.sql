use PortfolioProject

Select *
From PortfolioProject..CovidDeaths
--coutinent is Null, the location represent is a continent
Where continent is not Null
Order by 3, 4




--Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not Null
Order by 1, 2   



--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your counry

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where Location like '%States%' 
And continent is not Null
--And date = '2022-06-19'
Order by 1, 2 

--Looking at Total Case vs Population
--Shows what percentage of population got covid

Select Location, date, total_cases, population, (total_cases/population) * 100 As ContractPercentage
From PortfolioProject..CovidDeaths
Where 
--Location like '%States%' 
--And 
date = '2022-06-19'
And continent is not Null
Order by 1, 2   

--Looking at Countries with Highest Infection Rate compared to Population
Select Location, population, MAX(total_cases) As HightestInfectionCount, (MAX(total_cases)/population) * 100 As InfectedPercentage
From PortfolioProject..CovidDeaths
Where continent is not Null
--Where 
--Location like '%States%' 
--And 
--date = '2022-06-19'
Group by Location, Population
Order by InfectedPercentage desc


--Showing Countries with highest Death Count per Population
--Change total_deaths to int
Select Location, MAX(Cast(total_deaths as int)) As TotalDeathsCount
From PortfolioProject..CovidDeaths
--Where continent is not Null
--Where 
--Location like '%States%' 
--And 
--date = '2022-06-19'
Group by Location
Order by TotalDeathsCount desc


--Let's break things down by continent
--Showing Countries with highest Death Count per Population
--Change total_deaths to int
Select location, MAX(Cast(total_deaths as int)) As TotalDeathsCount
From PortfolioProject..CovidDeaths
Where continent is Null and location not like '%income%'
--Where 
--Location like '%States%' 
--And 
--date = '2022-06-19'
Group by location
Order by TotalDeathsCount desc

--Showing the relationship between continents and countries
Select continent, location
From PortfolioProject..CovidDeaths
Group by continent, location
Order by continent


--Showing the countries in every contient with the highest death count
Select continent, MAX(Cast(total_deaths as int)) As TotalDeathsCount
From PortfolioProject..CovidDeaths
Where continent is not Null 
--Location like '%States%' 
--And 
--date = '2022-06-19'
Group by continent
Order by TotalDeathsCount desc


--global numbers

Select date, MAX(total_cases)
From PortfolioProject..CovidDeaths
Where continent is Null
Group by date
Order by date

Select 
SUM(new_cases) As total_case
--change new_deaths data type
, SUM(CAST(new_deaths as int)) As total_death
, SUM(CAST(new_deaths as int))/SUM(new_cases)* 100 As Deathpercentage
From PortfolioProject..CovidDeaths
Where 
continent is not  Null  
--Group by date
Order by 1,2


Select *
From PortfolioProject..CovidDeaths
Where continent is not Null
Order by 2, 3, 4


Select * 
From PortfolioProject..CovidVaccinations
Where continent is not Null
Order by 2, 3, 4

--Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.population
,sum(CAST(vac.new_vaccinations As bigint))
--change new_vaccinations data type
--, SUM(CAST(vac.new_vaccinations As int)) 
--, SUM(CONVERT(int, vac.new_vaccinations))
From PortfolioProject..CovidDeaths As dea
Join PortfolioProject..CovidVaccinations As vac
	On 
	dea.location = vac.location
	and 
	dea.date = vac.date
Where dea.continent is not Null and vac.new_vaccinations is not Null
--and vac.new_vaccinations is not Null
Group by dea.continent
, dea.location, dea.population
--Order by new_vac


Select dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) 
-- use OVER group by dea.location
OVER (Partition by dea.Location 
-- use order to accumulate
Order by dea.date
)  As RollingPeopleVaccinated
--, RollingPeopleVaccinated/population
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--and dea.location = 'Albania'
--and vac.new_vaccinations is not null
order by 2,3

--Use cte

With PopvsVac (continent, location, date, population, new_vacinations, RollingpeopleVaccinated)
as
(
Select dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) 
-- use OVER group by dea.location
OVER (Partition by dea.Location 
-- use order to accumulate
Order by dea.date
)  As RollingPeopleVaccinated
--, RollingPeopleVaccinated/population
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--and dea.location = 'Albania'
--and vac.new_vaccinations is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



--temp table
Create Table #Per
(
Continent nvarchar(255),
Location nvarchar(255),
Date nvarchar(255),
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
) 
Insert into #Per







--Creating View to store data for later visualizations

Create View Percentage as
Select dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) 
-- use OVER group by dea.location
OVER (Partition by dea.Location 
-- use order to accumulate
Order by dea.date
)  As RollingPeopleVaccinated
--, RollingPeopleVaccinated/population
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--and dea.location = 'Albania'
--and vac.new_vaccinations is not null
--order by 2,3

Select *
From Percentage



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 








