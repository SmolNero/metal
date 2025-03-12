#ifndef bridging_header_h
#define bridging_header_h

#include <simd/simd.h>

// C struct matching the Metal Vertex struct
typedef struct {
	vector_float3 position;
	vector_float4 color;
} Vertex;

#endif /*bridging_header_h*/