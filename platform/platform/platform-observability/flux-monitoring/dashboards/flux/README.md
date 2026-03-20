# Flux Dashboards (GitOps)

This folder packages official Flux dashboards into ConfigMaps labeled with `grafana_dashboard: "1"`.

## Source dashboards
- cluster.json
- control-plane.json
- logs.json

Reference source: `fluxcd/flux2-monitoring-example`.

## Refresh dashboards
Run:

```bash
./scripts/sync-flux-dashboards.sh
```

Then commit updated JSON files.

## Notes
- This setup intentionally avoids manual Grafana UI import.
- Dashboards are delivered declaratively through Kustomize ConfigMaps.
