const sidebars = {
  guideSidebar: [
    {
      type: 'category',
      label: 'Start',
      collapsed: false,
      items: ['intro', 'install', 'terminal-demos'],
    },
    {
      type: 'category',
      label: 'Reference',
      collapsed: false,
      items: ['freight-toml', 'dependency-management', 'config-toml'],
    },
    {
      type: 'category',
      label: 'Tooling',
      collapsed: false,
      items: ['build-workflow', 'dap-lsp', 'dag'],
    },
    {
      type: 'category',
      label: 'Registry',
      collapsed: false,
      items: ['install-package', 'publish'],
    },
  ],
};

module.exports = sidebars;
