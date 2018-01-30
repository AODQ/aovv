module svo.util;
import vector;
import svo.mortonlookup;

/// Convert morton to RGB, for debug colouring
// float3 Morton_To_RGB ( uint morton, size_t grid_size ) {
//   uint x, y, z;
//   return To_Vec!float3(Morton3D_64_Decode(morton))/float3(grid_size);
// }

uint Log_8 ( size_t n ) {
  if ( n == 0 ) return 0;
  uint hi = 0;
  while ( n >>= 1 ) ++ hi;
  return hi/3;
}

uint Log_2 ( size_t n  ) {
  uint ret = -1;
  while ( n != 0 ) {
    n >>= 1;
    ++ ret;
  }
  return ret;
}

uint Is_Power_2 ( uint x ) { return ((x != 0) && !(x & (x - 1))); }

// --- morton funcs ---

ulong Morton3D_64_Encode ( uint3 coord ) {
  ulong ans = 0;
  uint check_bit = cast(uint)(floor((ulong.sizeof * 8.0f/3.0f)));
  foreach ( i; 0 .. check_bit ) {
    ulong m_shifted = cast(ulong)(1) << i;
    uint shift = 2*i; // have to shift back i and forth 3i
    ans |= ((coord.x&m_shifted) << (shift+0)) |
           ((coord.y&m_shifted) << (shift+1)) |
           ((coord.z&m_shifted) << (shift+2));
  }
  return ans;
}

uint3 Morton3D_64_Decode ( ulong morton ) {
  uint3 coord = uint3(0);
  uint check_bit = cast(uint)(floor((ulong.sizeof * 8.0f/3.0f)));
  foreach ( i; 0 .. check_bit ) {
    ulong sel = 1;
    uint shift_sel = 3*i,
         shift_bak = 2*i;
    coord.x |= (morton & (sel << (shift_sel+0))) >> (shift_bak+0);
    coord.y |= (morton & (sel << (shift_sel+1))) >> (shift_bak+1);
    coord.z |= (morton & (sel << (shift_sel+2))) >> (shift_bak+2);
  }
  return coord;
}

// ulong Morton3D_64_Encode ( uint x, uint y, uint z ) {
//   ulong answer = 0;
//   static immutable ulong Mask = 0x000000FF;
//   for ( uint i = uint.sizeof; i > 0; -- i ) {
//     uint shift = (i - 1)*8;
//     answer = answer << 24 |
//              (Morton3D_encode_z[(z >> shift) & Mask] |
//               Morton3D_encode_y[(y >> shift) & Mask] |
//               Morton3D_encode_z[(x >> shift) & Mask]);
//   }
//   return answer;
// }

// uint3 Morton3D_64_Decode ( ulong morton ) {
//   return uint3(
//     Morton3D_64_Decode_Coord(morton, Morton3D_decode_x),
//     Morton3D_64_Decode_Coord(morton, Morton3D_decode_y),
//     Morton3D_64_Decode_Coord(morton, Morton3D_decode_z));
// }


// private auto Morton3D_64_Decode_Coord (ulong morton, inout ubyte[512] table ) {
//   ulong a = 0;
//   immutable static ulong Mask = 0x000001ff;
//   foreach ( i; 0 .. 7 ) { // floor
//     a |= (table[(morton >> (i*9)) & Mask] << (3 * i));
//   }
//   return cast(uint)(a);
// }
