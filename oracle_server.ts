#!/usr/bin/env node

import { BarretenbergSync, Fr } from "@aztec/bb.js";
import express, { Request, Response } from "express";
import bodyParser from "body-parser";
import cors from "cors";
import { poseidon1, poseidon2, poseidon3, poseidon4, poseidon5, poseidon6, poseidon7, poseidon8, poseidon9, poseidon10, poseidon11, poseidon12, poseidon13, poseidon14, poseidon15, poseidon16 } from "poseidon-lite";

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
  } else if (functionName === "getPoseidonHash") {
    return await handlePoseidonHash(inputs);
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
    // For dynamic slices [Field], Noir sends:
    // inputs[0] = array length (metadata)
    // inputs[1] = array contents
    // inputs[2] = message_size

    const inputArray = inputs[1] || [];

    // For u32, Noir sends as strings, not arrays
    const messageSizeHex = inputs[2] as unknown as string;
    if (!messageSizeHex) {
      throw new Error("message_size parameter is missing");
    }
    const messageSize = Number(hexToBigInt(messageSizeHex));

    // Convert input array to Field elements
    const fieldInputs: Fr[] = inputArray.map((input: string) => new Fr(hexToBigInt(input)));

    // Slice to only use the first message_size elements
    const slicedInputs = fieldInputs.slice(0, messageSize);

    // Get Poseidon2 hash using bb.js
    const result = bb.poseidon2Hash(slicedInputs);

    return {
      values: [result.toString()]
    };

  } catch (error) {
    throw error;
  }
}

async function handlePoseidonHash(inputs: string[][]): Promise<ForeignCallResult> {
  try {

    // Extract the input array from the second parameter (inputs[1])
    const inputArray = inputs[1] || [];

    // Extract message_size from the third parameter (inputs[2])
    const messageSizeHex = inputs[2] as unknown as string;
    if (!messageSizeHex) {
      throw new Error("message_size parameter is missing");
    }
    const messageSize = Number(hexToBigInt(messageSizeHex));

    if (messageSize < 1 || messageSize > 16) {
      throw new Error(`message_size must be between 1 and 16, got ${messageSize}`);
    }

    // Convert input array to BigInt array, slicing to message_size
    const bigIntInputs: bigint[] = inputArray
      .slice(0, messageSize)
      .map((input: string) => hexToBigInt(input));

    // Map to appropriate poseidon function
    const poseidonFunctions = [
      poseidon1, poseidon2, poseidon3, poseidon4, poseidon5, poseidon6,
      poseidon7, poseidon8, poseidon9, poseidon10, poseidon11, poseidon12,
      poseidon13, poseidon14, poseidon15, poseidon16
    ];

    const poseidonFunc = poseidonFunctions[messageSize - 1];
    if (!poseidonFunc) {
      throw new Error(`No poseidon function available for message_size ${messageSize}`);
    }
    const result = poseidonFunc(bigIntInputs);

    return {
      values: ["0x" + result.toString(16)]
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
const PORT = process.env['PORT'] || 8095;
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
