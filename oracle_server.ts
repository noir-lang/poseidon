#!/usr/bin/env node

import { BarretenbergSync, Fr } from "@aztec/bb.js";
import express, { Request, Response } from "express";
import bodyParser from "body-parser";
import cors from "cors";

// Type definitions
interface JsonRpcRequest {
  jsonrpc: "2.0";
  method: string;
  params?: any[];
  id: number | string;
}

interface JsonRpcResponse {
  jsonrpc: "2.0";
  id: number | string;
  result?: any;
  error?: {
    code: number;
    message: string;
    data?: any;
  };
}

interface ForeignCallInfo {
  function: string;
  inputs: string[][];
}

interface ForeignCallResult {
  values: string[];
}

interface HealthResponse {
  status: string;
  service: string;
  timestamp: string;
}

// Global variables
let bb: BarretenbergSync;

// Initialize Barretenberg
async function initializeBarretenberg(): Promise<void> {
  try {
    bb = await BarretenbergSync.initSingleton()
  } catch (error) {
    console.error("Failed to initialize Barretenberg:", error);
    process.exit(1);
  }
}

// Initialize on startup
initializeBarretenberg();

// Express app setup
const app = express();
app.use(cors());
app.use(bodyParser.json());

// JSON RPC server
app.post("/", async (req: Request<{}, JsonRpcResponse, JsonRpcRequest>, res: Response<JsonRpcResponse>) => {
  try {
    const { method, params, id } = req.body;
    
    if (method === "resolve_foreign_call") {
      const result = await handleForeignCall(params || []);
      res.json({
        jsonrpc: "2.0",
        id,
        result
      });
    } else {
      res.json({
        jsonrpc: "2.0",
        id,
        error: {
          code: -32601,
          message: "Method not found"
        }
      });
    }
  } catch (error) {
    res.json({
      jsonrpc: "2.0",
      id: req.body.id,
      error: {
        code: -32603,
        message: "Internal error",
        data: error instanceof Error ? error.message : "Unknown error"
      }
    });
  }
});

async function handleForeignCall(params: any[]): Promise<ForeignCallResult> {
  const [callInfo] = params as [ForeignCallInfo];
  const { function: functionName, inputs } = callInfo;
  
  
  if (functionName === "getPoseidon2Hash") {
    return await handlePoseidon2Hash(inputs);
  } else {
    throw new Error(`Unknown oracle function: ${functionName}`);
  }
}

function hexToBigInt(hex: string): bigint {
    // normalize
    let clean = hex.trim().toLowerCase();
    if (clean.startsWith("0x")) {
      clean = clean.slice(2);
    }
    if (!/^[0-9a-f]+$/.test(clean)) {
      throw new Error("Invalid hex string: " + hex);
    }
    return BigInt("0x" + clean);
  }

async function handlePoseidon2Hash(inputs: string[][]): Promise<ForeignCallResult> {
  try {
    // Extract the input array from the first parameter
    const inputArray = inputs[0] || [];
    
    const fieldInputs: Fr[] = inputArray.map((input: string) => new Fr(hexToBigInt(input)))
    
    // Perform Poseidon2 hash using bb.js
    let result: Fr;
    if (fieldInputs.length === 0) {
      // Empty input case
      result = await bb.poseidon2Hash([]);
    } else {
      result = await bb.poseidon2Hash(fieldInputs);
    }
    
    
    return {
      values: [result.toString()]
    };
    
  } catch (error) {
    throw error;
  }
}

// Health check endpoint
app.get("/health", (_req: Request, res: Response<HealthResponse>) => {
  res.json({ 
    status: "healthy", 
    service: "Poseidon2 Oracle Server",
    timestamp: new Date().toISOString()
  });
});

// Start server
const PORT = process.env['PORT'] || 5555;
app.listen(PORT, () => {
  // Server started silently
});

// Graceful shutdown
process.on('SIGINT', () => {
  process.exit(0);
});

process.on('SIGTERM', () => {
  process.exit(0);
});
