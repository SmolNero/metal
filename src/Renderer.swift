
import Metal
import MetalKit
import simd

class Renderer: NSObject, MTKViewDelegate {
	
	// Metal objects
	let device: MTLDevice
	let commandQueue : MTLCommandQueue
	let pipelineState: MTLRenderPipelineState
	let vertexBuffer : MTLBuffer

	// Initialize with the MetalKit view
	init?(mtkView: MTKView) {
		// Get the default Metal device
		guard let device = MTLCreateSystemDefaultDevice() else {
			print("Metal is not supported on this device")
			return nill
		}

		self.device = device

		//Create the command queue
		// Guard is used for invalid parameters
		guard let commandQueue = commandQueue() else {
			print("Failed to create command queue")
			return nill
		}
		self.commandQueue = commandQueue

		// Connfig MetalKit view - slightly  lighter shade of black
		mtkView.device = device
		mtkView.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)

		// Create vertices for a square (two triangles)
		let vertices = [
			// First triangle (bottom left, top left , bottom right)
			Vertex(position: vector_ float3(-0.5, -0.5, 0.0), color: vector_float4(0.0,0.0,0.0,1.0)),
			Vertex(position: vector_ float3(-0.5, 0.5, 0.0), color: vector_float4(0.0,0.0,0.0,1.0)),
			Vertex(position: vector_ float3(0.5, -0.5, 0.0), color: vector_float4(0.0,0.0,0.0,1.0)),
		
			// Second triangle (bottom left, top left, bottom right)
			Vertex(position: vector_ float3(-0.5, 0.5, 0.0), color: vector_float4(0.0,0.0,0.0,1.0)),
			Vertex(position: vector_ float3(-0.5, -0.5, 0.0), color: vector_float4(0.0,0.0,0.0,1.0)),
			Vertex(position: vector_ float3(0.5, -0.5, 0.0), color: vector_float4(0.0,0.0,0.0,1.0)),
		]

		// Creating Vertex buffer
		let vertexBufferSize = vertices.count * MemoryLayout<Vertex>.stride
		guard let vertexBuffer = device.makeBuffer(bytes: vertices, length: vertexBufferSize, options: [])else
			print("Failed to create vertex buffer")
			return nil
	}
	self.vertexBuffer = vertexBuffer

	// Set up render pipeline
	let library: MTLLibrary
	do {
		// Load the compiled Metal library from the bundle
		let libraryURL = URL(fileURLWithPath: "build/default.metallib")
		library = try device.makeLibrary(URL: libraryURL)
	} catch {
		print("Failed to load Metal library: \(error)")
		return nil
	} 

	guard let vertexFunction = library.makeFunction(name:"vertex_main"),
		  let fragmentFunction = library.makeFunction(name: "fragment_main") else {
		print("Failed to find Metal functions in the library")
		return nil
	}
	
	let pipelineDescriptor = MTLRenderPipeLineDesriptor()
	pipelineDescriptor.vertexFunction = vertexFunction
	pipelineDescriptor.fragmentFunction = fragmentFunction
	pipelineDescriptor.colorAttachment[0].pixelFormat = mtkView.colorPixelFormat

	}

