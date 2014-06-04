Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaFDMaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:30:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48172 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaFDMa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:30:28 -0400
Message-ID: <538F1160.1000803@ti.com>
Date: Wed, 4 Jun 2014 15:30:24 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] omap fbdev changes for 3.16
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="rrL5eOVJqHcXctxcTWtUtcDFxbgK2Pgrp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rrL5eOVJqHcXctxcTWtUtcDFxbgK2Pgrp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the omap fbdev changes for 3.16.

 Tomi

The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2=
fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-omap-3.16

for you to fetch changes up to f2dd36ac9974cc2353bcbb8e6b643fb96030564c:

  OMAPDSS: move 'compatible' converter to omapdss driver (2014-05-28 09:2=
5:15 +0300)

----------------------------------------------------------------
fbdev changes for 3.16 (omap)

* DT support for the panel drivers that were still missing it
* TI AM43xx support
* TI OMAP5 support

----------------------------------------------------------------
Archit Taneja (4):
      omapdss: remove check for simpler port/endpoint binding
      OMAPDSS: HDMI: support larger register offsets for OMAP5 HDMI core
      OMAPDSS: HDMI: PHY changes for OMAP5
      OMAPDSS: HDMI: PLL changes for OMAP5

Arnd Bergmann (1):
      video: omap2dss: fix LPAE warnings

Fabian Frederick (1):
      OMAPDSS: add __exit to dss_uninit_ports

Jyri Sarha (1):
      OMAPDSS: hdmi5_core: Fix compilation with OMAP5_DSS_HDMI_AUDIO

Marek Belisko (2):
      omapdss: panel-tpo-td028ec1: Add DT support.
      omapdss: panel-tpo-td028ec1: Add module alias

Sathya Prakash M R (1):
      OMAPDSS: Add DSS features for AM43xx

Tomi Valkeinen (33):
      OMAPDSS: panel-dpi: use gpiod for enable gpio
      OMAPDSS: panel-dpi: Add DT support
      Doc/DT: Add DT binding documentation for MIPI DPI Panel
      OMAPDSS: connector-hdmi: hpd support
      Doc/DT: hdmi-connector: add HPD GPIO documentation
      OMAPDSS: HDMI: lane config support
      Doc/DT: ti,omap4-dss: hdmi lanes
      OMAPDSS: HDMI4: set regulator voltage to 1.8V
      OMAPDSS: DSI: set regulator voltage to 1.8V
      OMAPDSS: remove venc_panel.c
      OMAPDSS: remove unused macros
      ARM: OMAP: add detection of omap5-dss
      OMAPDSS: DSS & DISPC DT support for OMAP5
      OMAPDSS: features: fix OMAP5 features
      OMAPDSS: DPI: fix LCD3 DSI source
      OMAPDSS: DSI: Add OMAP5 DSI module IDs
      OMAPDSS: HDMI: improve Makefile
      OMAPDSS: HDMI: move irq & phy pwr handling
      OMAPDSS: HDMI: Add OMAP5 HDMI support
      OMAPDSS: HDMI: cleanup ioremaps
      Doc/DT: Add OMAP5 DSS DT bindings
      OMAPDSS: Fix writes to DISPC_POL_FREQ
      OMAPDSS: panel-dpi: enable-gpio
      OMAPDSS: panel-lgphilips-lb035q02: use gpiod for enable gpio
      OMAPDSS: panel-lgphilips-lb035q02: Add DT support
      Doc/DT: Add binding doc for lgphilips,lb035q02.txt
      OMAPDSS: Panel TPO-TD043MTEA1 DT support
      Doc/DT: Add DT binding documentation for TPO td043mtea1 panel
      OMAPDSS: panel NEC-NL8048HL11 DT support
      OMAPDSS: HDMI: cleanup WP ioremaps
      OMAPDSS: HDMI: remove unused defines
      OMAPDSS: HDMI: fix devm_ioremap_resource error checks
      OMAPDSS: move 'compatible' converter to omapdss driver

Tony Lindgren (3):
      OMAPDSS: panel-sharp-ls037v7dw01: update to use gpiod
      OMAPDSS: panel sharp-ls037v7dw01 DT support
      Doc/DT: Add DT binding documentation for SHARP LS037V7DW01

 .../devicetree/bindings/video/hdmi-connector.txt   |   1 +
 .../bindings/video/lgphilips,lb035q02.txt          |  33 +
 .../devicetree/bindings/video/panel-dpi.txt        |  45 +
 .../bindings/video/sharp,ls037v7dw01.txt           |  43 +
 .../devicetree/bindings/video/ti,omap4-dss.txt     |   4 +
 .../devicetree/bindings/video/ti,omap5-dss.txt     |  96 +++
 .../bindings/video/toppoly,td028ttec1.txt          |  30 +
 .../devicetree/bindings/video/tpo,td043mtea1.txt   |  33 +
 arch/arm/mach-omap2/display.c                      |  62 +-
 drivers/video/fbdev/omap2/Makefile                 |   2 +-
 .../fbdev/omap2/displays-new/connector-hdmi.c      |  25 +-
 drivers/video/fbdev/omap2/displays-new/panel-dpi.c |  95 ++-
 .../omap2/displays-new/panel-lgphilips-lb035q02.c  |  77 +-
 .../omap2/displays-new/panel-nec-nl8048hl11.c      |  45 +-
 .../omap2/displays-new/panel-sharp-ls037v7dw01.c   | 210 +++--
 .../omap2/displays-new/panel-tpo-td028ttec1.c      |  33 +-
 .../omap2/displays-new/panel-tpo-td043mtea1.c      |  42 +-
 drivers/video/fbdev/omap2/dss/Kconfig              |  26 +-
 drivers/video/fbdev/omap2/dss/Makefile             |   7 +-
 drivers/video/fbdev/omap2/dss/core.c               |   6 +
 drivers/video/fbdev/omap2/dss/dispc.c              |  22 +-
 drivers/video/fbdev/omap2/dss/dpi.c                |   4 +
 drivers/video/fbdev/omap2/dss/dsi.c                |  18 +
 drivers/video/fbdev/omap2/dss/dss.c                |  20 +-
 drivers/video/fbdev/omap2/dss/dss.h                |   3 +
 drivers/video/fbdev/omap2/dss/dss_features.c       |  70 +-
 drivers/video/fbdev/omap2/dss/hdmi.h               |  17 +-
 drivers/video/fbdev/omap2/dss/hdmi4.c              | 113 ++-
 drivers/video/fbdev/omap2/dss/hdmi4_core.c         |  28 +-
 drivers/video/fbdev/omap2/dss/hdmi5.c              | 829 +++++++++++++++=
+++
 drivers/video/fbdev/omap2/dss/hdmi5_core.c         | 922 +++++++++++++++=
++++++
 drivers/video/fbdev/omap2/dss/hdmi5_core.h         | 306 +++++++
 drivers/video/fbdev/omap2/dss/hdmi_common.c        |  41 +
 drivers/video/fbdev/omap2/dss/hdmi_phy.c           | 265 ++++--
 drivers/video/fbdev/omap2/dss/hdmi_pll.c           | 107 ++-
 drivers/video/fbdev/omap2/dss/hdmi_wp.c            |  29 +-
 drivers/video/fbdev/omap2/dss/omapdss-boot-init.c  | 229 +++++
 drivers/video/fbdev/omap2/dss/venc_panel.c         | 232 ------
 include/video/omapdss.h                            |   8 +-
 39 files changed, 3604 insertions(+), 574 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/lgphilips,lb0=
35q02.txt
 create mode 100644 Documentation/devicetree/bindings/video/panel-dpi.txt=

 create mode 100644 Documentation/devicetree/bindings/video/sharp,ls037v7=
dw01.txt
 create mode 100644 Documentation/devicetree/bindings/video/ti,omap5-dss.=
txt
 create mode 100644 Documentation/devicetree/bindings/video/toppoly,td028=
ttec1.txt
 create mode 100644 Documentation/devicetree/bindings/video/tpo,td043mtea=
1.txt
 create mode 100644 drivers/video/fbdev/omap2/dss/hdmi5.c
 create mode 100644 drivers/video/fbdev/omap2/dss/hdmi5_core.c
 create mode 100644 drivers/video/fbdev/omap2/dss/hdmi5_core.h
 create mode 100644 drivers/video/fbdev/omap2/dss/omapdss-boot-init.c
 delete mode 100644 drivers/video/fbdev/omap2/dss/venc_panel.c


--rrL5eOVJqHcXctxcTWtUtcDFxbgK2Pgrp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjxFgAAoJEPo9qoy8lh71BzkP/RAcusGaORXPox8VC2KIKJav
lg5e/oXClCzMyKnPNjjW3ePWYx21oNNh7jtTfZrpPrqv6+5FEiADvAjxjdPqK5CY
ZlbkcTqTJpZIgNoqXySoKAU4khL9N94ZFxjGjkfWQmxxrlj6g/haKhd4wgIazSZ6
gBoBpHj++0wDWztk5B2v/TOudV8BE5ApqyvFlFTM8eHYwT8VVBUE43zj+6oWVg8b
EHUM/TfS/CWGJy5A3iv6Yz1aPu40pUUJcsIK2paMJvkHA1mtMsJSoyt8egul0E1Q
tkE2RTUnftYsfXgCFLLpbRvewtFyPhPseniWJu6Y5qbwmdNlhSiCMcPBeJIhhny8
7Gdvn0ek58xaLE7aaF1KfHC0s3mSSM1kurYdD0E0w3zz+1AFCQ75fda6WvqI6E1+
Vncwd/Lcy6cDhbJUBfMy4xBCgC4Gbq83zZKbFemir1TY4/KmYflh3kA9eqHtIC1F
Vt1xhSpN8lGuKxDaUzhcMOe4BiQaXoOloHHo+QcsMmcvjmZYJMZjd4c9FLo31nkf
xvVUds3Fn1oTtnh9HCLKeQaq2Mj3fgS/1R+lpKH0p/LmF4LmiUoLk/sOvSVdJmnr
mCXneavJ4DyYpCL2f3x9cj/nea+TJNFx3bZGM8uyDwinL5181vf2RJnOKJVvkkst
bB/5Nx2h0qq+KZeF4Wr+
=YFEs
-----END PGP SIGNATURE-----

--rrL5eOVJqHcXctxcTWtUtcDFxbgK2Pgrp--
