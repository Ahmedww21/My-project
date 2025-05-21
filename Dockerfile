# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.sln .
COPY FoodMaster.WebSite/*.csproj ./FoodMaster.WebSite/
RUN dotnet restore

# Copy everything else and build
COPY . . 
WORKDIR /app/FoodMaster.WebSite
RUN dotnet publish -c Release -o out

# Use the ASP.NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/FoodMaster.WebSite/out ./

# Expose port (adjust based on your app)
EXPOSE 80

ENTRYPOINT ["dotnet", "FoodMaster.WebSite.dll"]
