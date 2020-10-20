attribute vec3 position;
attribute vec3 uv;
attribute float movable;

uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;
uniform float time;
uniform vec2 resolution;
uniform float pixelRatio;
uniform sampler2D noiseTex;

varying vec3 vColor;

void main() {
  // Coordinate transformation
  float texColorR = texture2D(noiseTex, uv.yz * 0.4 + vec2(uv.x, time * 0.5) * 0.4).r;
  float texColorG = texture2D(noiseTex, uv.zx * 0.4 + vec2(uv.y, time * 0.5) * 0.4).g;
  float texColorB = texture2D(noiseTex, uv.xy * 0.4 + vec2(uv.z, time * 0.5) * 0.4).b;
  vec3 noisePosition = vec3(texColorR, texColorG, texColorB) * 2.0 - 1.0;
  vec4 mvPosition = viewMatrix * modelMatrix * vec4(position + noisePosition * movable * 0.5 + (1.0 - noisePosition) * (1.0 - movable)* 0.5, 1.0);
  float distanceFromCamera = length(mvPosition.xyz);

  vColor = vec3(texColorR, texColorG, texColorB) * 2.0;

  gl_Position = projectionMatrix * mvPosition;
}