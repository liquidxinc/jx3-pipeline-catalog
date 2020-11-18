{{- define "name" -}}
{{- default $.Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "serviceAccountName" -}}
{{- $name := include "name" . -}}
{{- default $name .Values.serviceAccountNameOverride -}}
{{- end -}}

# TEMPORARY: Until jx provides a way to generically override Helm values dependent on the env an
#            app is being deployed to, we must infer the environment name from the namespace being
#            deployed to. This is fragile as the namespace name may not necessarily match the environment
#            name in the long run but it's what we have. The other option is to infer the value from
#            the ingress URL, i.e. .Values.jxRequirements.ingress.namespaceSubdomain.
#            Ideally, jx will provide a way to add arbitrary values to .Values.jxRequirements that
#            depend on the namespace being deployed to.
{{- define "environmentName" -}}
{{- default "default" (trimPrefix "jx-" .Release.Namespace) -}}
{{- end -}}

{{- define "baseEnvUrl" -}}
{{- printf "%s%s" (trimPrefix "." .Values.jxRequirements.ingress.namespaceSubDomain) .Values.jxRequirements.ingress.domain -}}
{{- end -}}

{{- define "url" -}}
{{- $url := printf "%s.%s" (include "name" .) (include "baseEnvUrl" .) -}}
{{- default $url .Values.ingress.urlOverride -}}
{{- end -}}

{{- define "tlsSecretName" -}}
{{- $secretName := printf "tls-%s" (include "name" .) -}}
{{- default $secretName .Values.jxRequirements.ingress.tls.secretName -}}
{{- end -}}

{{- define "volumes" -}}
{{- if hasKey .Values "extraVolumes" }}
{{- $lenExtraVolumes := len .Values.extraVolumes }}
{{- if gt $lenExtraVolumes 0 }}
volumes:
{{ toYaml .Values.extraVolumes }}
{{- end }}
{{- end }}
{{- end }}

{{- define "volumeMounts" -}}
{{- if hasKey .Values.extraVolumeMounts .ContainerName }}
{{- $extraVolumeMounts := index .Values.extraVolumeMounts .ContainerName }}
{{- $lenExtraVolumeMounts := len $extraVolumeMounts }}
{{- if gt $lenExtraVolumeMounts 0 }}
volumeMounts:
{{ toYaml $extraVolumeMounts }}
{{- end }}
{{- else if hasKey .Values.extraVolumeMounts "default" }}
{{- $extraVolumeMounts := index .Values.extraVolumeMounts "default" }}
{{- $lenExtraVolumeMounts := len $extraVolumeMounts }}
{{- if gt $lenExtraVolumeMounts 0 }}
volumeMounts:
{{ toYaml $extraVolumeMounts }}
{{- end }}
{{- end }}
{{- end }}

{{- define "envVars" -}}
{{- if hasKey .Values.env .ContainerName }}
{{- $extraEnvs := index .Values.env .ContainerName }}
{{- $lenExtraEnvs := len $extraEnvs }}
{{- if gt $lenExtraEnvs 0 }}
env:
- name: LQX_ENVIRONMENT
  value: {{ include "environmentName" . }}
{{ toYaml $extraEnvs }}
{{- end }}
{{- else if hasKey .Values.env "default" }}
{{- $extraEnvs := index .Values.env "default" }}
{{- $lenExtraEnvs := len $extraEnvs }}
{{- if gt $lenExtraEnvs 0 }}
env:
- name: LQX_ENVIRONMENT
  value: {{ include "environmentName" . }}
{{ toYaml $extraEnvs }}
{{- end }}
{{- end }}
{{- end }}

{{- define "resources" -}}
{{- if hasKey .Values.resources .ContainerName }}
resources:
{{ toYaml (index .Values.resources .ContainerName) }}
{{- else if hasKey .Values.resources "default" }}
resources:
{{ toYaml .Values.resources.default | trim | indent 2 }}
{{- else }}
resources:
  limits:
    cpu: 1000m
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 128Mi
{{- end }}
{{- end }}
