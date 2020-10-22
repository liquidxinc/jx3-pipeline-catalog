{{- define "name" -}}
{{- default $.Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "serviceAccountName" -}}
{{- $name := include "name" . -}}
{{- default $name .Values.serviceAccountNameOverride -}}
{{- end -}}

{{- define "environmentName" -}}
{{- default "default" .Values.jxRequirements.envName -}}
{{- end -}}

{{- define "url" -}}
{{- $url := printf "%s%s%s" (include "name" .) .Values.jxRequirements.ingress.namespaceSubDomain .Values.jxRequirements.ingress.domain -}}
{{- default $url .Values.ingress.urlOverride -}}
{{- end -}}

{{- define "tlsSecretName" -}}
{{- $secretName := printf "tls-%s" (include "name" .) -}}
{{- default $secretName .Values.jxRequirements.ingress.tls.secretName -}}
{{- end -}}

{{- define "envVars" -}}
{{- if hasKey .Values.env .ContainerName }}
{{- $extraEnvs := index .Values.env .ContainerName }}
{{- $lenExtraEnvs := len $extraEnvs }}
{{- if gt $lenExtraEnvs 0 }}
{{ toYaml $extraEnvs }}
{{- end }}
{{- else if hasKey .Values.env "default" }}
{{- $extraEnvs := index .Values.env "default" }}
{{- $lenExtraEnvs := len $extraEnvs }}
{{- if gt $lenExtraEnvs 0 }}
{{ toYaml $extraEnvs }}
{{- end }}
{{- end }}
{{- end }}

{{- define "resources" -}}
{{- if hasKey .Values.resources .ContainerName }}
{{- toYaml (index .Values.resources .ContainerName) }}
{{- else if hasKey .Values.resources "default" }}
{{- toYaml .Values.resources.default }}
{{- else }}
limits:
  cpu: 1000m
  memory: 512Mi
requests:
  cpu: 100m
  memory: 128Mi
{{- end }}
{{- end }}
