# Boids
This is a small project in Godot 3.5 to simulate boids.

> Boids is an artificial life program, developed by Craig Reynolds in 1986, which simulates the flocking behaviour of birds. The name "boid" corresponds to a shortened version of "bird-oid object", which refers to a bird-like object.
>
> &mdash; [Wikipedia](https://en.wikipedia.org/wiki/Boids)

## Rules

Boids respects 3 elementary rules:
- Separation: steer to avoid crowding local flockmates
- Alignment: steer towards the average heading of local flockmates
- Cohesion: steer to move towards the average position (center of mass) of local flockmates
