#!/bin/bash
docker run -d --rm --name ngrok -p 4040:4040 --link flask wernight/ngrok ngrok http flask:5000
