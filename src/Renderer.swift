
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
		guard let commandQueue = commandQueue() else {
			print("Failed to create command queue")
			return nill
		}
		self.commandQueue = commandQueue
	}

}

