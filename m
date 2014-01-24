Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaAXLIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:08:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38501 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaAXLIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:08:17 -0500
Message-ID: <52E2499B.5060605@ti.com>
Date: Fri, 24 Jan 2014 13:08:11 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] fbdev changes for 3.14
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="sNLBvRxcrJbDNB57SxsMaFKPuNAf4VM2Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sNLBvRxcrJbDNB57SxsMaFKPuNAf4VM2Q
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the fbdev changes for 3.14.

 Tomi

The following changes since commit 802eee95bde72fd0cd0f3a5b2098375a487d1e=
da:

  Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-3.14

for you to fetch changes up to cb1fbad7ec250ac408a4682d38b205958a17a02b:

  Merge branches '3.14/fbdev', '3.14/dss-misc' and '3.14/dss-fclk' into f=
or-next (2014-01-20 10:57:01 +0200)

----------------------------------------------------------------

fbdev changes for 3.14

This is a rather boring pull request. There is one new fb driver, OpenCor=
es
VGA/LCD, but other than that it's just minor cleanups and fixes.

----------------------------------------------------------------
Archit Taneja (2):
      OMAPDSS: HDMI4: Accept non-standard timings
      OMAPDSS: DISPC: Preload more data in pipeline DMAs for OMAP4+ SoCs

Dan Carpenter (3):
      video: mmp: delete a stray mutex_unlock()
      video: mmp: Using plain integer as NULL pointer
      tgafb: potential NULL dereference in init

Geert Uytterhoeven (1):
      video/logo: Remove MIPS-specific include section

Ivaylo Dimitrov (1):
      OMAPDSS: DISPC: Fix 34xx overlay scaling calculation

Jingoo Han (4):
      video: asiliantfb: remove unnecessary pci_set_drvdata()
      video: nvidiafb: remove unnecessary pci_set_drvdata()
      video: rivafb: remove unnecessary pci_set_drvdata()
      video: vmlfb: remove unnecessary pci_set_drvdata()

Julia Lawall (1):
      i810: delete useless variable

Laurent Pinchart (1):
      fbdev: sh_mobile_lcdcfb: Don't use plain 0 as NULL pointer

Lothar Wa=DFmann (2):
      video: mxsfb: convert pr_debug()/dev_dbg() to pr_err()/dev_err() fo=
r error messages
      video: mxsfb: fix broken videomode selection

Mark Brown (2):
      video: vgacon: Don't build on arm64
      video: amba-clcd: Make CLCD driver available on more platforms

Masami Ichikawa (1):
      fbcon: Fix memory leak in fbcon_exit().

Olaf Hering (1):
      fbmem: really support wildcard video=3Doptions for all fbdev driver=
s

Sachin Kamat (4):
      video: ep93xx: Cleanup video-ep93xx.h header
      video: msm: Cleanup video-msm_fb.h header
      video: pxa: Cleanup video-pxafb.h header
      video: pxa168fb: Cleanup pxa168fb.h file

Sascha Hauer (1):
      video: mx3fb: Allow blocking during framebuffer allocation

Stefan Kristiansson (1):
      video: add OpenCores VGA/LCD framebuffer driver

Tomi Valkeinen (25):
      OMAPDSS: fix omap2 dss fck handling
      OMAPDSS: remove struct dss_clock_info
      OMAPDSS: simplify dss clk dump
      OMAPDSS: rename parent clk variables
      OMAPDSS: cleanup fck parent handling
      OMAPDSS: pass pck to dss fck clock calc
      OMAPDSS: add dedicated fck PLL support
      OMAPDSS: fix missing EXPORT_SYMBOL()s
      OMAPDSS: fix debug prints
      OMAPDSS: apply fixes
      OMAPDSS: DISPC: Add MFLAG defines
      OMAPDSS: rename display-sysfs 'name' entry
      OMAPDSS: DSI: fix fifosize
      OMAPDSS: HDMI4: remove useless func calls
      OMAPDSS: DISPC: fix context restore
      OMAPDSS: HDMI: fix hdmi_wait_for_bit_change
      OMAPDSS: HDMI: fix HDMI_WP_CLK name
      OMAPDSS: HDMI: add missing core irq
      OMAPDSS: DSI: split DSI memory map to smaller blocks
      OMAPDSS: HDMI: rename resource names
      OMAPFB: give informative print when probe succeeds
      OMAPDSS: don't print errors on -EPROBE_DEFER
      OMAPFB: disable overlays on driver removal
      OMAPDSS: panel-acx565akm: clean-up locking
      Merge branches '3.14/fbdev', '3.14/dss-misc' and '3.14/dss-fclk' in=
to for-next

Wang YanQing (1):
      fbcon: trivial optimization for fbcon_exit

Yijing Wang (1):
      video: Replace local macro with PCI standard macro

 drivers/video/Kconfig                              |  19 +-
 drivers/video/Makefile                             |   1 +
 drivers/video/asiliantfb.c                         |   1 -
 drivers/video/console/Kconfig                      |   3 +-
 drivers/video/console/fbcon.c                      |   5 +-
 drivers/video/fbmem.c                              |   3 +
 drivers/video/i810/i810_main.c                     |   4 +-
 drivers/video/logo/logo.c                          |   4 -
 drivers/video/mmp/core.c                           |   9 +-
 drivers/video/mx3fb.c                              |   2 +-
 drivers/video/mxsfb.c                              | 126 +++---
 drivers/video/nvidia/nvidia.c                      |   1 -
 drivers/video/ocfb.c                               | 440 +++++++++++++++=
++++++
 .../omap2/displays-new/panel-sony-acx565akm.c      |  44 ++-
 drivers/video/omap2/dss/apply.c                    |  11 +-
 drivers/video/omap2/dss/dispc.c                    |  55 ++-
 drivers/video/omap2/dss/dispc.h                    |  20 +
 drivers/video/omap2/dss/display-sysfs.c            |   4 +-
 drivers/video/omap2/dss/dpi.c                      |  18 +-
 drivers/video/omap2/dss/dsi.c                      | 223 +++++++----
 drivers/video/omap2/dss/dss.c                      | 163 +++-----
 drivers/video/omap2/dss/dss.h                      |  17 +-
 drivers/video/omap2/dss/dss_features.c             |   1 +
 drivers/video/omap2/dss/dss_features.h             |   1 +
 drivers/video/omap2/dss/hdmi.h                     |  16 +-
 drivers/video/omap2/dss/hdmi4.c                    |  22 +-
 drivers/video/omap2/dss/hdmi4_core.c               |  18 +-
 drivers/video/omap2/dss/hdmi_common.c              |   2 +
 drivers/video/omap2/dss/hdmi_phy.c                 |   2 +-
 drivers/video/omap2/dss/hdmi_pll.c                 |  18 +-
 drivers/video/omap2/dss/hdmi_wp.c                  |  16 +-
 drivers/video/omap2/dss/overlay.c                  |   5 -
 drivers/video/omap2/dss/sdi.c                      |  24 +-
 drivers/video/omap2/dss/venc.c                     |   3 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |  19 +
 drivers/video/riva/fbdev.c                         |   1 -
 drivers/video/sh_mobile_lcdcfb.c                   |   2 +-
 drivers/video/tgafb.c                              |  21 +-
 drivers/video/vermilion/vermilion.c                |   1 -
 include/linux/platform_data/video-ep93xx.h         |  10 +-
 include/linux/platform_data/video-msm_fb.h         |   3 +-
 include/linux/platform_data/video-pxafb.h          |   2 -
 include/video/pxa168fb.h                           |   2 -
 43 files changed, 949 insertions(+), 413 deletions(-)
 create mode 100644 drivers/video/ocfb.c


--sNLBvRxcrJbDNB57SxsMaFKPuNAf4VM2Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS4kmbAAoJEPo9qoy8lh71ffkP/3gF+qmD6IPvVqrIqJ3G7NCH
QEaER/DTdC6o5ywwemeOBCcu5msDPseTkef1799IFyiAqY6jqkh91kEkn99brnAo
Hznd1WYk6WLanp1Qq/Q0YS2REMItuFwyzTYqGA2gV0DqLUJL0K8GaECU8Yp5Oo3S
Xqy3ekOUutasPbe4Dx+R6OMC0yxLbw8inylO1LZX+jRSW5yeeLlvI6vhqJ9M9PAi
00l687OptiU//fJnPaWFLUVglV5swOc2LNpq+Q8e94CMipKr3mu9jPTjQZ2sNLpq
kdo27EG3T1awYDMVyqOnZbGzfhIaI7Mk4Z+Awur0wRbmXka4uVcyWgt7rZ5n9je7
m4yX+oLg0SXcYNsFLFPtlOWbE7rfkAVUc0Lhoui5l+/RbRn/eVtVTqx8bSX8Jntv
OukQ2J8N0JgJQHqIJ90HJAFcFKE12TYMFHl3gxakMorkYGWnrAeuLx0yKm04quyn
/UM64B7kTly9nwzhwAcuYOLP3QtPxA3K3ySk9yO1dlAUfN18CvGiDi6S2eDxRdfY
2QSn4f1CncrSmNpiptBnn1RFS/e+WqV9Susjilnr7rj+T6dY3nOdwF1m05N1icXJ
lFFVeCFreRk7gwA3Y8SkBJ+f1k4HsiUdJIzbd3j+TYT889fkoRgE432AwhG8EBW3
gatIIz1F+ZL5ZcKqZOS8
=xACM
-----END PGP SIGNATURE-----

--sNLBvRxcrJbDNB57SxsMaFKPuNAf4VM2Q--
