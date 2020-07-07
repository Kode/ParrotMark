let project = new Project('ParrotMark');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');
resolve(project);
