# Structured-Light 3D Reconstruction

A MATLAB pipeline for 3D surface reconstruction using a camera-projector structured-light system. Implements camera/projector calibration via Zhang's homography-based method, multi-frequency phase-shifting for correspondence estimation, and stereo triangulation — all built from first principles (homogeneous coordinates, homography estimation, SVD-based calibration) rather than relying on MATLAB's Camera Calibration Toolbox.

Developed as coursework for a 3D optical reconstruction course, Facultad de Ciencias Físico Matemáticas, BUAP.

## Pipeline overview

1. **Checkerboard detection** — corner extraction from calibration images (red/blue channel split: blue channel calibrates the camera under ambient light, red channel carries projector-related information).
2. **Camera & projector calibration** — homography estimation per calibration pose, intrinsic parameter recovery via Zhang's method (SVD + Cholesky), extrinsic parameter recovery per pose.
3. **Phase demodulation** — N-step phase-shifting least-squares algorithm extracts wrapped phase, amplitude, and background intensity from fringe pattern images.
4. **Multi-frequency phase unwrapping** — heterodyne unwrapping combines multiple grating frequencies to recover absolute (unwrapped) phase, giving normalized projector coordinates for every camera pixel.
5. **Triangulation** — camera and projector rays are intersected (least-squares closest point) to recover 3D coordinates, colored using the fringe-free averaged image.

## Repository structure

```
functions/        Core reusable MATLAB functions (see reference table below)
calibration/       Scripts for checkerboard corner detection and camera/projector calibration
reconstruction/    Main scripts that run the full pipeline end-to-end for a given dataset
tests/             Standalone tests for individual functions using synthetic data
docs/              Course notes / reference PDFs (optional)
```

Each `reconstruction/*.m` script is self-contained for one dataset (paths, resolution, number of gratings/steps, checkerboard size are set at the top).

## Function reference

| Function | Purpose |
|---|---|
| `my_hom` / `my_ihom` | Homogeneous coordinate operators (cartesian ↔ homogeneous). |
| `my_ptsnorm` | Normalizes pixel coordinates to an approximately [-1, 1] range. |
| `my_Gme` | Estimates a single homography between two point sets (least squares). |
| `my_Kme` | Recovers the intrinsic matrix K from multiple homographies (Zhang's method: SVD + Cholesky). |
| `my_Lme` | Recovers extrinsic parameters (R, t) from a homography given K. |
| `my_devcalib` | Orchestrates `my_Gme` + `my_Kme` + `my_Lme` to fully calibrate a device (camera or projector) from multiple checkerboard poses. |
| `my_pshift` | N-step phase-shifting algorithm (least squares); recovers wrapped phase, amplitude, and background. |
| `my_punwrap` | Multi-frequency (heterodyne) phase unwrapping across gratings of increasing frequency. |
| `my_pdem` | Full phase demodulation pipeline: reads fringe images, runs `my_pshift` + `my_punwrap` for both axes, and computes the fringe-free image. |
| `my_relpose` | Averages the relative camera-projector pose across multiple calibration captures (rotation averaging via SVD). |
| `my_triang` | Triangulates 3D points from two sets of rays (camera + projector), least-squares closest-point method. |

## Requirements

- MATLAB (tested on R2023b+)
- Image Processing Toolbox (`detectCheckerboardPoints`, `rgb2gray`)
- Computer Vision Toolbox (`pcshow`), optional — used for point cloud visualization

## Usage

```matlab
addpath("functions")
addpath("calibration")
addpath("reconstruction")

% 1. Detect checkerboard corners (once per calibration dataset)
run("calibration/detect_checkerboard.m")

% 2. Run the full reconstruction for a given dataset
run("reconstruction/reconstruct_pyramid.m")
```

## Notes & limitations

- Lens distortion coefficients (radial distortion) are estimated during calibration but not currently applied to the ray construction step — reconstructions near the image edges may show a small systematic bias.
- The current pipeline uses a single calibration pose (rather than averaging across all poses) for the camera-projector relative transform; `my_relpose` is available for pose averaging when calibration datasets are small or noisy.
- Fringe images and raw calibration photos are not included in this repository due to size — see `docs/` or the dataset link for access.
