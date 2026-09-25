/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
  sdkSidebar: [
    'intro',
    {
      type: 'category',
      label: 'Get started',
      items: ['installation', 'tracking'],
    },
    {
      type: 'category',
      label: 'Reference',
      items: ['api', 'configuration', 'security'],
    },
  ],
};

module.exports = sidebars;
