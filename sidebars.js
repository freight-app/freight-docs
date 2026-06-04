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
      items: ['freight-toml', 'config-toml'],
    },
    {
      type: 'category',
      label: 'Tooling',
      collapsed: false,
      items: ['dap-lsp', 'dag'],
    },
    {
      type: 'category',
      label: 'Registry',
      collapsed: false,
      items: ['publish'],
    },
  ],
};

module.exports = sidebars;
