Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab3KMMIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:08:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39453 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447Ab3KMMId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:08:33 -0500
Message-ID: <52836BBB.4010502@ti.com>
Date: Wed, 13 Nov 2013 14:08:27 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] fbdev changes for 3.13
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="AWaKEIr1B23RAiDG9LvbkfxI5A068E5XT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AWaKEIr1B23RAiDG9LvbkfxI5A068E5XT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb7=
3f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-3.13

for you to fetch changes up to 3a41c5dbe8bc396a7fb16ca8739e945bb003342e:

  fb: reorder the lock sequence to fix potential dead lock (2013-11-11 15=
:52:59 +0200)

----------------------------------------------------------------
fbdev changes for 3.13

Nothing particularly stands out in this pull request. The biggest part of=
 the
changes are cleanups.

Maybe one fix to mention is the "fb: reorder the lock sequence to fix pot=
ential
dead lock" which hopefully fixes the fb locking issues reported by multip=
le
persons.

There are also a few commits that have changes to arch/arm/mach-at91 and
arch/avr32, which have been acked by the maintainers.

----------------------------------------------------------------
Archit Taneja (10):
      omapdss: HDMI: create a Wrapper library
      omapdss: HDMI: create a PLL library
      omapdss: HDMI: create a PHY library
      omapdss: HDMI: Use OMAP4 HDMI core functions directly and remove hd=
mi_ip_ops
      omapdss: HDMI: remove hdmi_ip_data struct
      omapdss: HDMI: Clean up the header files
      omapdss: HDMI: add HDMI wrapper IRQ flags
      omapdss: HDMI: Rename hdmi driver files to nicer names
      omapdss: OMAP4: HDMI: remove unnecessary edid macros
      omapdss: HDMI: move common functions to a separate file

David Herrmann (2):
      simplefb: fix unmapping fb during destruction
      simplefb: use write-combined remapping

Gerd Hoffmann (2):
      hyperv-fb: add pci stub
      hyperv-fb: add blanking support

Gu Zheng (1):
      fb: reorder the lock sequence to fix potential dead lock

Guoqing Li (2):
      video: mmp: rb swap setting update for mmp display
      video: mmp: optimize some register setting code

Hanjun Guo (10):
      Video / hecubafb: Use module_platform_driver() to simplify code
      Video / bfin-t350mcqb-fb: Use module_platform_driver() to simplify =
code
      Video / metronomefb: Use module_platform_driver() to simplify code
      Video / jz4740_fb: Use module_platform_driver() to simplify code
      Video / da8xx-fb: Use module_platform_driver() to simplify code
      Video / cobalt_lcdfb: Use module_platform_driver() to simplify code=

      Video / broadsheetfb: Use module_platform_driver() to simplify code=

      Video / bf54x-lq043fb: Use module_platform_driver() to simplify cod=
e
      Video / au1200fb: Use module_platform_driver() to simplify code
      Video / au1100fb: Use module_platform_driver() to simplify code

James Bates (1):
      efifb: prevent null-deref when iterating dmi_list

Jean-Christophe PLAGNIOL-VILLARD (4):
      video: atmel_lcdfb: fix platform data struct
      video: atmel_lcdfb: introduce atmel_lcdfb_power_control
      video: atmel_lcdfb: pass the pdata as params
      video: atmel_lcdfb: add device tree suport

Jett.Zhou (1):
      ARM: mmp: remove the legacy rbswap setting for ttc_dkb platform

Jing Xiang (2):
      video: mmp: calculate pitch value when fb set win
      video: mmp: add pitch info in mmp_win structure

Jingoo Han (41):
      video: au1100fb: Remove casting the return value which is a void po=
inter
      video: arkfb: remove unnecessary pci_set_drvdata()
      video: carminefb: remove unnecessary pci_set_drvdata()
      video: cirrusfb: remove unnecessary pci_set_drvdata()
      video: cyber2000fb: remove unnecessary pci_set_drvdata()
      video: lxfb: remove unnecessary pci_set_drvdata()
      video: gx1fb: remove unnecessary pci_set_drvdata()
      video: gxfb: remove unnecessary pci_set_drvdata()
      video: i740fb: remove unnecessary pci_set_drvdata()
      video: i810fb: remove unnecessary pci_set_drvdata()
      video: intelfb: remove unnecessary pci_set_drvdata()
      video: kyrofb: remove unnecessary pci_set_drvdata()
      video: mb862xxfb: remove unnecessary pci_set_drvdata()
      video: neofb: remove unnecessary pci_set_drvdata()
      video: pm2fb: remove unnecessary pci_set_drvdata()
      video: pm3fb: remove unnecessary pci_set_drvdata()
      video: s3fb: remove unnecessary pci_set_drvdata()
      video: savagefb: remove unnecessary pci_set_drvdata()
      video: sisfb: remove unnecessary pci_set_drvdata()
      video: tdfxfb: remove unnecessary pci_set_drvdata()
      video: tridentfb: remove unnecessary pci_set_drvdata()
      video: vt8623fb: remove unnecessary pci_set_drvdata()
      video: atmel_lcdfb: use dev_get_platdata()
      video: mx3fb: use dev_get_platdata()
      video: nuc900fb: use dev_get_platdata()
      video: omapfb: use dev_get_platdata()
      video: pxa168fb: use dev_get_platdata()
      video: pxafb: use dev_get_platdata()
      video: s3c2410: use dev_get_platdata()
      video: sa1100fb: use dev_get_platdata()
      video: sh_mobile_hdmi: use dev_get_platdata()
      video: amba-clcd: use dev_get_platdata()
      video: da8xx-fb: use dev_get_platdata()
      video: ep93xx-fb: use dev_get_platdata()
      video: imxfb: use dev_get_platdata()
      video: mbxfb: use dev_get_platdata()
      video: s1d13xxxfb: use dev_get_platdata()
      video: s3c-fb: use dev_get_platdata()
      video: simplefb: use dev_get_platdata()
      video: tmiofb: use dev_get_platdata()
      video: w100fb: use dev_get_platdata()

Joe Perches (4):
      framebuffer: arkfb: Fix framebugger typo
      framebuffer: Add fb_<level> convenience logging macros
      framebuffer: Use fb_<level>
      video: Remove unnecessary semicolons

Jon Mason (2):
      aty128fb: Use pci_dev pm_cap
      radeonfb: Use pci_dev pm_cap

Lars-Peter Clausen (2):
      video: jz4740-fb: Fix LCD_CMD bit definitions
      video: jz4740-fb: Use clk_prepare_enable/clk_disable_unprepare

Laurent Pinchart (2):
      fbdev: shmobile-hdmi: Convert to clk_prepare/unprepare
      fbdev: shmobile-lcdcfb: Convert to clk_prepare/unprepare

Manish Badarkhe (1):
      video: da8xx-fb: remove unwanted define

Marek Belisko (1):
      omapdss: Add new panel driver for Topolly td028ttec1 LCD.

Michal Simek (4):
      video: amba-clcd: Remove unnecessary amba_set_drvdata()
      video: xilinxfb: Use standard variable name convention
      video: xilinxfb: Use devm_kzalloc instead of kzalloc
      video: xilinxfb: Simplify error path

Peter Huewe (1):
      video/matrox/matroxfb_maven: Use module_i2c_driver to register driv=
er

Peter Senna Tschudin (1):
      OMAPDSS: DISPC: Fix assignment of 0/1 to bool variables

Ricardo Neri (7):
      OMAPDSS: HDMI: OMAP4: Complete register definitions for wrapper
      OMAPDSS: HDMI: OMAP4: Complete dumping of wrapper registers
      OMAPDSS: HDMI: OMAP4: Complete register definitions for DPLL
      OMAPDSS: HDMI: OMAP4: Complete dumping of DPLL registers
      OMAPDSS: HDMI: OMAP4: Rename the HDMI_CORE_CTRL1 register
      OMAPDSS: HDMI: OMAP4: Complete register definitions for core
      OMAPDSS: HDMI: OMAP4: Complete dumping of core registers

Richard R=F6jfors (1):
      OMAPDSS: HDMI: Correctly compare timings

Roel Kluin (1):
      OMAPDSS: Fix de_level in videomode_to_omap_video_timings()

Sachin Kamat (33):
      video: grvga: Use module_platform_driver
      backlight: l4f00242t03: Remove redundant spi_set_drvdata
      backlight: tosa: Remove redundant spi_set_drvdata
      video: udlfb: Use NULL instead of 0
      video: smscufx: Use NULL instead of 0
      video: da8xx-fb: Staticize reg_context
      video: aty: Remove redundant break
      video: kyro: Remove redundant break
      video: uvesafb: Remove redundant NULL check
      video: vfb: Remove incorrect check
      video: cirrusfb: Remove incorrect checks
      video: aty: Remove incorrect checks
      video: riva: Remove incorrect checks
      video: atmel_lcdfb: Remove redundant dev_set_drvdata
      video: grvga: Remove redundant dev_set_drvdata
      video: leo: Remove redundant dev_set_drvdata
      video: mb862xx: Remove redundant dev_set_drvdata
      video: amifb: Remove redundant dev_set_drvdata
      video: bw2: Remove redundant dev_set_drvdata
      video: cg14: Remove redundant dev_set_drvdata
      video: cg3: Remove redundant dev_set_drvdata
      video: cg6: Remove redundant dev_set_drvdata
      video: ffb: Remove redundant dev_set_drvdata
      video: p9100: Remove redundant dev_set_drvdata
      video: platinumfb: Remove redundant dev_set_drvdata
      video: sunxvr1000: Remove redundant dev_set_drvdata
      video: tcx: Remove redundant dev_set_drvdata
      video: xilinxfb: Remove redundant dev_set_drvdata
      video: ssd1307fb: Remove redundant of_match_ptr
      video: wm8505fb: Remove redundant of_match_ptr
      video: wmt_ge_rops: Remove redundant of_match_ptr
      video: wmt_ge_rops: Fix a trivial typo
      video: exynos_mipi_dsi: Unlock the mutex before returning

Sangjung Woo (1):
      fbdev: sh_mobile_hdmi: Use devm_kzalloc()

Stephen Rothwell (1):
      video: xilinxfb: Fix for "Use standard variable name convention"

Thierry Reding (1):
      radeon: Conditionally compile PM code

Tom Gundersen (1):
      simplefb: print some info about the registered fb

Tomi Valkeinen (2):
      OMAPDSS: DSI: fix perf measuring ifdefs
      OMAPDSS: connector-dvi: fix releasing i2c_adapter

Wei Yongjun (1):
      fbdev: fix error return code in metronomefb_probe()

 .../devicetree/bindings/video/atmel,lcdc.txt       |   75 ++
 arch/arm/mach-at91/at91sam9261_devices.c           |    6 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |    6 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |    6 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    6 +-
 arch/arm/mach-at91/board-sam9261ek.c               |   10 +-
 arch/arm/mach-at91/board-sam9263ek.c               |    6 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    4 +-
 arch/arm/mach-at91/board-sam9rlek.c                |    6 +-
 arch/arm/mach-at91/board.h                         |    4 +-
 arch/arm/mach-mmp/ttc_dkb.c                        |    4 +-
 arch/avr32/boards/atngw100/evklcd10x.c             |    8 +-
 arch/avr32/boards/atngw100/mrmt.c                  |    4 +-
 arch/avr32/boards/atstk1000/atstk1000.h            |    2 +-
 arch/avr32/boards/atstk1000/setup.c                |    2 +-
 arch/avr32/boards/favr-32/setup.c                  |    2 +-
 arch/avr32/boards/hammerhead/setup.c               |    2 +-
 arch/avr32/boards/merisc/display.c                 |    2 +-
 arch/avr32/boards/mimc200/setup.c                  |    4 +-
 arch/avr32/mach-at32ap/at32ap700x.c                |    8 +-
 arch/avr32/mach-at32ap/include/mach/board.h        |    4 +-
 drivers/auxdisplay/cfag12864bfb.c                  |    3 +-
 drivers/video/68328fb.c                            |    9 +-
 drivers/video/Kconfig                              |    2 +
 drivers/video/amba-clcd.c                          |    4 +-
 drivers/video/amifb.c                              |    6 +-
 drivers/video/arcfb.c                              |    8 +-
 drivers/video/arkfb.c                              |   49 +-
 drivers/video/asiliantfb.c                         |    4 +-
 drivers/video/atafb.c                              |    7 +-
 drivers/video/atmel_lcdfb.c                        |  344 ++++--
 drivers/video/aty/aty128fb.c                       |    8 +-
 drivers/video/aty/atyfb_base.c                     |    1 -
 drivers/video/aty/radeon_base.c                    |    5 -
 drivers/video/aty/radeon_pm.c                      |   22 +-
 drivers/video/aty/radeonfb.h                       |    1 -
 drivers/video/au1100fb.c                           |   16 +-
 drivers/video/au1200fb.c                           |   16 +-
 drivers/video/backlight/l4f00242t03.c              |    1 -
 drivers/video/backlight/tosa_lcd.c                 |    6 +-
 drivers/video/bf54x-lq043fb.c                      |   14 +-
 drivers/video/bfin-t350mcqb-fb.c                   |   14 +-
 drivers/video/broadsheetfb.c                       |   19 +-
 drivers/video/bw2.c                                |    2 -
 drivers/video/carminefb.c                          |    4 +-
 drivers/video/cfbimgblt.c                          |    2 +-
 drivers/video/cg14.c                               |    6 +-
 drivers/video/cg3.c                                |    2 -
 drivers/video/cg6.c                                |    4 +-
 drivers/video/cirrusfb.c                           |    6 -
 drivers/video/cobalt_lcdfb.c                       |   17 +-
 drivers/video/controlfb.c                          |    4 +-
 drivers/video/cyber2000fb.c                        |    5 -
 drivers/video/da8xx-fb.c                           |   21 +-
 drivers/video/efifb.c                              |    7 +-
 drivers/video/ep93xx-fb.c                          |    2 +-
 drivers/video/exynos/exynos_mipi_dsi_common.c      |    3 +-
 drivers/video/fb-puv3.c                            |    5 +-
 drivers/video/fbmem.c                              |   50 +-
 drivers/video/fbsysfs.c                            |   19 +-
 drivers/video/ffb.c                                |    2 -
 drivers/video/fm2fb.c                              |    2 +-
 drivers/video/fsl-diu-fb.c                         |    2 +-
 drivers/video/gbefb.c                              |    6 +-
 drivers/video/geode/gx1fb_core.c                   |    3 +-
 drivers/video/geode/gxfb_core.c                    |    3 +-
 drivers/video/geode/lxfb_core.c                    |    4 +-
 drivers/video/grvga.c                              |   16 +-
 drivers/video/gxt4500.c                            |    3 +-
 drivers/video/hecubafb.c                           |   19 +-
 drivers/video/hgafb.c                              |    3 +-
 drivers/video/hitfb.c                              |    3 +-
 drivers/video/hpfb.c                               |    3 +-
 drivers/video/hyperv_fb.c                          |   45 +-
 drivers/video/i740fb.c                             |    9 +-
 drivers/video/i810/i810_main.c                     |    1 -
 drivers/video/igafb.c                              |    5 +-
 drivers/video/imsttfb.c                            |    4 +-
 drivers/video/imxfb.c                              |    6 +-
 drivers/video/intelfb/intelfbdrv.c                 |    2 -
 drivers/video/jz4740_fb.c                          |   29 +-
 drivers/video/kyro/fbdev.c                         |   10 +-
 drivers/video/leo.c                                |    4 +-
 drivers/video/macfb.c                              |    3 +-
 drivers/video/matrox/matroxfb_DAC1064.c            |    4 +-
 drivers/video/matrox/matroxfb_Ti3026.c             |    2 +-
 drivers/video/matrox/matroxfb_base.c               |    6 +-
 drivers/video/matrox/matroxfb_maven.c              |   14 +-
 drivers/video/mb862xx/mb862xxfbdrv.c               |    3 -
 drivers/video/mbx/mbxfb.c                          |    4 +-
 drivers/video/metronomefb.c                        |   17 +-
 drivers/video/mmp/fb/mmpfb.c                       |   34 +-
 drivers/video/mmp/hw/mmp_ctrl.c                    |   71 +-
 drivers/video/mmp/hw/mmp_ctrl.h                    |    5 +
 drivers/video/mx3fb.c                              |    4 +-
 drivers/video/neofb.c                              |    9 +-
 drivers/video/nuc900fb.c                           |    9 +-
 drivers/video/nvidia/nv_hw.c                       |    2 +-
 drivers/video/offb.c                               |    3 +-
 drivers/video/omap/hwa742.c                        |    2 +-
 drivers/video/omap/omapfb_main.c                   |    4 +-
 drivers/video/omap2/displays-new/Kconfig           |    6 +
 drivers/video/omap2/displays-new/Makefile          |    1 +
 drivers/video/omap2/displays-new/connector-dvi.c   |    7 +
 drivers/video/omap2/displays-new/panel-dsi-cm.c    |    2 +-
 .../omap2/displays-new/panel-tpo-td028ttec1.c      |  480 ++++++++
 drivers/video/omap2/dss/Makefile                   |    3 +-
 drivers/video/omap2/dss/core.c                     |    4 +-
 drivers/video/omap2/dss/dispc.c                    |   10 +-
 drivers/video/omap2/dss/display.c                  |    2 +-
 drivers/video/omap2/dss/dsi.c                      |   12 +-
 drivers/video/omap2/dss/dss.h                      |    4 +-
 drivers/video/omap2/dss/dss_features.c             |   44 -
 drivers/video/omap2/dss/dss_features.h             |    8 -
 drivers/video/omap2/dss/hdmi.c                     | 1184 --------------=
------
 drivers/video/omap2/dss/hdmi.h                     |  444 ++++++++
 drivers/video/omap2/dss/hdmi4.c                    |  696 ++++++++++++
 .../omap2/dss/{ti_hdmi_4xxx_ip.c =3D> hdmi4_core.c}  |  771 ++++--------=
-
 .../omap2/dss/{ti_hdmi_4xxx_ip.h =3D> hdmi4_core.h}  |  303 ++---
 drivers/video/omap2/dss/hdmi_common.c              |  423 +++++++
 drivers/video/omap2/dss/hdmi_phy.c                 |  160 +++
 drivers/video/omap2/dss/hdmi_pll.c                 |  230 ++++
 drivers/video/omap2/dss/hdmi_wp.c                  |  271 +++++
 drivers/video/omap2/dss/ti_hdmi.h                  |  187 ----
 drivers/video/p9100.c                              |    2 -
 drivers/video/platinumfb.c                         |    3 +-
 drivers/video/pm2fb.c                              |    5 +-
 drivers/video/pm3fb.c                              |    4 +-
 drivers/video/pmag-ba-fb.c                         |    4 +-
 drivers/video/pmagb-b-fb.c                         |    9 +-
 drivers/video/pvr2fb.c                             |   25 +-
 drivers/video/pxa168fb.c                           |    6 +-
 drivers/video/pxafb.c                              |   16 +-
 drivers/video/q40fb.c                              |    3 +-
 drivers/video/riva/fbdev.c                         |    5 -
 drivers/video/s1d13xxxfb.c                         |   15 +-
 drivers/video/s3c-fb.c                             |    2 +-
 drivers/video/s3c2410fb.c                          |    6 +-
 drivers/video/s3fb.c                               |   63 +-
 drivers/video/sa1100fb.c                           |    4 +-
 drivers/video/savage/savagefb_driver.c             |    6 -
 drivers/video/sbuslib.c                            |    2 +-
 drivers/video/sgivwfb.c                            |    4 +-
 drivers/video/sh_mobile_hdmi.c                     |   19 +-
 drivers/video/sh_mobile_lcdcfb.c                   |   14 +-
 drivers/video/simplefb.c                           |   24 +-
 drivers/video/sis/sis_main.c                       |    8 +-
 drivers/video/skeletonfb.c                         |    3 +-
 drivers/video/smscufx.c                            |    2 +-
 drivers/video/ssd1307fb.c                          |    2 +-
 drivers/video/sstfb.c                              |    8 +-
 drivers/video/stifb.c                              |    4 +-
 drivers/video/sunxvr1000.c                         |    2 -
 drivers/video/svgalib.c                            |    4 +-
 drivers/video/sysimgblt.c                          |    2 +-
 drivers/video/tcx.c                                |    6 +-
 drivers/video/tdfxfb.c                             |    1 -
 drivers/video/tgafb.c                              |    4 +-
 drivers/video/tmiofb.c                             |   13 +-
 drivers/video/tridentfb.c                          |    1 -
 drivers/video/udlfb.c                              |    2 +-
 drivers/video/uvesafb.c                            |   25 +-
 drivers/video/valkyriefb.c                         |    2 +-
 drivers/video/vesafb.c                             |    3 +-
 drivers/video/vfb.c                                |   10 +-
 drivers/video/vga16fb.c                            |    3 +-
 drivers/video/vt8500lcdfb.c                        |    2 +-
 drivers/video/vt8623fb.c                           |   41 +-
 drivers/video/w100fb.c                             |    7 +-
 drivers/video/wm8505fb.c                           |   14 +-
 drivers/video/wmt_ge_rops.c                        |    4 +-
 drivers/video/xilinxfb.c                           |   61 +-
 include/linux/fb.h                                 |   12 +
 include/video/atmel_lcdc.h                         |   25 +-
 include/video/mmp_disp.h                           |    6 +
 include/video/omap-panel-data.h                    |   13 +
 176 files changed, 3948 insertions(+), 3104 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/atmel,lcdc.tx=
t
 create mode 100644 drivers/video/omap2/displays-new/panel-tpo-td028ttec1=
=2Ec
 delete mode 100644 drivers/video/omap2/dss/hdmi.c
 create mode 100644 drivers/video/omap2/dss/hdmi.h
 create mode 100644 drivers/video/omap2/dss/hdmi4.c
 rename drivers/video/omap2/dss/{ti_hdmi_4xxx_ip.c =3D> hdmi4_core.c} (55=
%)
 rename drivers/video/omap2/dss/{ti_hdmi_4xxx_ip.h =3D> hdmi4_core.h} (51=
%)
 create mode 100644 drivers/video/omap2/dss/hdmi_common.c
 create mode 100644 drivers/video/omap2/dss/hdmi_phy.c
 create mode 100644 drivers/video/omap2/dss/hdmi_pll.c
 create mode 100644 drivers/video/omap2/dss/hdmi_wp.c
 delete mode 100644 drivers/video/omap2/dss/ti_hdmi.h


--AWaKEIr1B23RAiDG9LvbkfxI5A068E5XT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSg2u7AAoJEPo9qoy8lh71HdcP/iL6j1KQur4FLOo+6XNg+lOJ
rEOJ6B7I7OJieGjSxkxjZvDAf1dEnckagU3/OVUfyJYxdPqNAZf+Oe1IKyHTg3ca
iZulnvT8Ve0a2RSAGQILyU4+1xnnUsU2bvv9fNPUxnUWbUbebJRhOFi9heRZINu0
Ww+UweYylAK+Bhvj8rhSftlNZTB1qEo9Xie+lbdP4rhnXekaB0/AHAQcAWNxpgjT
zd+qyQtIb7s3Voya77kN8ew1xbZX/9UH5FTGdrKhIGHZkQYeFADNzuiosDgMve9E
vafYAcdwMOJzhg/bR5OxtA1bhDQ7/WW7zhDeS3hqTO1LLtguQpF19ZXy7UnkbMDY
QO0HtCNCIfXmGPVI9VClSxnNTB+tWzz/i5IutqOPds0OD7gCYisqQoZ0qFy0r/dk
nMsyly70YxkrAxoW7vZc3xY/lkhSKtZ9NLo9WrZuSSQ4LbT70N7ktR5RKLWZBUsW
y6QsMl/i/7tzIu4L7J5wMuf0NtanE4ft7p7kNO3O81XIhFPUFx72b7sVCXW2moTW
KBdb+xGQUY9GnRCYzCWajjBlQJkV5Ffr6UrRiqan/FkUp4WVkKY4vuWcCkWv11SH
bFv25pcmASxoBVnw4PhjwOf8uAUIOZo2ELgviLS23SXCKg9DlS7uuLJeyGZZJE9R
I7A78dEP8OeSndENFPaL
=DN04
-----END PGP SIGNATURE-----

--AWaKEIr1B23RAiDG9LvbkfxI5A068E5XT--
