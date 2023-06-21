import { check, sleep } from 'k6';
import http from 'k6/http';

import { htmlReport } from 'https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js';
import { textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';

// https://docs.konghq.com/gateway/latest/production/sizing-guidelines/
export const options = {
  thresholds: {
    http_req_duration: ['p(99) < 3000'],
  },
  stages: [
    { duration: '30s', target: 100 },
    { duration: '10m', target: 1000 },
    { duration: '30s', target: 0 },
  ],
};

export function handleSummary(data) {
  return {
    'result.html': htmlReport(data),
    stdout: textSummary(data, { indent: ' ', enableColors: true }),
  };
}

export default function () {
  const url = 'http://localhost:8080/gateway/health/status/ready?auth_token=xyz';
  const res = http.get(url);
  check(res, { 'status was 200': (r) => r.status == 200 });
  sleep(1);
}
