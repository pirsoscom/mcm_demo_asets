export BACKEND_URL=https://api.nasa.gov/planetary/apod\?api_key\=DEMO_KEY


docker build -t niklaushirt/grpcdemo:1.0.0 .
docker push niklaushirt/grpcdemo:1.0.0


docker run niklaushirt/grpcdemo:1.0.0 --rm -d -p 3000:3000

