// ─────────────────────────────────────────────────────────────
// API CLIENT UTILITY - POC-45 Attention Economy Revenue Simulator
// Phase 2: Docker-Ready API Integration
// Author: Jaliha Sherin K J | Batch 2 Interns
// ─────────────────────────────────────────────────────────────

/**
 * API Base URL - Dynamically uses environment variable
 * - In development (local): http://localhost:8000
 * - In Docker: http://backend:8000 (service name)
 * - In production: Your cloud API endpoint
 */
export const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000";

/**
 * Generic fetch wrapper with error handling
 * Usage: const data = await apiFetch('/platforms');
 */
export async function apiFetch<T>(
  endpoint: string,
  options: RequestInit = {}
): Promise<T> {
  const url = `${API_BASE_URL}${endpoint}`;

  try {
    const response = await fetch(url, {
      headers: {
        "Content-Type": "application/json",
        ...options.headers,
      },
      ...options,
    });

    if (!response.ok) {
      throw new Error(`API Error: ${response.status} ${response.statusText}`);
    }

    return await response.json();
  } catch (error) {
    console.error(`API call failed to ${url}:`, error);
    throw error;
  }
}

/**
 * GET request
 * Usage: const platforms = await apiGet<Platform[]>('/platforms');
 */
export async function apiGet<T>(endpoint: string): Promise<T> {
  return apiFetch<T>(endpoint, { method: "GET" });
}

/**
 * POST request
 * Usage: const result = await apiPost('/simulator', { dau: 100 });
 */
export async function apiPost<T>(endpoint: string, data: any): Promise<T> {
  return apiFetch<T>(endpoint, {
    method: "POST",
    body: JSON.stringify(data),
  });
}

/**
 * PUT request
 * Usage: await apiPut('/platform/youtube', { metrics: {...} });
 */
export async function apiPut<T>(endpoint: string, data: any): Promise<T> {
  return apiFetch<T>(endpoint, {
    method: "PUT",
    body: JSON.stringify(data),
  });
}

/**
 * DELETE request
 * Usage: await apiDelete('/platform/youtube');
 */
export async function apiDelete<T>(endpoint: string): Promise<T> {
  return apiFetch<T>(endpoint, { method: "DELETE" });
}

// ─────────────────────────────────────────────────────────────
// EXAMPLE USAGE IN YOUR COMPONENTS:
// ─────────────────────────────────────────────────────────────
/*

import { apiGet, apiPost } from '@/lib/api-client';

export default function Dashboard() {
  const [platforms, setPlatforms] = useState([]);

  useEffect(() => {
    // Fetch platforms from backend API
    apiGet<Platform[]>('/api/platforms')
      .then(setPlatforms)
      .catch(console.error);
  }, []);

  const handleSimulate = async (params: SimulatorParams) => {
    const result = await apiPost('/api/simulator', params);
    console.log('Simulation result:', result);
  };

  return (
    // Your component JSX
  );
}

*/
