use std::env;
use std::f32::{self, consts};

fn square_to_disk(x01 : f32, y01 : f32) -> (f32, f32) {
    let x = x01 * 2.0 - 1.0;
    let y = y01 * 2.0 - 1.0;

    if x == 0.0 && y == 0.0 {
        (0.0, 0.0)
    } else if x * x >= y * y {
        (consts::PI * 0.25 * y / x, x)
    } else {
        (consts::PI * 0.25 * (x / y + 2.0), y)
    }
}

fn main() {
    let arg = env::args().nth(1).unwrap_or(String::new()).parse::<u32>();

    if arg.is_err() {
        println!("Usage: generate_kernel points_per_row");
        return;
    }

    let points_per_row = arg.unwrap();

    println!("static const int kSampleCount = {};", points_per_row * points_per_row);
    println!("static const float2 kDiskKernel[kSampleCount] = {{");

    for ix in 0..points_per_row {
        for iy in 0..points_per_row {
            let x1 = (ix as f32) / ((points_per_row - 1) as f32);
            let y1 = (iy as f32) / ((points_per_row - 1) as f32);

            let (phi, radius) = square_to_disk(x1, y1);

            let x2 = phi.cos() * radius;
            let y2 = phi.sin() * radius;

            println!("    float2({},{}),", x2, y2);
        }
    }

    println!("}};");
}
