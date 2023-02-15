
Select *
from [PortfolioProject]..CovidVaccinations
order by 3,4 ;

-- Death Percentage in	United Arab Emirates
select location , date, total_cases , new_cases , total_deaths , (total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths
where location like '%United Arab Emirates'
order by 1,2 ;

-- looking at Total Cases vs Population in United Arab Emirates 
select location , date, total_cases , new_cases , total_deaths , (total_cases/population)*100 AS total_population
from PortfolioProject..CovidDeaths
where location like '%United Arab Emirates'
order by 1,2 ; 

-- Looking at highest infection rate.
Select Location, population, Max(total_cases) as Highest_infection_count, Max((total_cases/population))*100 as percentage_population_infected
from PortfolioProject..CovidDeaths
group by population, location
order by percentage_population_infected desc ;

-- Countries with highest death count
Select Location, max(cast(total_deaths as int)) as total_death_count
from PortfolioProject..CovidDeaths
where continent is not null
group by Location
order by total_death_count desc ;

--showing the continent with highest death count
Select continent, max(cast(total_deaths as int)) as total_death_count
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by total_death_count desc ;

--Global Numbers

Select sum(new_cases) as total_case , sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int))/sum(new_cases)*100 AS death_percentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2 desc ;

--joining new tables

select *
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location and dea.date = vac.date

-- Looking at total population vs vaccination

select dea.continent , dea.location , dea.date , vac.new_vaccinations, dea.population
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- We have the column to display rolling count of vaccination by location

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as Rolling_vaccination_number
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- CTE

With PopvsVac(Continent, date, location , population, new_vaccinations , Rolling_vaccination_number)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as Rolling_vaccination_number
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
select *
from PopvsVac

--creating view to store data for later visualisation

create view percent_population_vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as Rolling_vaccination_number
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
