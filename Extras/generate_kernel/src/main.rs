use std::f32::{self, consts};

fn sigma(x : i32) -> i32 {
    if x == 0 { 0 } else { x + sigma(x - 1) }
}

fn main() {
    let rings = 5;
    let points_per_ring = 7;
    let total_points = sigma(rings - 1) * points_per_ring;

    println!("static const int sampleCount = {};", total_points + 1);
    println!("static const float2 kernel[sampleCount] = {{");
    println!("    float2(0,0),");

    for ring in 1..rings {
        let radius = (ring as f32) / (rings as f32);
        let points = ring * points_per_ring;
        for pt in 0..points {
            let phi = 2.0 * consts::PI * (pt as f32) / (points as f32);
            let x = phi.cos() * radius;
            let y = phi.sin() * radius;
            println!("    float2({},{}),", x, y);
        }
    }

    println!("}};");
}
