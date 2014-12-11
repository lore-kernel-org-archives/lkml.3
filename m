Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbaLKNlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:41:44 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56711 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933879AbaLKNll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:41:41 -0500
Message-ID: <54899F0E.4090309@ti.com>
Date: Thu, 11 Dec 2014 15:41:34 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.19
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="NltNdaQRKifKDXhuhh8kJmL9nhO49JUst"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NltNdaQRKifKDXhuhh8kJmL9nhO49JUst
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull fbdev changes for 3.19.

 Tomi

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1d=
a4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-3.19

for you to fetch changes up to 3315764efceaccfb02c7d4c99ef8eed6716cd861:

  Merge branches '3.19/omapdss' and '3.19/simplefb' into fbdev (2014-12-0=
8 09:16:31 +0200)

----------------------------------------------------------------
fbdev changes for 3.19

* support for mx6sl and mx6sx
* OMAP HDMI audio rewrite to make it finally work
* OMAP video PLL work to prepare for new DRA7xx SoCs
* simplefb DT related improvements

----------------------------------------------------------------
Alexey Khoroshilov (1):
      m501fb: don't return zero on failure path in sm501fb_probe()

Archit Taneja (7):
      OMAPDSS: DPI: Use DPI driver data
      OMAPDSS: DPI: Allocate driver data
      OMAPDSS: DPI: Store dpi_data pointer in the DT port's data
      OMAPDSS: DSS: init dss ports cleanly
      OMAPDSS: DT: Get source endpoint by matching reg-id
      OMAPDSS: DPI: Add support for multiple instances
      OMAPDSS: DSS: add a param to dpi_select_source which specifies it's=
 port number

Fabio Estevam (1):
      fbdev: mxsfb: Add support for mx6sl and mx6sx

Hans de Goede (10):
      simplefb: Add simplefb MAINTAINERS entry
      dt-bindings: Add a clocks property to the simple-framebuffer bindin=
g
      dt-bindings: simplefb: Specify node location and handoff related pr=
operties
      of.h: Keep extern declaration of of_* variables when !CONFIG_OF
      simplefb: Add support for enumerating simplefb dt nodes in /chosen
      fbcon: Change fbcon_init from module_init to fs_initcall
      simplefb: Change simplefb_init from module_init to fs_initcall
      simplefb: Fix build errors when CONFIG_COMMON_CLK is not defined
      dt-bindings: simplefb: Drop the advice about using a specific path =
for nodes
      dt-bindings: simplefb-sunxi: Add sunxi simplefb extensions

Jyri Sarha (21):
      OMAPDSS: hdmi_wp: Protect reserved bits in hdmi_wp_audio_config_for=
mat()
      OMAPDSS: hdmi5_core: Initialize mandatory sample_order parameter
      OMAPDSS: hdmi.h: Add HDMI_AUDIO_LAYOUT_6CH enum value
      OMAPDSS: hdmi: Remove most of OMAP[45]_DSS_HDMI_AUDIO ifdefs
      OMAPDSS: hdmi4_core: Remove unused hdmi4_audio_get_dma_port()
      OMAPDSS: hdmi_wp: Add function for getting audio dma address
      OMAPDSS: hdmi: Make hdmi structure public
      OMAPDSS: hdmi: Add pdev pointer for audio_pdev in HDMI DRV data
      OMAPDSS: hdmi.h: Add members to hdmi drvdata for audio implementati=
on
      ASoC: omap-hdmi-audio: Add platform device for OMAP HDMI audio supp=
ort
      OMAPDSS: Kconfig: Remove HDMI audio booleans from Kconfig
      OMAPDSS: hdmi: Make hdmi_mode_has_audio() more user friedly
      OMAPDSS: hdmi4: Remove callbacks for the old ASoC DAI driver
      OMAPDSS: hdmi4: Register ASoC platform device for omap hdmi audio
      OMAPDSS: hdmi5: Remove callbacks for the old ASoC DAI driver
      OMAPDSS: hdmi5: Register ASoC platform device for omap hdmi audio
      ASoC: omap: Remove obsolete HDMI audio code and Kconfig options
      OMAPDSS: Remove all references to obsolete HDMI audio callbacks
      OMAPDSS: hdmi5: Change hdmi_wp idlemode to to no_idle for audio pla=
yback
      OMAPDSS: hdmi: Remove __exit qualifier from hdmi_uninit_output()
      OMAPDSS: hdmi5: Fix bit field for IEC958_AES2_CON_SOURCE

Lad, Prabhakar (3):
      video: fbdev: vt8623fb: suppress build warning
      video: fbdev: s3fb: suppress build warning
      video: fbdev: arkfb: suppress build warning

Luc Verhaegen (3):
      simplefb: formalize pseudo palette handling
      simplefb: add goto error path to probe
      simplefb: add clock handling code

Markus Elfring (12):
      video: fbdev-MMP: Fix typos for the word "destroy"
      video: fbdev-MMP: Fix a typo for the word "destroyed"
      video: fbdev-LCDC: Deletion of an unnecessary check before the func=
tion call "vfree"
      video: uvesafb: Deletion of an unnecessary check before the functio=
n call "uvesafb_free"
      video: udlfb: Deletion of unnecessary checks before the function ca=
ll "vfree"
      video: smscufx: Deletion of unnecessary checks before the function =
call "vfree"
      video: fbdev-SIS: Deletion of unnecessary checks before the functio=
n call "pci_dev_put"
      video: fbdev-OMAP2: Deletion of unnecessary checks before the funct=
ion call "i2c_put_adapter"
      video: mx3fb: Deletion of an unnecessary check before the function =
call "backlight_device_unregister"
      video: fbdev-MMP: Deletion of an unnecessary check before the funct=
ion call "mmp_unregister_path"
      video: fbdev-VIA: Deletion of an unnecessary check before the funct=
ion call "framebuffer_release"
      video: uvesafb: Deletion of an unnecessary check before the functio=
n call "platform_device_put"

Qiang Chen (1):
      video: ARM CLCD: Remove duplicated include in amba-clcd.c

Tomi Valkeinen (23):
      OMAPDSS: DSI: wait for hsdiv clocks when enabling PLL
      OMAPDSS: DSI: remove unused hsdiv wait funcs
      OMAPDSS: DSI: always power on hsclk & hsdiv
      OMAPDSS: DSI: separate LP clock info from dsi_clock_info
      OMAPDSS: DSI: remove clkin from dsi_clock_info
      OMAPDSS: DSI: remove pll_locked field
      OMAPDSS: DSI: use struct copy instead of individual field copy
      OMAPDSS: DSI: rename clkin4ddr to clkdco
      OMAPDSS: DSI: turn hsdivs fields to arrays
      OMAPDSS: DSI: features: combine dsi & dispc hsdivs
      OMAPDSS: DSI: dsi_runtime_get/put in pll_init
      OMAPDSS: Add common PLL code
      OMAPDSS: DSI: use common DSS PLL support
      OMAPDSS: HDMI: fix setting REFSEL
      OMAPDSS: HDMI5: disable interlace modes
      OMAPDSS: HDMI: rewrite HDMI PLL calculation code
      OMAPDSS: HDMI: Remove HDMI PLL reset
      OMAPDSS: HDMI: store WP pointer to hdmi_pll_data
      OMAPDSS: HDMI: split PLL enable & config
      OMAPDSS: HDMI: remove extra poweroff
      OMAPDSS: HDMI: use common DSS PLL support
      OMAPDSS: features: remove unused DSI PLL features
      Merge branches '3.19/omapdss' and '3.19/simplefb' into fbdev

 .../bindings/video/simple-framebuffer-sunxi.txt    |  33 ++
 .../bindings/video/simple-framebuffer.txt          |  68 ++-
 MAINTAINERS                                        |   8 +
 drivers/video/console/fbcon.c                      |   2 +-
 drivers/video/fbdev/Kconfig                        |   2 +-
 drivers/video/fbdev/amba-clcd.c                    |   1 -
 drivers/video/fbdev/arkfb.c                        |   2 +-
 drivers/video/fbdev/mmp/core.c                     |   6 +-
 drivers/video/fbdev/mmp/hw/mmp_ctrl.c              |   3 +-
 drivers/video/fbdev/mx3fb.c                        |   3 +-
 drivers/video/fbdev/mxsfb.c                        |  19 +
 .../video/fbdev/omap2/displays-new/connector-dvi.c |   9 +-
 .../fbdev/omap2/displays-new/connector-hdmi.c      |  99 ----
 .../fbdev/omap2/displays-new/encoder-tfp410.c      |   1 +
 .../fbdev/omap2/displays-new/encoder-tpd12s015.c   |  57 +-
 drivers/video/fbdev/omap2/dss/Kconfig              |   7 -
 drivers/video/fbdev/omap2/dss/Makefile             |   2 +-
 drivers/video/fbdev/omap2/dss/dispc.c              |  20 +-
 drivers/video/fbdev/omap2/dss/dpi.c                | 327 ++++++----
 drivers/video/fbdev/omap2/dss/dsi.c                | 659 ++++++++-------=
------
 drivers/video/fbdev/omap2/dss/dss-of.c             |  58 +-
 drivers/video/fbdev/omap2/dss/dss.c                | 123 ++--
 drivers/video/fbdev/omap2/dss/dss.h                | 225 +++----
 drivers/video/fbdev/omap2/dss/dss_features.c       |  42 --
 drivers/video/fbdev/omap2/dss/dss_features.h       |  12 -
 drivers/video/fbdev/omap2/dss/hdmi.h               |  71 ++-
 drivers/video/fbdev/omap2/dss/hdmi4.c              | 338 +++++------
 drivers/video/fbdev/omap2/dss/hdmi4_core.c         |  14 -
 drivers/video/fbdev/omap2/dss/hdmi4_core.h         |   4 -
 drivers/video/fbdev/omap2/dss/hdmi5.c              | 338 ++++++-----
 drivers/video/fbdev/omap2/dss/hdmi5_core.c         |  11 +-
 drivers/video/fbdev/omap2/dss/hdmi5_core.h         |   2 -
 drivers/video/fbdev/omap2/dss/hdmi_common.c        |   2 -
 drivers/video/fbdev/omap2/dss/hdmi_phy.c           |  31 +-
 drivers/video/fbdev/omap2/dss/hdmi_pll.c           | 313 +++++-----
 drivers/video/fbdev/omap2/dss/hdmi_wp.c            |  16 +-
 drivers/video/fbdev/omap2/dss/output.c             |  19 +-
 drivers/video/fbdev/omap2/dss/pll.c                | 378 ++++++++++++
 drivers/video/fbdev/omap2/dss/sdi.c                |   2 +-
 drivers/video/fbdev/s3fb.c                         |   2 +-
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |   3 +-
 drivers/video/fbdev/simplefb.c                     | 162 ++++-
 drivers/video/fbdev/sis/sis_main.c                 |  14 +-
 drivers/video/fbdev/sm501fb.c                      |   1 +
 drivers/video/fbdev/smscufx.c                      |   6 +-
 drivers/video/fbdev/udlfb.c                        |   9 +-
 drivers/video/fbdev/uvesafb.c                      |   6 +-
 drivers/video/fbdev/via/viafbdev.c                 |   3 +-
 drivers/video/fbdev/vt8623fb.c                     |   2 +-
 include/linux/of.h                                 |   3 +-
 include/sound/omap-hdmi-audio.h                    |  43 ++
 include/video/omapdss.h                            |  45 +-
 sound/soc/omap/Kconfig                             |  26 +-
 sound/soc/omap/Makefile                            |   6 +-
 sound/soc/omap/omap-hdmi-audio.c                   | 407 +++++++++++++
 sound/soc/omap/omap-hdmi-card.c                    |  87 ---
 sound/soc/omap/omap-hdmi.c                         | 364 ------------
 sound/soc/omap/omap-hdmi.h                         |  38 --
 58 files changed, 2398 insertions(+), 2156 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/simple-frameb=
uffer-sunxi.txt
 create mode 100644 drivers/video/fbdev/omap2/dss/pll.c
 create mode 100644 include/sound/omap-hdmi-audio.h
 create mode 100644 sound/soc/omap/omap-hdmi-audio.c
 delete mode 100644 sound/soc/omap/omap-hdmi-card.c
 delete mode 100644 sound/soc/omap/omap-hdmi.c
 delete mode 100644 sound/soc/omap/omap-hdmi.h


--NltNdaQRKifKDXhuhh8kJmL9nhO49JUst
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUiZ8OAAoJEPo9qoy8lh71CP8P/RpWFBcvI8ObZCmYox7u7ni7
0UDIOR4pqb5brfzB/Am76GOeY3g7TIcADpm86v2t84ojaWiwCtQ1J56t6akEsYdn
KqTcq34DiAKEooCSIzxMsfHw3zpgYEaNcNINkezZrjDM2fvYrLf/rlHd30NOqXGs
ZeZysE1f0pgZ+sQrlXbY5lQHN6TxGGz79lhy3tV4H7q518lCFAZjtop0GCpJmCDR
Fo1NJKU6uyqOidoU4a6GJgve/5L64/+eFi27avkXow1m48d3PjnGnfubQeShQnmo
UGry4dsyM3DquyTJ1LW0TnO9OO8eNqcYJJj42Y447h8sNm6Sh9aseDy1YScp2DBi
QXc+5fAcxQnHn1bbnDQiMg0cFM71FAtrvTLAbLLRp/lZXUJxjzS2sVZAIgT6cjjF
Jnkbt/D4ySO2KottTJC461BudH3ZcE4qCHrxuGqPZ62C3/2XN4zi9UFOcnt+4Vwz
OjGfsJDz/lTeNE9ZioucxZZJRgPNIyMjXSnp8SQhT+gh2Wex/qB/mVPBMsjPvd8M
wFYSebUZrnvU990oCTvv8fWl3UHAKKH98XmkHWaDoMF8HJHocsS/WR+tFYDytPIa
j7bwdDDHF4B5twzFPF2QpIlUPuWj7fsOwtplZcV9QLoShhHmlYF0s6E8uLhHQ6AW
t3QSVsmgQpW3bYI4+cp4
=b+S1
-----END PGP SIGNATURE-----

--NltNdaQRKifKDXhuhh8kJmL9nhO49JUst--
