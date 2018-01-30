module svo.octreebuilder;
import std.stdio : File;
import std.stdio : writeln, writefln, readln;

// class OctreeBuilder {
//   size_t grid_length;
//   size_t node_amt, data_amt;

//   File* node_file, data_file;


//   private void Apply_Base_File_Line(T)(T[] line) {
//     import std.conv : to;
//     switch ( line[0] ) {
//       default: break;
//       case "#octreeheader": break;
//       case "gridlength": grid_length = line[1].to!size_t; break;
//       case "n_nodes":    node_amt    = line[1].to!size_t; break;
//       case "n_data":     data_amt    = line[1].to!size_t;break;
//       case "end": break;
//     }
//   }

//   auto To_String ( ) {
//     import std.string : format;
//     return "grid_length: %s\nnode_amt: %s\ndata_amt: %s"
//             .format(grid_length, node_amt, data_amt);
//   }
//   alias toString = To_String;

//   this ( string filename ) {
//     import std.string, std.algorithm, std.stdio, std.array;
//     File(filename).byLine
//                   .map!(split)
//                   .each!(n => Apply_Base_File_Line(n));
//     node_file = new File(filename~"nodes", "rb");
//     data_file = new File(filename~"data",  "rb");
//   }

//   void Apply_Octree_Node ( ) {
//     struct voxdata {
//       uint morton_Code;
//       float[3] colour;
//       float[3] normal;
//     }
//     voxdata[] vd;
//     vd.length = node_amt;
//     data_file.rawRead(vd);
//     vd.writeln;
//     // foreach ( i; 0 .. node_amt ) {
//     //   auto d = voxdata();
//     //   size_t[] wtfd = [0];
//     //   node_file.rawRead(wtfd);
//     //   wtfd.writeln;
//     //   readln;
//     // }
//     // vd.length = node_amt;
//     // node_file.rawRead(vd);
//     // vd.writeln;
//   }
// }
