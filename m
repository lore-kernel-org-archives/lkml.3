Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763331Ab3IEGw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 02:52:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53636 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763267Ab3IEGw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 02:52:27 -0400
Message-ID: <52282A25.8010904@ti.com>
Date: Thu, 5 Sep 2013 09:52:21 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] OMAP fbdev changes for 3.12
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="T331xTlq3hWU4CL2cuC7KUKGvLuta5eBP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--T331xTlq3hWU4CL2cuC7KUKGvLuta5eBP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are the OMAP specific fbdev changes for 3.12.

I've got this pull request separate from the main fbdev pull request, as =
this
contains a bunch of OMAP board file changes and thus could possibly be
rejected in case of bad conflicts.

The removal of the old display drivers depend on the board file changes, =
so
Tony Lindgren suggested taking them together via fbdev tree. These are in=

linux-next, and also Tony didn't see any conflicts with any of the branch=
es he
had, so they should go in clean.

 Tomi

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305=
fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-3.12-omap-legacy-removal

for you to fetch changes up to 9560dc1059222d059d494a64e5da4c54d23838da:

  OMAPDSS: rename omap_dss_device's 'device' field to 'dst' (2013-08-30 0=
8:51:11 +0300)

----------------------------------------------------------------
OMAP specific fbdev changes for 3.12:

* Change the OMAP board files to use the new OMAP display drivers
* Remove all the old drivers, and the related auxiliary code.

----------------------------------------------------------------
Tomi Valkeinen (35):
      ARM: OMAP2+: Remove legacy DSS initialization for omap4
      ARM: OMAP2+: Add selected display drivers to omap2plus_defconfig
      ARM: OMAP: dss-common: use new display drivers
      ARM: OMAP: 4430SDP: remove picodlp device data
      ARM: OMAP: overo: use new display drivers
      ARM: OMAP: rx51: use new display drivers
      ARM: OMAP: beagle: use new display drivers
      ARM: OMAP: devkit8000: use new display drivers
      ARM: OMAP: 2430SDP: use new display drivers
      ARM: OMAP: LDP: use new display drivers
      ARM: OMAP: omap3stalker: use new display drivers
      ARM: OMAP: igep0020: use new display drivers
      ARM: OMAP: cm-t35: use new display drivers
      ARM: OMAP: H4: use new display drivers
      ARM: OMAP: 3430SDP: use new display drivers
      ARM: OMAP: OMAP3EVM: use new display drivers
      ARM: OMAP: Pandora: use new display drivers
      ARM: OMAP: Zoom: use new display drivers
      ARM: OMAP: AM3517EVM: use new display drivers
      ARM: OMAP2+: Remove old display drivers from omap2plus_defconfig
      OMAPDSS: RFBI: Mark RFBI as broken
      OMAPDSS: remove omap_dss_device->channel field
      OMAPDSS: fix DPI and SDI device ids
      OMAPDSS: SDI: change regulator handling
      OMAPDSS: DPI: change regulator handling
      OMAPDSS: remove all old panel drivers
      OMAPDSS: DPI: remove code related to old panel model
      OMAPDSS: HDMI: remove code related to old panel model
      OMAPDSS: DSI: remove code related to old panel model
      OMAPDSS: SDI: remove code related to old panel model
      OMAPDSS: VENC: remove code related to old panel model
      OMAPDSS: RFBI: remove code related to old panel model
      OMAPDSS: DSS: remove legacy dss bus support
      OMAPDSS: rename omap_dss_device's 'output' to 'src'
      OMAPDSS: rename omap_dss_device's 'device' field to 'dst'

 arch/arm/configs/omap2plus_defconfig               |   12 +-
 arch/arm/mach-omap2/board-2430sdp.c                |   57 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   83 +-
 arch/arm/mach-omap2/board-am3517evm.c              |  113 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |  100 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   96 +-
 arch/arm/mach-omap2/board-h4.c                     |   48 +-
 arch/arm/mach-omap2/board-igep0020.c               |   36 +-
 arch/arm/mach-omap2/board-ldp.c                    |   68 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   56 +-
 arch/arm/mach-omap2/board-omap3evm.c               |   87 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |   48 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |   61 +-
 arch/arm/mach-omap2/board-overo.c                  |  160 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   12 +
 arch/arm/mach-omap2/board-rx51-video.c             |   35 +-
 arch/arm/mach-omap2/board-zoom-display.c           |   30 +-
 arch/arm/mach-omap2/display.c                      |    4 +-
 arch/arm/mach-omap2/dss-common.c                   |  244 ++-
 arch/arm/mach-omap2/dss-common.h                   |    2 -
 drivers/gpu/drm/omapdrm/omap_encoder.c             |    2 +-
 drivers/video/omap2/Kconfig                        |    1 -
 drivers/video/omap2/Makefile                       |    1 -
 drivers/video/omap2/displays-new/encoder-tfp410.c  |   14 +-
 .../video/omap2/displays-new/encoder-tpd12s015.c   |   14 +-
 drivers/video/omap2/displays/Kconfig               |   75 -
 drivers/video/omap2/displays/Makefile              |   11 -
 drivers/video/omap2/displays/panel-acx565akm.c     |  798 ----------
 drivers/video/omap2/displays/panel-generic-dpi.c   |  744 ----------
 .../omap2/displays/panel-lgphilips-lb035q02.c      |  262 ----
 drivers/video/omap2/displays/panel-n8x0.c          |  616 --------
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |  290 ----
 drivers/video/omap2/displays/panel-picodlp.c       |  559 -------
 drivers/video/omap2/displays/panel-picodlp.h       |  288 ----
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |  198 ---
 drivers/video/omap2/displays/panel-taal.c          | 1551 --------------=
------
 drivers/video/omap2/displays/panel-tfp410.c        |  353 -----
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |  596 --------
 drivers/video/omap2/dss/Kconfig                    |    1 +
 drivers/video/omap2/dss/Makefile                   |    5 +-
 drivers/video/omap2/dss/apply.c                    |    4 +-
 drivers/video/omap2/dss/core.c                     |  324 +---
 drivers/video/omap2/dss/dpi.c                      |  121 +-
 drivers/video/omap2/dss/dsi.c                      |  275 +---
 drivers/video/omap2/dss/dss.h                      |   45 -
 drivers/video/omap2/dss/hdmi.c                     |  307 +---
 drivers/video/omap2/dss/hdmi_panel.c               |  414 ------
 drivers/video/omap2/dss/output.c                   |   22 +-
 drivers/video/omap2/dss/rfbi.c                     |  135 +-
 drivers/video/omap2/dss/sdi.c                      |  119 +-
 drivers/video/omap2/dss/venc.c                     |  122 +-
 include/video/omap-panel-data.h                    |  118 --
 include/video/omapdss.h                            |  106 +-
 53 files changed, 973 insertions(+), 8870 deletions(-)
 delete mode 100644 drivers/video/omap2/displays/Kconfig
 delete mode 100644 drivers/video/omap2/displays/Makefile
 delete mode 100644 drivers/video/omap2/displays/panel-acx565akm.c
 delete mode 100644 drivers/video/omap2/displays/panel-generic-dpi.c
 delete mode 100644 drivers/video/omap2/displays/panel-lgphilips-lb035q02=
=2Ec
 delete mode 100644 drivers/video/omap2/displays/panel-n8x0.c
 delete mode 100644 drivers/video/omap2/displays/panel-nec-nl8048hl11-01b=
=2Ec
 delete mode 100644 drivers/video/omap2/displays/panel-picodlp.c
 delete mode 100644 drivers/video/omap2/displays/panel-picodlp.h
 delete mode 100644 drivers/video/omap2/displays/panel-sharp-ls037v7dw01.=
c
 delete mode 100644 drivers/video/omap2/displays/panel-taal.c
 delete mode 100644 drivers/video/omap2/displays/panel-tfp410.c
 delete mode 100644 drivers/video/omap2/displays/panel-tpo-td043mtea1.c
 delete mode 100644 drivers/video/omap2/dss/hdmi_panel.c


--T331xTlq3hWU4CL2cuC7KUKGvLuta5eBP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSKColAAoJEPo9qoy8lh71hZEQAJFz3yqJLik+DAXrMQj7wwit
uYVQCG1eUgkMFGTzdioiOkN7ksKopFuHp5J3P+wDM9peR6ZHv2DKVlKE/gzSQj4y
D3YcESBZW3I+ePnzLO616xTsS3nMx4D4OznZcoSewrdOvOdJzqe/79J8dCYj5oYX
x9OvkZoq7JsYVyIK325u4qG2e20B9HAE+oHdUo5d8UCnElgUeDZXNcyXjhwvChFk
9s9cMWbizqO/XoAVZjkX+jiA2DSzgdzaXwGRxGVE52a+upXDg1nfRIrBSzwQXkjq
3hd+fr17GpidcDZCXomZ8OKD5a6J+TSi9ITgI1IlKkXu2t+a5WXDBKftd9S2dfVz
S65bfGmGaGmuSlb66Q4AjOjRoIUa7nZGM0cbjTNUF+EEv94K1PRJEZ2eLJwlLxJ6
6jjdVNwIQfjsiQBYmXnc33J+f8GSq5rFZfaQ4rQFfnrPT9y15IE1ZX8aS7J4Cfge
kzpzLAGGWiFPIDGvPUmnM1dqnkL3KiPpZYiegIwDiSKY1a/c5JlzxADpUR5AGCyj
CUAA0H5xrBP74dIqIVDqgzA8sEI1VEmvnr7QGzxpCgi04IyiikAej0Eh1Oxeqmuf
nAkTuLMCu8G8S2Z8SyreWiPliwZqnw6LbjcRxZFbtmNk3KbezWJraFWSIGuDACNF
4SIxhIgATRyrXs8tqFok
=HPrX
-----END PGP SIGNATURE-----

--T331xTlq3hWU4CL2cuC7KUKGvLuta5eBP--
