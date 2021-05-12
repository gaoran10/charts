{{/* vim: set filetype=mustache: */}}

{{/*
pulsar home
*/}}
{{- define "pulsar.home" -}}
{{- if or (eq .Values.images.broker.repository "streamnative/platform") (eq .Values.images.broker.repository "streamnative/platform-all") }}
{{- print "/sn-platform" -}}
{{- else }}
{{- print "/pulsar" -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "pulsar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand to the namespace pulsar installs into.
*/}}
{{- define "pulsar.namespace" -}}
{{- default .Release.Namespace .Values.namespace -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pulsar.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pulsar.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the common labels.
*/}}
{{- define "pulsar.standardLabels" -}}
app: {{ template "pulsar.name" . }}
chart: {{ template "pulsar.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
cluster: {{ template "pulsar.fullname" . }}
{{- end }}

{{/*
Create the template labels.
*/}}
{{- define "pulsar.template.labels" -}}
app: {{ template "pulsar.name" . }}
release: {{ .Release.Name }}
cluster: {{ template "pulsar.fullname" . }}
{{- end }}

{{/*
Create the match labels.
*/}}
{{- define "pulsar.matchLabels" -}}
app: {{ template "pulsar.name" . }}
release: {{ .Release.Name }}
{{- end }}

{{/*
Pulsar Cluster Name.
*/}}
{{- define "pulsar.cluster" -}}
{{- if .Values.pulsar_metadata.clusterName }}
{{- .Values.pulsar_metadata.clusterName }}
{{- else }}
{{- template "pulsar.fullname" . }}
{{- end }}
{{- end }}

{{/*
Pulsar URIs
*/}}
{{- define "pulsar.cluster_uris" -}}
{{- if .Values.pulsar_metadata.external_hostname }}
--web-service-url http://{{ .Values.pulsar_metadata.external_hostname }}:8080/ \
--web-service-url-tls https://{{ .Values.pulsar_metadata.external_hostname }}:8443/ \
--broker-service-url pulsar://{{ .Values.pulsar_metadata.external_hostname }}:6650/ \
--broker-service-url-tls pulsar+ssl://{{ .Values.pulsar_metadata.external_hostname }}:6651/
{{- else }}
--web-service-url http://{{ template "pulsar.fullname" . }}-{{ .Values.broker.component }}.{{ template "pulsar.namespace" . }}.svc.cluster.local:8080/ \
--web-service-url-tls https://{{ template "pulsar.fullname" . }}-{{ .Values.broker.component }}.{{ template "pulsar.namespace" . }}.svc.cluster.local:8443/ \
--broker-service-url pulsar://{{ template "pulsar.fullname" . }}-{{ .Values.broker.component }}.{{ template "pulsar.namespace" . }}.svc.cluster.local:6650/ \
--broker-service-url-tls pulsar+ssl://{{ template "pulsar.fullname" . }}-{{ .Values.broker.component }}.{{ template "pulsar.namespace" . }}.svc.cluster.local:6651/
{{- end }}
{{- end }}