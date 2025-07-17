FROM zulip/docker-zulip:7.4-0

# Optional customization or override
# COPY ./your-configs /etc/zulip/
# ENV SETTING=value

EXPOSE 80 443

CMD ["/sbin/my_init"]
