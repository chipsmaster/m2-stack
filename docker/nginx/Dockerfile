FROM debian:buster
ARG MAGENTO_USER_ID
ARG MAGENTO_USER_GROUP_ID

RUN \
    apt update && \
    apt install -y \
        nginx

ENV MAGENTO_USER magento
ENV MAGENTO_USER_HOME /home/$MAGENTO_USER
ENV MAGENTO_BASE_DIR /var/www/magento

# Create magento user
RUN \
	# Removes any existing user/group with host ids before creating the new one (macOS cases with ids < 1000)
	existing_user_name="$(getent passwd $MAGENTO_USER_ID | cut -d: -f1)" && \
	([ -z "$existing_user_name" ] || userdel "$MAGENTO_USER") && \
	existing_group_name="$(getent group $MAGENTO_USER_GROUP_ID | cut -d: -f1)" && \
	([ -z "$existing_group_name" ] || groupdel "$MAGENTO_USER") && \
	groupadd --gid $MAGENTO_USER_GROUP_ID $MAGENTO_USER && \
	useradd --uid $MAGENTO_USER_ID --gid $MAGENTO_USER_GROUP_ID --create-home $MAGENTO_USER && \
	# Website root
	mkdir -p "$MAGENTO_BASE_DIR" && chown $MAGENTO_USER: "$MAGENTO_BASE_DIR"

# Add/overwrite files
COPY files /

CMD ["nginx", "-g", "daemon off;"]
