# Specific image tag that contains the script start-singleuser.sh, so it works within JupyterHub
FROM jupyter/scipy-notebook:8ccdfc1da8d5
LABEL maintainer="raul.lara@upm.es"

# Some args for metadata labels
ARG VCS_REF
ARG BUILD_VERSION=devel
ARG BUILD_DATE

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="knodis/knodis-notebook" \
      org.label-schema.description="Docker image for customized Jupyter notebooks" \
      org.label-schema.url="https://github.com/KNODIS-Research-Group/knodis-notebook" \
      org.label-schema.vcs-url="https://github.com/KNODIS-Research-Group/knodis-notebook" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$BUILD_VERSION \
      org.label-scheme.build-date=$BUILD_DATE

# Additional IPyWidgets
RUN pip install --upgrade \
    jupyterthemes \
    jupyter_contrib_nbextensions

RUN jupyter nbextension enable contrib_nbextensions_help_item/main && \
    jupyter nbextension enable autosavetime/main && \
    jupyter nbextension enable codefolding/main && \
    jupyter nbextension enable code_font_size/code_font_size && \
    jupyter nbextension enable collapsible_headings/main && \
    jupyter nbextension enable comment-uncomment/main && \
    jupyter nbextension enable equation-numbering/main && \
    jupyter nbextension enable execute_time/main && \
    jupyter nbextension enable hide_input/main && \
    jupyter nbextension enable toc2/main && \
    jupyter nbextension enable toggle_all_line_numbers/main

# Additional Python libraries
RUN pip install \
    beautifulsoup4==4.4.* \
    imbalanced-learn==0.7.* \
    manifoldy \
    nltk==3.5.*


# Use custom startup script
USER root
COPY docker-entrypoint.sh /srv/docker-entrypoint.sh
RUN chmod +x /srv/docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/srv/docker-entrypoint.sh"]
CMD ["start-singleuser.sh"]
USER jovyan