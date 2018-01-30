import std.stdio;
import vector;

auto length ( T ) ( T v ) { return v.magnitude; 

private float sdSphere ( float3 origin, float radius ) {
  return (origin).magnitude - radius;
}

private float sdTorus ( float3 p, float2 t ) {
  float2 q = float2(length(p.xz) - t.x, p.y);
  return length(q)-t.y;
}

float Map ( float3 origin ) {
  return sdTorus(origin - float3(0.0f), float2(0.3f, 0.5f));
}

float3 Normal ( float3 p ) {
  float2 e = float2(1.0f, -1.0f)*0.5883f*0.0005f;
  return Normalize(
    e.xyy*Map(p + e.xyy) +
    e.yyx*Map(p + e.yyx) +
    e.yxy*Map(p + e.yxy) +
    e.xxx*Map(p + e.xxx));
}
