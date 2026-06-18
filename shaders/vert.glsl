#version 300 es

layout(location = 0) in vec3 vPosition;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec2 vTexCoord;

uniform mat4 worldMat, viewMat, projMat;
uniform vec3 eyePos;

out vec3 fNormal, fView;
out vec3 vWorldPos;
out vec2 fTexCoord;

void main() {
    
    fNormal = normalize(transpose(inverse(mat3(worldMat))) * normalize(vNormal));

    vec3 worldPos = (worldMat * vec4(vPosition, 1)).xyz;
    vWorldPos = worldPos;
    
    fView = normalize(eyePos - worldPos);

    gl_Position = projMat * viewMat * vec4(worldPos, 1);

    fTexCoord = vTexCoord;
}