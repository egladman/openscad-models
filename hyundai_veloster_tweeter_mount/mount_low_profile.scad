// Tweeter Mounting bracket for Hyundai Veloster Front Doors

// Use a lower facet count when previewing for faster development
$fn = $preview ? 32 : 128;

function add_allowance(input, min_allowance = 1, max_allowance = 2) =
  let(
    allowance = max(min(input / 100, max_allowance), min_allowance),
    total = input + allowance,
    result = (allowance <= max_allowance && allowance >= min_allowance) ? ceil(total) : total
  )
  echo(str(
    "Function: add_allowance", "\n",
    "  Input: ", input, "\n",
    "  Min Allowance: ", min_allowance, "\n",
    "  Max Allowance: ", max_allowance, "\n",
    "  Allowance: ", allowance, "\n",
    "  Total: ", total, "\n",
    "  Result: ", result 
  ))
  result;

// Distance between mounting hole centers
bracket_hole_distance = 59;
// Diameter of screw holes
bracket_hole_diameter = 8;
// Clearance for screw head
bracket_hole_clearance = 2;
bracket_height = 2.75;
bracket_height_right_offset = 3.2;
bracket_left_width = 13;
bracket_right_width = 14.5;
bracket_left_length = 18;
bracket_right_length = 18;

// 45.9 is the reference diameter of the tweeter speaker with the housing  
fixture_diameter = add_allowance(40);
fixture_cavity_depth = 10;
fixture_height = fixture_cavity_depth + bracket_height;
fixture_thickness = 4;

module rounded_cube(size, center = false, radius = 1) {
  offset = radius * 2;
  cube_params = [ for (i = [0 : len(size) - 1]) size[i] - offset ];
  minkowski() {
    cube(cube_params, center=center);
    sphere(r=radius);
  }
}

module bracket(length, width, height, skew = 0) {
  mtx = [
    [ 1, 0, 0, 0 ],
    [ skew, 1, 0, 0 ],
    [ 0, 0, 1, 0 ],
    [ 0, 0, 0, 1 ]
  ];

  difference() {
    multmatrix(mtx) {
      rounded_cube([length, width, height], center = true, radius = .75);
    }
  }
}

module body() {
  difference(){
    cylinder(d = fixture_diameter + fixture_thickness, h = fixture_height);
   
    fixture();
      
    translate([0,-4.5,0])
    rotate([0,0,3])
    bracket_clearance_spaced();   
  }

  difference() {
    translate([0,-4.5,0])
    rotate([0,0,3])
    brackets_spaced();
    
    fixture();
  }
}

module fixture() {
  translate([0, 0, bracket_height])
  cylinder(d = fixture_diameter, h = fixture_height);  
}



module brackets_spaced() {
    translate([(bracket_hole_distance/2),0, 0])
    bracket_right(-1);
    
    translate([-(bracket_hole_distance/2), 0, 0])
    bracket_left(2);
}

module bracket_left(offset = 0) {
  difference() {
    translate([offset,0,(bracket_height/2)]) 
    bracket(bracket_left_length+offset, bracket_left_width, bracket_height, skew = .2);
    
    cylinder(d = bracket_hole_diameter, h = bracket_height); 
  } 
}

module bracket_right(offset = 0) {
  translate([0,0,bracket_height_right_offset])
  rotate([0,-2.5,0])
  difference() {
    translate([offset,0,(bracket_height/2)]) 
    bracket(bracket_right_length+offset, bracket_right_width, bracket_height, skew = -.1);
    
    cylinder(d = bracket_hole_diameter, h = bracket_height); 
  } 
}

module bracket_clearance_right() {
  translate([-bracket_hole_clearance/2,0,bracket_height_right_offset])
  rotate([0,8,0])
  cylinder(d = bracket_hole_diameter+bracket_hole_clearance, h = fixture_height);   
}

module bracket_clearance_left() {
  translate([bracket_hole_clearance/2,0,0])
  rotate([0,-5.2,0])
  cylinder(d = bracket_hole_diameter+bracket_hole_clearance, h = fixture_height);   
}

module bracket_clearance_spaced() {
  translate([(bracket_hole_distance/2),0, 0])
  bracket_clearance_right();   

  translate([-(bracket_hole_distance/2),0, 0])
  bracket_clearance_left();  
}

module main() {
  difference() {
    body();

    // Screw hole for flush tweeter housing  
    translate([12, 0, 0])
    cylinder(d = 3, h = fixture_height);
     
    // Screw hole for flush tweeter housing
    translate([-12, 0, 0])
    cylinder(d = 3, h = fixture_height);
      
    // Hole for wires
    translate([0, 12, 0])
    scale([2.25,1.25,1])
    cylinder(d = 9, h = fixture_height);
  }
}  

 main();