FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["UberHeat.Web/UberHeat.Web.csproj", "UberHeat.Web/"]
RUN dotnet restore "UberHeat.Web/UberHeat.Web.csproj"
COPY . .
WORKDIR "/src/UberHeat.Web"
RUN dotnet build "UberHeat.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "UberHeat.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "UberHeat.Web.dll"]
