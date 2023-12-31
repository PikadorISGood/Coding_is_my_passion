#define RADIATION_ALPHA_PARTICLE "alpha_particle"
#define RADIATION_BETA_PARTICLE  "beta_particle"
#define RADIATION_HAWKING        "hawking"

#define IS_VALID_RADIATION_TYPE(ty) (ty == RADIATION_ALPHA_PARTICLE || ty == RADIATION_BETA_PARTICLE || ty == RADIATION_HAWKING)
#define IS_PARTICLE_RADIATION(ty) (ty == RADIATION_ALPHA_PARTICLE || ty == RADIATION_BETA_PARTICLE)
#define IS_THERMAL_RADIATION(ty) (ty == RADIATION_HAWKING)
#define IS_ELECTROMAGNETIC_RADIATION(ty) IS_THERMAL_RADIATION(ty)
