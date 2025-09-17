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

async function handlePoseidon2Hash(inputs: string[][]): Promise<ForeignCallResult> {
  try {
    // Extract the input array from the first parameter
    const inputArray = inputs[0] || [];
    
    // Convert string inputs to Fr objects
    const fieldInputs: Fr[] = inputArray.map((input: string) => {
      if (typeof input === 'string') {
        const num = parseInt(input, 10);
        if (!isNaN(num)) {
          return new Fr(BigInt(num));
        } else {
          return new Fr(BigInt(input));
        }
      } else {
        throw new Error(`Invalid input type: ${typeof input}`);
      }
    });
    
    // Filter out zero values to get the actual input length
    const nonZeroInputs = fieldInputs.filter((fr: Fr) => !fr.isZero());
    
    
    // Perform Poseidon2 hash using bb.js
    let result: Fr;
    if (nonZeroInputs.length === 0) {
      // Empty input case
      result = await bb.poseidon2Hash([]);
    } else {
      result = await bb.poseidon2Hash(nonZeroInputs);
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
