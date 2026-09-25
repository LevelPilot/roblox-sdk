// @ts-check

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Raiblax Analytics',
  tagline: 'Roblox telemetry without exposing a key.',
  favicon: 'img/favicon.svg',
  url: 'https://raiblax-roblox-sdk-docs.sn0wdev.chatgpt.site',
  baseUrl: '/',
  organizationName: 'Raiblax',
  projectName: 'roblox-sdk',
  onBrokenLinks: 'throw',
  markdown: {
    hooks: {
      onBrokenMarkdownLinks: 'throw',
    },
  },
  presets: [
    [
      'classic',
      {
        docs: {
		  path: 'content',
          routeBasePath: '/',
          sidebarPath: './sidebars.js',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      },
    ],
  ],

  themeConfig: {
    colorMode: {
      defaultMode: 'dark',
      respectPrefersColorScheme: false,
    },
    image: 'img/favicon.svg',
    navbar: {
      title: 'raiblax',
      logo: {
        alt: 'Raiblax',
        src: 'img/favicon.svg',
      },
      items: [
        { type: 'docSidebar', sidebarId: 'sdkSidebar', position: 'left', label: 'Documentation' },
        { to: '/api', label: 'API reference', position: 'left' },
        { href: 'https://github.com/Raiblax/roblox-sdk', label: 'GitHub', position: 'right' },
      ],
    },
    footer: {
      style: 'dark',
      copyright: 'Raiblax Analytics · Roblox SDK',
    },
    prism: {
      additionalLanguages: ['lua'],
    },
  },
};

module.exports = config;
