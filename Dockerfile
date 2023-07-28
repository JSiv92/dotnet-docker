#parent image
FROM mcr.microsoft.com/dotnet/sdk:7.0 as build-env

#working directory for container
WORKDIR /src

#copy all csproj files from folder 
COPY src/*.csproj .
# restore nuget packages in csproj files
RUN dotnet restore

#copy source code into image
COPY src .

#build project
RUN dotnet publish -c Release -o /publish

#specify runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 as runtime

#specify working directoryr for publish stage
WORKDIR /publish

#copy publish directory from the build-env stage into runtime image
COPY --from=build-env /publish .

#expose port 80 for requests
EXPOSE 80

#commands to run after image execution
ENTRYPOINT ["dotnet", "myWebApp.dll"]