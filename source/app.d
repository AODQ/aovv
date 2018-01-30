import std.stdio;
import buffer, vector, svo, sdf;
import std.math : fabs;

immutable Img_dim = 512;
immutable Mdl_flt = 0.11f;
immutable Mdl_itr = cast(uint)(2.0f/Mdl_flt);

struct Ray { float3 ori, dir; }

Ray Look_At ( float2 coord, float3 eye, float3 center,
              float3 up = float3(0.0f, 1.0f, 0.0f)) {
  float fov_r = (180.0f - 95.0f)*PI/180.0f;

  float2 puv = float2(-1.0f) + 2.0f*(coord);

  float3 cam_front = Normalize(center - eye),
         cam_right = Normalize(cross(cam_front, up)),
         cam_up    = Normalize(cross(cam_right, cam_front));
  return Ray(eye, Normalize(puv.x*cam_right + puv.y*cam_up + fov_r*cam_front));
}

void main() {
  import svo.util : Log_8;
  import std.datetime.stopwatch;

  auto sw = new StopWatch(AutoStart.yes);
  auto fil = new PNGFile(Img_dim, Img_dim);
  auto octree = new Octree(float3(0.0f), 1.0f, Log_8(Mdl_itr*Mdl_itr*Mdl_itr));

  (Mdl_itr*Mdl_itr*Mdl_itr*8).writeln(" dim");
  for ( float i = -1.0f; i <= 1.0f; i += Mdl_flt )
  for ( float j = -1.0f; j <= 1.0f; j += Mdl_flt )
  for ( float k = -1.0f; k <= 1.0f; k += Mdl_flt ) {
    import svo.util;

    bool hit = false;
    float3 nor = float3(0.0f);

    foreach ( c; 0 .. 8 ) {
      float3 ori = float3(i, j, k);
      ori += Normalize(Normalize_Axis(c))*(Mdl_flt);

      bool p = Map(ori) <= 0.001f;
      if ( p ) {
        if ( hit ) nor = (nor+Normal(ori))/2.0f;
        else {
          hit = true;
          nor = Normal(ori);
        }
      }
    }

    if ( hit )
      octree.Insert(float3(i, j, k), new VoxelData(float3(1.0f), nor));
  }
  writeln("Size: ", octree.RSize);


  writeln("img");
  foreach ( i; 0 .. Img_dim )
  foreach ( j; 0 .. Img_dim ) {
    float colour = 0.0f;
    float2 coord = (-float2(Img_dim) + 2.0f*float2(i, j))/float2(Img_dim);
    auto cam = Look_At(coord,
                      float3(-1.0f),
                      float3(0.0f));
    auto result = octree.Raymarch(cam.ori, cam.dir);
    if ( result.pt is null ) continue;
    cam.ori = result.intersect;
    float3 N = result.pt.normal;
    float3 Lo = float3(-1.0f);
    colour = dot(N, Normalize(Lo-cam.ori)).clamp(0.0f, 1.0f);
    if ( colour != 0.0f )
      fil.Apply(int2(i, j), float4(colour, colour, colour, 1.0f));
  }
  fil.Save("test.png");

  sw.stop();
  writeln(sw.peek);
}
