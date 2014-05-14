docker-naxsi-proxy-waf
======================
About
-----
CentOS Naxsi Proxy Web Application Firewall

NAXSI means Nginx Anti Xss & Sql Injection. It's a Web Application Firewall who allowed only whitelisted requests.

In short, Naxsi behaves like a DROP-by-default firewall, the only job needed is to add required ACCEPT rules for the target website to work properly.

This Docker container work as a Nginx proxy, use it in front of your WebApps in order to allow only autorised requests.

Config
------
Nginx is compiled from source with Naxsi module.

Usage
-----
Naxsi first lauch in learning mode, who's allowed all the requests and add them to the rules.

You have to specify your redirect IP in the Dockerfile ``ENV PROXY_REDIRECT_IP``
Your redirect IP must be your http Frontend

Example
~~~~~~~

You want to run your WAF proxy behind your 10.0.0.1 Frontend IP on port 8081::
sudo docker run --env PROXY_REDIRECT_IP=10.0.0.1 -p 8081:80 -d epheo/naxsi-proxy-waf