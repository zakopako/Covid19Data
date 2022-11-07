Select * from RawCovidData;

--General overview of the Covid-19 Data
Select Location, date, total_cases, new_cases, total_deaths, population
from RawCovidData
Order by 1,2

-- Looking at the Number of Cases, the Number of deaths, and the percentage of people who died from covid-19
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
from RawCovidData
Order by 1,2

--Looking at the percentage of the population that has gotten Covid-19 in Canada
Select Location, date, total_cases, Population, (total_cases/Population)*100 As '%ofPopulationInfected'
from RawCovidData
Where continent is not null and Location = 'Canada'
Order by 1,2

--Ranking Countries by the percentage of the population that has been infected with Covid-19
Select Location, Max(total_cases) As HighestCaseCountPerCountry, Population, MAX(total_cases/Population)*100 As '%ofPopulationInfected'
from RawCovidData
Where continent is not null
Group by Location, Population
Order By '%ofPopulationInfected' DESC

--Ranking Countries by the number of people dead from Covid-19 and contrasting it with the percentage of the population dead from covid
Select Location, Max(cast(total_deaths as int)) As HighestDeathCountPerCountry, Population, MAX(total_deaths/Population)*100 As '%ofPopulationDeadFromCovid'
from RawCovidData
Where continent is not null
Group by Location, Population
Order By HighestDeathCountPerCountry DESC, '%ofPopulationDeadFromCovid' DESC

-- Looking at the death count of each continent and the death count of the world
Select Location, Max(cast(total_deaths as int)) As HighestDeathCountPerContinent, Population, MAX(total_deaths/Population)*100 As '%ofPopulationDeadFromCovid'
from RawCovidData
Where continent is Null AND location in ('North America', 'South America', 'Africa', 'Europe','Asia', 'Oceania','Antarctica','World')
Group by Location, Population
Order By HighestDeathCountPerContinent DESC, '%ofPopulationDeadFromCovid' DESC

-- Looking at total cases per day 
Select Date, Sum(new_cases) as 'Total Cases/Day'
from RawCovidData
Where Continent is not null
Group by date
order by date;

--Looking at Vaccinations per day and total Vaccinations, by country (location)

Select continent, location, date, population, new_vaccinations As 'New Vaccinations Per Day' , SUM(Convert(bigint, new_vaccinations)) OVER (Partition by location order by location, date) AS 
'Total Vaccinations by Country' 
From RawCovidData
Where Continent is not null
Order By 2,3;