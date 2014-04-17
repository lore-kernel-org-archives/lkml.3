Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaDQHJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:09:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33773 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbaDQHJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:09:04 -0400
Message-ID: <534F7E08.80604@ti.com>
Date: Thu, 17 Apr 2014 10:08:56 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [GIT PULL] fbdev reorder for 3.15 (rebased)
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="BMIKUXPwW1nXiwkGsKxrXCgnechgt27iF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BMIKUXPwW1nXiwkGsKxrXCgnechgt27iF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit c26ef3eb3c11274bad1b64498d0a134f857552=
50:

  video: bf54x-lq043fb: fix build error (2014-04-15 12:44:16 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-reorder-3.15

for you to fetch changes up to 776bbb97e0a37fe67bd0870e5aa4845af856b872:

  video: Kconfig: move drm and fb into separate menus (2014-04-17 08:10:2=
0 +0300)

----------------------------------------------------------------
Reorder drivers/video/ directory so that all fbdev drivers are now locate=
d in
drivers/video/fbdev/ and the fbdev framework core files are located in
drivers/video/fbdev/core/

The drivers/video/Kconfig is modified so that the DRM and the fbdev menu
options are in separate submenus, instead of both being mixed in the same=

'Graphics support' menu level.

----------------------------------------------------------------
Tomi Valkeinen (3):
      video: move fbdev to drivers/video/fbdev
      fbdev: move fbdev core files to separate directory
      video: Kconfig: move drm and fb into separate menus

 Documentation/DocBook/device-drivers.tmpl          |   10 +-
 drivers/Makefile                                   |    4 +-
 drivers/staging/xgifb/vb_def.h                     |    2 +-
 drivers/staging/xgifb/vb_struct.h                  |    2 +-
 drivers/staging/xgifb/vgatypes.h                   |    4 +-
 drivers/video/Kconfig                              | 2480 +-------------=
------
 drivers/video/Makefile                             |  166 +-
 drivers/video/console/sticon.c                     |    2 +-
 drivers/video/console/sticore.c                    |    2 +-
 drivers/video/{ =3D> fbdev}/68328fb.c                |    0
 drivers/video/fbdev/Kconfig                        | 2474 ++++++++++++++=
+++++
 drivers/video/fbdev/Makefile                       |  152 ++
 drivers/video/{ =3D> fbdev}/acornfb.c                |    0
 drivers/video/{ =3D> fbdev}/acornfb.h                |    0
 drivers/video/{ =3D> fbdev}/amba-clcd.c              |    0
 drivers/video/{ =3D> fbdev}/amifb.c                  |    0
 drivers/video/{ =3D> fbdev}/arcfb.c                  |    0
 drivers/video/{ =3D> fbdev}/arkfb.c                  |    0
 drivers/video/{ =3D> fbdev}/asiliantfb.c             |    0
 drivers/video/{ =3D> fbdev}/atafb.c                  |    0
 drivers/video/{ =3D> fbdev}/atafb.h                  |    0
 drivers/video/{ =3D> fbdev}/atafb_iplan2p2.c         |    0
 drivers/video/{ =3D> fbdev}/atafb_iplan2p4.c         |    0
 drivers/video/{ =3D> fbdev}/atafb_iplan2p8.c         |    0
 drivers/video/{ =3D> fbdev}/atafb_mfb.c              |    0
 drivers/video/{ =3D> fbdev}/atafb_utils.h            |    0
 drivers/video/{ =3D> fbdev}/atmel_lcdfb.c            |    0
 drivers/video/{ =3D> fbdev}/aty/Makefile             |    0
 drivers/video/{ =3D> fbdev}/aty/ati_ids.h            |    0
 drivers/video/{ =3D> fbdev}/aty/aty128fb.c           |    0
 drivers/video/{ =3D> fbdev}/aty/atyfb.h              |    0
 drivers/video/{ =3D> fbdev}/aty/atyfb_base.c         |    0
 drivers/video/{ =3D> fbdev}/aty/mach64_accel.c       |    0
 drivers/video/{ =3D> fbdev}/aty/mach64_ct.c          |    0
 drivers/video/{ =3D> fbdev}/aty/mach64_cursor.c      |    2 +-
 drivers/video/{ =3D> fbdev}/aty/mach64_gx.c          |    0
 drivers/video/{ =3D> fbdev}/aty/radeon_accel.c       |    0
 drivers/video/{ =3D> fbdev}/aty/radeon_backlight.c   |    0
 drivers/video/{ =3D> fbdev}/aty/radeon_base.c        |    0
 drivers/video/{ =3D> fbdev}/aty/radeon_i2c.c         |    0
 drivers/video/{ =3D> fbdev}/aty/radeon_monitor.c     |    0
 drivers/video/{ =3D> fbdev}/aty/radeon_pm.c          |    0
 drivers/video/{ =3D> fbdev}/aty/radeonfb.h           |    0
 drivers/video/{ =3D> fbdev}/au1100fb.c               |    0
 drivers/video/{ =3D> fbdev}/au1100fb.h               |    0
 drivers/video/{ =3D> fbdev}/au1200fb.c               |    0
 drivers/video/{ =3D> fbdev}/au1200fb.h               |    0
 drivers/video/{ =3D> fbdev}/auo_k1900fb.c            |    0
 drivers/video/{ =3D> fbdev}/auo_k1901fb.c            |    0
 drivers/video/{ =3D> fbdev}/auo_k190x.c              |    0
 drivers/video/{ =3D> fbdev}/auo_k190x.h              |    0
 drivers/video/{ =3D> fbdev}/bf537-lq035.c            |    0
 drivers/video/{ =3D> fbdev}/bf54x-lq043fb.c          |    0
 drivers/video/{ =3D> fbdev}/bfin-lq035q1-fb.c        |    0
 drivers/video/{ =3D> fbdev}/bfin-t350mcqb-fb.c       |    0
 drivers/video/{ =3D> fbdev}/bfin_adv7393fb.c         |    0
 drivers/video/{ =3D> fbdev}/bfin_adv7393fb.h         |    0
 drivers/video/{ =3D> fbdev}/broadsheetfb.c           |    0
 drivers/video/{ =3D> fbdev}/bt431.h                  |    0
 drivers/video/{ =3D> fbdev}/bt455.h                  |    0
 drivers/video/{ =3D> fbdev}/bw2.c                    |    0
 drivers/video/{ =3D> fbdev}/c2p.h                    |    0
 drivers/video/{ =3D> fbdev}/c2p_core.h               |    0
 drivers/video/{ =3D> fbdev}/c2p_iplan2.c             |    0
 drivers/video/{ =3D> fbdev}/c2p_planar.c             |    0
 drivers/video/{ =3D> fbdev}/carminefb.c              |    0
 drivers/video/{ =3D> fbdev}/carminefb.h              |    0
 drivers/video/{ =3D> fbdev}/carminefb_regs.h         |    0
 drivers/video/{ =3D> fbdev}/cg14.c                   |    0
 drivers/video/{ =3D> fbdev}/cg3.c                    |    0
 drivers/video/{ =3D> fbdev}/cg6.c                    |    0
 drivers/video/{ =3D> fbdev}/chipsfb.c                |    0
 drivers/video/{ =3D> fbdev}/cirrusfb.c               |    0
 drivers/video/{ =3D> fbdev}/clps711xfb.c             |    0
 drivers/video/{ =3D> fbdev}/cobalt_lcdfb.c           |    0
 drivers/video/{ =3D> fbdev}/controlfb.c              |    0
 drivers/video/{ =3D> fbdev}/controlfb.h              |    0
 drivers/video/fbdev/core/Makefile                  |   16 +
 drivers/video/{ =3D> fbdev/core}/cfbcopyarea.c       |    0
 drivers/video/{ =3D> fbdev/core}/cfbfillrect.c       |    0
 drivers/video/{ =3D> fbdev/core}/cfbimgblt.c         |    0
 drivers/video/{ =3D> fbdev/core}/fb_ddc.c            |    2 +-
 drivers/video/{ =3D> fbdev/core}/fb_defio.c          |    0
 drivers/video/{ =3D> fbdev/core}/fb_draw.h           |    0
 drivers/video/{ =3D> fbdev/core}/fb_notify.c         |    0
 drivers/video/{ =3D> fbdev/core}/fb_sys_fops.c       |    0
 drivers/video/{ =3D> fbdev/core}/fbcmap.c            |    0
 drivers/video/{ =3D> fbdev/core}/fbcvt.c             |    0
 drivers/video/{ =3D> fbdev/core}/fbmem.c             |    0
 drivers/video/{ =3D> fbdev/core}/fbmon.c             |    2 +-
 drivers/video/{ =3D> fbdev/core}/fbsysfs.c           |    0
 drivers/video/{ =3D> fbdev/core}/modedb.c            |    0
 drivers/video/{ =3D> fbdev/core}/svgalib.c           |    0
 drivers/video/{ =3D> fbdev/core}/syscopyarea.c       |    0
 drivers/video/{ =3D> fbdev/core}/sysfillrect.c       |    0
 drivers/video/{ =3D> fbdev/core}/sysimgblt.c         |    0
 drivers/video/{ =3D> fbdev}/cyber2000fb.c            |    0
 drivers/video/{ =3D> fbdev}/cyber2000fb.h            |    0
 drivers/video/{ =3D> fbdev}/da8xx-fb.c               |    0
 drivers/video/{ =3D> fbdev}/dnfb.c                   |    0
 drivers/video/{ =3D> fbdev}/edid.h                   |    0
 drivers/video/{ =3D> fbdev}/efifb.c                  |    0
 drivers/video/{ =3D> fbdev}/ep93xx-fb.c              |    0
 drivers/video/{ =3D> fbdev}/exynos/Kconfig           |    0
 drivers/video/{ =3D> fbdev}/exynos/Makefile          |    0
 drivers/video/{ =3D> fbdev}/exynos/exynos_mipi_dsi.c |    0
 .../{ =3D> fbdev}/exynos/exynos_mipi_dsi_common.c    |    0
 .../{ =3D> fbdev}/exynos/exynos_mipi_dsi_common.h    |    0
 .../{ =3D> fbdev}/exynos/exynos_mipi_dsi_lowlevel.c  |    0
 .../{ =3D> fbdev}/exynos/exynos_mipi_dsi_lowlevel.h  |    0
 .../{ =3D> fbdev}/exynos/exynos_mipi_dsi_regs.h      |    0
 drivers/video/{ =3D> fbdev}/exynos/s6e8ax0.c         |    0
 drivers/video/{ =3D> fbdev}/fb-puv3.c                |    0
 drivers/video/{ =3D> fbdev}/ffb.c                    |    0
 drivers/video/{ =3D> fbdev}/fm2fb.c                  |    0
 drivers/video/{ =3D> fbdev}/fsl-diu-fb.c             |    0
 drivers/video/{ =3D> fbdev}/g364fb.c                 |    0
 drivers/video/{ =3D> fbdev}/gbefb.c                  |    0
 drivers/video/{ =3D> fbdev}/geode/Kconfig            |    0
 drivers/video/{ =3D> fbdev}/geode/Makefile           |    0
 drivers/video/{ =3D> fbdev}/geode/display_gx.c       |    0
 drivers/video/{ =3D> fbdev}/geode/display_gx1.c      |    0
 drivers/video/{ =3D> fbdev}/geode/display_gx1.h      |    0
 drivers/video/{ =3D> fbdev}/geode/geodefb.h          |    0
 drivers/video/{ =3D> fbdev}/geode/gx1fb_core.c       |    0
 drivers/video/{ =3D> fbdev}/geode/gxfb.h             |    0
 drivers/video/{ =3D> fbdev}/geode/gxfb_core.c        |    0
 drivers/video/{ =3D> fbdev}/geode/lxfb.h             |    0
 drivers/video/{ =3D> fbdev}/geode/lxfb_core.c        |    0
 drivers/video/{ =3D> fbdev}/geode/lxfb_ops.c         |    0
 drivers/video/{ =3D> fbdev}/geode/suspend_gx.c       |    0
 drivers/video/{ =3D> fbdev}/geode/video_cs5530.c     |    0
 drivers/video/{ =3D> fbdev}/geode/video_cs5530.h     |    0
 drivers/video/{ =3D> fbdev}/geode/video_gx.c         |    0
 drivers/video/{ =3D> fbdev}/goldfishfb.c             |    0
 drivers/video/{ =3D> fbdev}/grvga.c                  |    0
 drivers/video/{ =3D> fbdev}/gxt4500.c                |    0
 drivers/video/{ =3D> fbdev}/hecubafb.c               |    0
 drivers/video/{ =3D> fbdev}/hgafb.c                  |    0
 drivers/video/{ =3D> fbdev}/hitfb.c                  |    0
 drivers/video/{ =3D> fbdev}/hpfb.c                   |    0
 drivers/video/{ =3D> fbdev}/hyperv_fb.c              |    0
 drivers/video/{ =3D> fbdev}/i740_reg.h               |    0
 drivers/video/{ =3D> fbdev}/i740fb.c                 |    0
 drivers/video/{ =3D> fbdev}/i810/Makefile            |    0
 drivers/video/{ =3D> fbdev}/i810/i810-i2c.c          |    0
 drivers/video/{ =3D> fbdev}/i810/i810.h              |    0
 drivers/video/{ =3D> fbdev}/i810/i810_accel.c        |    0
 drivers/video/{ =3D> fbdev}/i810/i810_dvt.c          |    0
 drivers/video/{ =3D> fbdev}/i810/i810_gtf.c          |    0
 drivers/video/{ =3D> fbdev}/i810/i810_main.c         |    0
 drivers/video/{ =3D> fbdev}/i810/i810_main.h         |    0
 drivers/video/{ =3D> fbdev}/i810/i810_regs.h         |    0
 drivers/video/{ =3D> fbdev}/igafb.c                  |    0
 drivers/video/{ =3D> fbdev}/imsttfb.c                |    0
 drivers/video/{ =3D> fbdev}/imxfb.c                  |    0
 drivers/video/{ =3D> fbdev}/intelfb/Makefile         |    0
 drivers/video/{ =3D> fbdev}/intelfb/intelfb.h        |    0
 drivers/video/{ =3D> fbdev}/intelfb/intelfb_i2c.c    |    0
 drivers/video/{ =3D> fbdev}/intelfb/intelfbdrv.c     |    0
 drivers/video/{ =3D> fbdev}/intelfb/intelfbhw.c      |    0
 drivers/video/{ =3D> fbdev}/intelfb/intelfbhw.h      |    0
 drivers/video/{ =3D> fbdev}/jz4740_fb.c              |    0
 drivers/video/{ =3D> fbdev}/kyro/Makefile            |    0
 drivers/video/{ =3D> fbdev}/kyro/STG4000InitDevice.c |    0
 drivers/video/{ =3D> fbdev}/kyro/STG4000Interface.h  |    0
 .../video/{ =3D> fbdev}/kyro/STG4000OverlayDevice.c  |    0
 drivers/video/{ =3D> fbdev}/kyro/STG4000Ramdac.c     |    0
 drivers/video/{ =3D> fbdev}/kyro/STG4000Reg.h        |    0
 drivers/video/{ =3D> fbdev}/kyro/STG4000VTG.c        |    0
 drivers/video/{ =3D> fbdev}/kyro/fbdev.c             |    0
 drivers/video/{ =3D> fbdev}/leo.c                    |    0
 drivers/video/{ =3D> fbdev}/macfb.c                  |    0
 drivers/video/{ =3D> fbdev}/macmodes.c               |    0
 drivers/video/{ =3D> fbdev}/macmodes.h               |    0
 drivers/video/{ =3D> fbdev}/matrox/Makefile          |    0
 drivers/video/{ =3D> fbdev}/matrox/g450_pll.c        |    0
 drivers/video/{ =3D> fbdev}/matrox/g450_pll.h        |    0
 drivers/video/{ =3D> fbdev}/matrox/i2c-matroxfb.c    |    0
 .../video/{ =3D> fbdev}/matrox/matroxfb_DAC1064.c    |    0
 .../video/{ =3D> fbdev}/matrox/matroxfb_DAC1064.h    |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_Ti3026.c |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_Ti3026.h |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_accel.c  |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_accel.h  |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_base.c   |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_base.h   |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_crtc2.c  |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_crtc2.h  |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_g450.c   |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_g450.h   |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_maven.c  |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_maven.h  |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_misc.c   |    0
 drivers/video/{ =3D> fbdev}/matrox/matroxfb_misc.h   |    0
 drivers/video/{ =3D> fbdev}/maxinefb.c               |    0
 drivers/video/{ =3D> fbdev}/mb862xx/Makefile         |    0
 drivers/video/{ =3D> fbdev}/mb862xx/mb862xx-i2c.c    |    0
 drivers/video/{ =3D> fbdev}/mb862xx/mb862xx_reg.h    |    0
 drivers/video/{ =3D> fbdev}/mb862xx/mb862xxfb.h      |    0
 .../video/{ =3D> fbdev}/mb862xx/mb862xxfb_accel.c    |    0
 .../video/{ =3D> fbdev}/mb862xx/mb862xxfb_accel.h    |    0
 drivers/video/{ =3D> fbdev}/mb862xx/mb862xxfbdrv.c   |    0
 drivers/video/{ =3D> fbdev}/mbx/Makefile             |    0
 drivers/video/{ =3D> fbdev}/mbx/mbxdebugfs.c         |    0
 drivers/video/{ =3D> fbdev}/mbx/mbxfb.c              |    0
 drivers/video/{ =3D> fbdev}/mbx/reg_bits.h           |    0
 drivers/video/{ =3D> fbdev}/mbx/regs.h               |    0
 drivers/video/{ =3D> fbdev}/metronomefb.c            |    0
 drivers/video/{ =3D> fbdev}/mmp/Kconfig              |    6 +-
 drivers/video/{ =3D> fbdev}/mmp/Makefile             |    0
 drivers/video/{ =3D> fbdev}/mmp/core.c               |    0
 drivers/video/{ =3D> fbdev}/mmp/fb/Kconfig           |    0
 drivers/video/{ =3D> fbdev}/mmp/fb/Makefile          |    0
 drivers/video/{ =3D> fbdev}/mmp/fb/mmpfb.c           |    0
 drivers/video/{ =3D> fbdev}/mmp/fb/mmpfb.h           |    0
 drivers/video/{ =3D> fbdev}/mmp/hw/Kconfig           |    0
 drivers/video/{ =3D> fbdev}/mmp/hw/Makefile          |    0
 drivers/video/{ =3D> fbdev}/mmp/hw/mmp_ctrl.c        |    0
 drivers/video/{ =3D> fbdev}/mmp/hw/mmp_ctrl.h        |    0
 drivers/video/{ =3D> fbdev}/mmp/hw/mmp_spi.c         |    0
 drivers/video/{ =3D> fbdev}/mmp/panel/Kconfig        |    0
 drivers/video/{ =3D> fbdev}/mmp/panel/Makefile       |    0
 .../video/{ =3D> fbdev}/mmp/panel/tpo_tj032md01bw.c  |    0
 drivers/video/{ =3D> fbdev}/msm/Makefile             |    0
 drivers/video/{ =3D> fbdev}/msm/mddi.c               |    0
 drivers/video/{ =3D> fbdev}/msm/mddi_client_dummy.c  |    0
 .../video/{ =3D> fbdev}/msm/mddi_client_nt35399.c    |    0
 .../video/{ =3D> fbdev}/msm/mddi_client_toshiba.c    |    0
 drivers/video/{ =3D> fbdev}/msm/mddi_hw.h            |    0
 drivers/video/{ =3D> fbdev}/msm/mdp.c                |    0
 drivers/video/{ =3D> fbdev}/msm/mdp_csc_table.h      |    0
 drivers/video/{ =3D> fbdev}/msm/mdp_hw.h             |    0
 drivers/video/{ =3D> fbdev}/msm/mdp_ppp.c            |    0
 drivers/video/{ =3D> fbdev}/msm/mdp_scale_tables.c   |    0
 drivers/video/{ =3D> fbdev}/msm/mdp_scale_tables.h   |    0
 drivers/video/{ =3D> fbdev}/msm/msm_fb.c             |    0
 drivers/video/{ =3D> fbdev}/mx3fb.c                  |    0
 drivers/video/{ =3D> fbdev}/mxsfb.c                  |    0
 drivers/video/{ =3D> fbdev}/n411.c                   |    0
 drivers/video/{ =3D> fbdev}/neofb.c                  |    0
 drivers/video/{ =3D> fbdev}/nuc900fb.c               |    0
 drivers/video/{ =3D> fbdev}/nuc900fb.h               |    0
 drivers/video/{ =3D> fbdev}/nvidia/Makefile          |    0
 drivers/video/{ =3D> fbdev}/nvidia/nv_accel.c        |    0
 drivers/video/{ =3D> fbdev}/nvidia/nv_backlight.c    |    0
 drivers/video/{ =3D> fbdev}/nvidia/nv_dma.h          |    0
 drivers/video/{ =3D> fbdev}/nvidia/nv_hw.c           |    0
 drivers/video/{ =3D> fbdev}/nvidia/nv_i2c.c          |    0
 drivers/video/{ =3D> fbdev}/nvidia/nv_local.h        |    0
 drivers/video/{ =3D> fbdev}/nvidia/nv_of.c           |    0
 drivers/video/{ =3D> fbdev}/nvidia/nv_proto.h        |    0
 drivers/video/{ =3D> fbdev}/nvidia/nv_setup.c        |    0
 drivers/video/{ =3D> fbdev}/nvidia/nv_type.h         |    0
 drivers/video/{ =3D> fbdev}/nvidia/nvidia.c          |    0
 drivers/video/{ =3D> fbdev}/ocfb.c                   |    0
 drivers/video/{ =3D> fbdev}/offb.c                   |    0
 drivers/video/{ =3D> fbdev}/omap/Kconfig             |    0
 drivers/video/{ =3D> fbdev}/omap/Makefile            |    0
 drivers/video/{ =3D> fbdev}/omap/hwa742.c            |    0
 drivers/video/{ =3D> fbdev}/omap/lcd_ams_delta.c     |    0
 drivers/video/{ =3D> fbdev}/omap/lcd_h3.c            |    0
 drivers/video/{ =3D> fbdev}/omap/lcd_htcherald.c     |    0
 drivers/video/{ =3D> fbdev}/omap/lcd_inn1510.c       |    0
 drivers/video/{ =3D> fbdev}/omap/lcd_inn1610.c       |    0
 drivers/video/{ =3D> fbdev}/omap/lcd_mipid.c         |    0
 drivers/video/{ =3D> fbdev}/omap/lcd_osk.c           |    0
 drivers/video/{ =3D> fbdev}/omap/lcd_palmte.c        |    0
 drivers/video/{ =3D> fbdev}/omap/lcd_palmtt.c        |    0
 drivers/video/{ =3D> fbdev}/omap/lcd_palmz71.c       |    0
 drivers/video/{ =3D> fbdev}/omap/lcdc.c              |    0
 drivers/video/{ =3D> fbdev}/omap/lcdc.h              |    0
 drivers/video/{ =3D> fbdev}/omap/omapfb.h            |    0
 drivers/video/{ =3D> fbdev}/omap/omapfb_main.c       |    0
 drivers/video/{ =3D> fbdev}/omap/sossi.c             |    0
 drivers/video/fbdev/omap2/Kconfig                  |   10 +
 drivers/video/{ =3D> fbdev}/omap2/Makefile           |    0
 .../video/{ =3D> fbdev}/omap2/displays-new/Kconfig   |    0
 .../video/{ =3D> fbdev}/omap2/displays-new/Makefile  |    0
 .../omap2/displays-new/connector-analog-tv.c       |    0
 .../{ =3D> fbdev}/omap2/displays-new/connector-dvi.c |    0
 .../omap2/displays-new/connector-hdmi.c            |    0
 .../omap2/displays-new/encoder-tfp410.c            |    0
 .../omap2/displays-new/encoder-tpd12s015.c         |    0
 .../{ =3D> fbdev}/omap2/displays-new/panel-dpi.c     |    0
 .../{ =3D> fbdev}/omap2/displays-new/panel-dsi-cm.c  |    0
 .../omap2/displays-new/panel-lgphilips-lb035q02.c  |    0
 .../omap2/displays-new/panel-nec-nl8048hl11.c      |    0
 .../omap2/displays-new/panel-sharp-ls037v7dw01.c   |    0
 .../omap2/displays-new/panel-sony-acx565akm.c      |    0
 .../omap2/displays-new/panel-tpo-td028ttec1.c      |    0
 .../omap2/displays-new/panel-tpo-td043mtea1.c      |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/Kconfig        |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/Makefile       |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/apply.c        |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/core.c         |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dispc-compat.c |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dispc-compat.h |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dispc.c        |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dispc.h        |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dispc_coefs.c  |    0
 .../video/{ =3D> fbdev}/omap2/dss/display-sysfs.c    |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/display.c      |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dpi.c          |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dsi.c          |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dss-of.c       |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dss.c          |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dss.h          |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dss_features.c |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/dss_features.h |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/hdmi.h         |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/hdmi4.c        |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/hdmi4_core.c   |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/hdmi4_core.h   |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/hdmi_common.c  |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/hdmi_phy.c     |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/hdmi_pll.c     |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/hdmi_wp.c      |    0
 .../video/{ =3D> fbdev}/omap2/dss/manager-sysfs.c    |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/manager.c      |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/output.c       |    0
 .../video/{ =3D> fbdev}/omap2/dss/overlay-sysfs.c    |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/overlay.c      |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/rfbi.c         |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/sdi.c          |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/venc.c         |    0
 drivers/video/{ =3D> fbdev}/omap2/dss/venc_panel.c   |    0
 drivers/video/{ =3D> fbdev}/omap2/omapfb/Kconfig     |    0
 drivers/video/{ =3D> fbdev}/omap2/omapfb/Makefile    |    0
 .../video/{ =3D> fbdev}/omap2/omapfb/omapfb-ioctl.c  |    0
 .../video/{ =3D> fbdev}/omap2/omapfb/omapfb-main.c   |    0
 .../video/{ =3D> fbdev}/omap2/omapfb/omapfb-sysfs.c  |    0
 drivers/video/{ =3D> fbdev}/omap2/omapfb/omapfb.h    |    0
 drivers/video/{ =3D> fbdev}/omap2/vrfb.c             |    0
 drivers/video/{ =3D> fbdev}/p9100.c                  |    0
 drivers/video/{ =3D> fbdev}/platinumfb.c             |    0
 drivers/video/{ =3D> fbdev}/platinumfb.h             |    0
 drivers/video/{ =3D> fbdev}/pm2fb.c                  |    0
 drivers/video/{ =3D> fbdev}/pm3fb.c                  |    0
 drivers/video/{ =3D> fbdev}/pmag-aa-fb.c             |    0
 drivers/video/{ =3D> fbdev}/pmag-ba-fb.c             |    0
 drivers/video/{ =3D> fbdev}/pmagb-b-fb.c             |    0
 drivers/video/{ =3D> fbdev}/ps3fb.c                  |    0
 drivers/video/{ =3D> fbdev}/pvr2fb.c                 |    0
 drivers/video/{ =3D> fbdev}/pxa168fb.c               |    0
 drivers/video/{ =3D> fbdev}/pxa168fb.h               |    0
 drivers/video/{ =3D> fbdev}/pxa3xx-gcu.c             |    0
 drivers/video/{ =3D> fbdev}/pxa3xx-gcu.h             |    0
 drivers/video/{ =3D> fbdev}/pxafb.c                  |    0
 drivers/video/{ =3D> fbdev}/pxafb.h                  |    0
 drivers/video/{ =3D> fbdev}/q40fb.c                  |    0
 drivers/video/{ =3D> fbdev}/riva/Makefile            |    0
 drivers/video/{ =3D> fbdev}/riva/fbdev.c             |    0
 drivers/video/{ =3D> fbdev}/riva/nv_driver.c         |    0
 drivers/video/{ =3D> fbdev}/riva/nv_type.h           |    0
 drivers/video/{ =3D> fbdev}/riva/nvreg.h             |    0
 drivers/video/{ =3D> fbdev}/riva/riva_hw.c           |    0
 drivers/video/{ =3D> fbdev}/riva/riva_hw.h           |    0
 drivers/video/{ =3D> fbdev}/riva/riva_tbl.h          |    0
 drivers/video/{ =3D> fbdev}/riva/rivafb-i2c.c        |    0
 drivers/video/{ =3D> fbdev}/riva/rivafb.h            |    0
 drivers/video/{ =3D> fbdev}/s1d13xxxfb.c             |    0
 drivers/video/{ =3D> fbdev}/s3c-fb.c                 |    0
 drivers/video/{ =3D> fbdev}/s3c2410fb.c              |    0
 drivers/video/{ =3D> fbdev}/s3c2410fb.h              |    0
 drivers/video/{ =3D> fbdev}/s3fb.c                   |    0
 drivers/video/{ =3D> fbdev}/sa1100fb.c               |    0
 drivers/video/{ =3D> fbdev}/sa1100fb.h               |    0
 drivers/video/{ =3D> fbdev}/savage/Makefile          |    0
 drivers/video/{ =3D> fbdev}/savage/savagefb-i2c.c    |    0
 drivers/video/{ =3D> fbdev}/savage/savagefb.h        |    0
 drivers/video/{ =3D> fbdev}/savage/savagefb_accel.c  |    0
 drivers/video/{ =3D> fbdev}/savage/savagefb_driver.c |    0
 drivers/video/{ =3D> fbdev}/sbuslib.c                |    0
 drivers/video/{ =3D> fbdev}/sbuslib.h                |    0
 drivers/video/{ =3D> fbdev}/sh7760fb.c               |    0
 drivers/video/{ =3D> fbdev}/sh_mipi_dsi.c            |    0
 drivers/video/{ =3D> fbdev}/sh_mobile_hdmi.c         |    0
 drivers/video/{ =3D> fbdev}/sh_mobile_lcdcfb.c       |    0
 drivers/video/{ =3D> fbdev}/sh_mobile_lcdcfb.h       |    0
 drivers/video/{ =3D> fbdev}/sh_mobile_meram.c        |    0
 drivers/video/{ =3D> fbdev}/simplefb.c               |    0
 drivers/video/{ =3D> fbdev}/sis/300vtbl.h            |    0
 drivers/video/{ =3D> fbdev}/sis/310vtbl.h            |    0
 drivers/video/{ =3D> fbdev}/sis/Makefile             |    0
 drivers/video/{ =3D> fbdev}/sis/init.c               |    0
 drivers/video/{ =3D> fbdev}/sis/init.h               |    0
 drivers/video/{ =3D> fbdev}/sis/init301.c            |    0
 drivers/video/{ =3D> fbdev}/sis/init301.h            |    0
 drivers/video/{ =3D> fbdev}/sis/initdef.h            |    0
 drivers/video/{ =3D> fbdev}/sis/initextlfb.c         |    0
 drivers/video/{ =3D> fbdev}/sis/oem300.h             |    0
 drivers/video/{ =3D> fbdev}/sis/oem310.h             |    0
 drivers/video/{ =3D> fbdev}/sis/sis.h                |    0
 drivers/video/{ =3D> fbdev}/sis/sis_accel.c          |    0
 drivers/video/{ =3D> fbdev}/sis/sis_accel.h          |    0
 drivers/video/{ =3D> fbdev}/sis/sis_main.c           |    0
 drivers/video/{ =3D> fbdev}/sis/sis_main.h           |    0
 drivers/video/{ =3D> fbdev}/sis/vgatypes.h           |    0
 drivers/video/{ =3D> fbdev}/sis/vstruct.h            |    0
 drivers/video/{ =3D> fbdev}/skeletonfb.c             |    0
 drivers/video/{ =3D> fbdev}/sm501fb.c                |    0
 drivers/video/{ =3D> fbdev}/smscufx.c                |    0
 drivers/video/{ =3D> fbdev}/ssd1307fb.c              |    0
 drivers/video/{ =3D> fbdev}/sstfb.c                  |    0
 drivers/video/{ =3D> fbdev}/sticore.h                |    0
 drivers/video/{ =3D> fbdev}/stifb.c                  |    0
 drivers/video/{ =3D> fbdev}/sunxvr1000.c             |    0
 drivers/video/{ =3D> fbdev}/sunxvr2500.c             |    0
 drivers/video/{ =3D> fbdev}/sunxvr500.c              |    0
 drivers/video/{ =3D> fbdev}/tcx.c                    |    0
 drivers/video/{ =3D> fbdev}/tdfxfb.c                 |    0
 drivers/video/{ =3D> fbdev}/tgafb.c                  |    0
 drivers/video/{ =3D> fbdev}/tmiofb.c                 |    0
 drivers/video/{ =3D> fbdev}/tridentfb.c              |    0
 drivers/video/{ =3D> fbdev}/udlfb.c                  |    0
 drivers/video/{ =3D> fbdev}/uvesafb.c                |    0
 drivers/video/{ =3D> fbdev}/valkyriefb.c             |    0
 drivers/video/{ =3D> fbdev}/valkyriefb.h             |    0
 drivers/video/{ =3D> fbdev}/vermilion/Makefile       |    0
 drivers/video/{ =3D> fbdev}/vermilion/cr_pll.c       |    0
 drivers/video/{ =3D> fbdev}/vermilion/vermilion.c    |    0
 drivers/video/{ =3D> fbdev}/vermilion/vermilion.h    |    0
 drivers/video/{ =3D> fbdev}/vesafb.c                 |    0
 drivers/video/{ =3D> fbdev}/vfb.c                    |    0
 drivers/video/{ =3D> fbdev}/vga16fb.c                |    0
 drivers/video/{ =3D> fbdev}/via/Makefile             |    0
 drivers/video/{ =3D> fbdev}/via/accel.c              |    0
 drivers/video/{ =3D> fbdev}/via/accel.h              |    0
 drivers/video/{ =3D> fbdev}/via/chip.h               |    0
 drivers/video/{ =3D> fbdev}/via/debug.h              |    0
 drivers/video/{ =3D> fbdev}/via/dvi.c                |    0
 drivers/video/{ =3D> fbdev}/via/dvi.h                |    0
 drivers/video/{ =3D> fbdev}/via/global.c             |    0
 drivers/video/{ =3D> fbdev}/via/global.h             |    0
 drivers/video/{ =3D> fbdev}/via/hw.c                 |    0
 drivers/video/{ =3D> fbdev}/via/hw.h                 |    0
 drivers/video/{ =3D> fbdev}/via/ioctl.c              |    0
 drivers/video/{ =3D> fbdev}/via/ioctl.h              |    0
 drivers/video/{ =3D> fbdev}/via/lcd.c                |    0
 drivers/video/{ =3D> fbdev}/via/lcd.h                |    0
 drivers/video/{ =3D> fbdev}/via/share.h              |    0
 drivers/video/{ =3D> fbdev}/via/tblDPASetting.c      |    0
 drivers/video/{ =3D> fbdev}/via/tblDPASetting.h      |    0
 drivers/video/{ =3D> fbdev}/via/via-core.c           |    0
 drivers/video/{ =3D> fbdev}/via/via-gpio.c           |    0
 drivers/video/{ =3D> fbdev}/via/via_aux.c            |    0
 drivers/video/{ =3D> fbdev}/via/via_aux.h            |    0
 drivers/video/{ =3D> fbdev}/via/via_aux_ch7301.c     |    0
 drivers/video/{ =3D> fbdev}/via/via_aux_edid.c       |    0
 drivers/video/{ =3D> fbdev}/via/via_aux_sii164.c     |    0
 drivers/video/{ =3D> fbdev}/via/via_aux_vt1621.c     |    0
 drivers/video/{ =3D> fbdev}/via/via_aux_vt1622.c     |    0
 drivers/video/{ =3D> fbdev}/via/via_aux_vt1625.c     |    0
 drivers/video/{ =3D> fbdev}/via/via_aux_vt1631.c     |    0
 drivers/video/{ =3D> fbdev}/via/via_aux_vt1632.c     |    0
 drivers/video/{ =3D> fbdev}/via/via_aux_vt1636.c     |    0
 drivers/video/{ =3D> fbdev}/via/via_clock.c          |    0
 drivers/video/{ =3D> fbdev}/via/via_clock.h          |    0
 drivers/video/{ =3D> fbdev}/via/via_i2c.c            |    0
 drivers/video/{ =3D> fbdev}/via/via_modesetting.c    |    0
 drivers/video/{ =3D> fbdev}/via/via_modesetting.h    |    0
 drivers/video/{ =3D> fbdev}/via/via_utility.c        |    0
 drivers/video/{ =3D> fbdev}/via/via_utility.h        |    0
 drivers/video/{ =3D> fbdev}/via/viafbdev.c           |    0
 drivers/video/{ =3D> fbdev}/via/viafbdev.h           |    0
 drivers/video/{ =3D> fbdev}/via/viamode.c            |    0
 drivers/video/{ =3D> fbdev}/via/viamode.h            |    0
 drivers/video/{ =3D> fbdev}/via/vt1636.c             |    0
 drivers/video/{ =3D> fbdev}/via/vt1636.h             |    0
 drivers/video/{ =3D> fbdev}/vt8500lcdfb.c            |    0
 drivers/video/{ =3D> fbdev}/vt8500lcdfb.h            |    0
 drivers/video/{ =3D> fbdev}/vt8623fb.c               |    0
 drivers/video/{ =3D> fbdev}/w100fb.c                 |    0
 drivers/video/{ =3D> fbdev}/w100fb.h                 |    0
 drivers/video/{ =3D> fbdev}/wm8505fb.c               |    0
 drivers/video/{ =3D> fbdev}/wm8505fb_regs.h          |    0
 drivers/video/{ =3D> fbdev}/wmt_ge_rops.c            |    2 +-
 drivers/video/{ =3D> fbdev}/wmt_ge_rops.h            |    0
 drivers/video/{ =3D> fbdev}/xen-fbfront.c            |    0
 drivers/video/{ =3D> fbdev}/xilinxfb.c               |    0
 drivers/video/omap2/Kconfig                        |   10 -
 482 files changed, 2682 insertions(+), 2666 deletions(-)
 rename drivers/video/{ =3D> fbdev}/68328fb.c (100%)
 create mode 100644 drivers/video/fbdev/Kconfig
 create mode 100644 drivers/video/fbdev/Makefile
 rename drivers/video/{ =3D> fbdev}/acornfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/acornfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/amba-clcd.c (100%)
 rename drivers/video/{ =3D> fbdev}/amifb.c (100%)
 rename drivers/video/{ =3D> fbdev}/arcfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/arkfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/asiliantfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/atafb.c (100%)
 rename drivers/video/{ =3D> fbdev}/atafb.h (100%)
 rename drivers/video/{ =3D> fbdev}/atafb_iplan2p2.c (100%)
 rename drivers/video/{ =3D> fbdev}/atafb_iplan2p4.c (100%)
 rename drivers/video/{ =3D> fbdev}/atafb_iplan2p8.c (100%)
 rename drivers/video/{ =3D> fbdev}/atafb_mfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/atafb_utils.h (100%)
 rename drivers/video/{ =3D> fbdev}/atmel_lcdfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/aty/ati_ids.h (100%)
 rename drivers/video/{ =3D> fbdev}/aty/aty128fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/atyfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/aty/atyfb_base.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/mach64_accel.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/mach64_ct.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/mach64_cursor.c (99%)
 rename drivers/video/{ =3D> fbdev}/aty/mach64_gx.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/radeon_accel.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/radeon_backlight.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/radeon_base.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/radeon_i2c.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/radeon_monitor.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/radeon_pm.c (100%)
 rename drivers/video/{ =3D> fbdev}/aty/radeonfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/au1100fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/au1100fb.h (100%)
 rename drivers/video/{ =3D> fbdev}/au1200fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/au1200fb.h (100%)
 rename drivers/video/{ =3D> fbdev}/auo_k1900fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/auo_k1901fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/auo_k190x.c (100%)
 rename drivers/video/{ =3D> fbdev}/auo_k190x.h (100%)
 rename drivers/video/{ =3D> fbdev}/bf537-lq035.c (100%)
 rename drivers/video/{ =3D> fbdev}/bf54x-lq043fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/bfin-lq035q1-fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/bfin-t350mcqb-fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/bfin_adv7393fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/bfin_adv7393fb.h (100%)
 rename drivers/video/{ =3D> fbdev}/broadsheetfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/bt431.h (100%)
 rename drivers/video/{ =3D> fbdev}/bt455.h (100%)
 rename drivers/video/{ =3D> fbdev}/bw2.c (100%)
 rename drivers/video/{ =3D> fbdev}/c2p.h (100%)
 rename drivers/video/{ =3D> fbdev}/c2p_core.h (100%)
 rename drivers/video/{ =3D> fbdev}/c2p_iplan2.c (100%)
 rename drivers/video/{ =3D> fbdev}/c2p_planar.c (100%)
 rename drivers/video/{ =3D> fbdev}/carminefb.c (100%)
 rename drivers/video/{ =3D> fbdev}/carminefb.h (100%)
 rename drivers/video/{ =3D> fbdev}/carminefb_regs.h (100%)
 rename drivers/video/{ =3D> fbdev}/cg14.c (100%)
 rename drivers/video/{ =3D> fbdev}/cg3.c (100%)
 rename drivers/video/{ =3D> fbdev}/cg6.c (100%)
 rename drivers/video/{ =3D> fbdev}/chipsfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/cirrusfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/clps711xfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/cobalt_lcdfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/controlfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/controlfb.h (100%)
 create mode 100644 drivers/video/fbdev/core/Makefile
 rename drivers/video/{ =3D> fbdev/core}/cfbcopyarea.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/cfbfillrect.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/cfbimgblt.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/fb_ddc.c (99%)
 rename drivers/video/{ =3D> fbdev/core}/fb_defio.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/fb_draw.h (100%)
 rename drivers/video/{ =3D> fbdev/core}/fb_notify.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/fb_sys_fops.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/fbcmap.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/fbcvt.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/fbmem.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/fbmon.c (99%)
 rename drivers/video/{ =3D> fbdev/core}/fbsysfs.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/modedb.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/svgalib.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/syscopyarea.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/sysfillrect.c (100%)
 rename drivers/video/{ =3D> fbdev/core}/sysimgblt.c (100%)
 rename drivers/video/{ =3D> fbdev}/cyber2000fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/cyber2000fb.h (100%)
 rename drivers/video/{ =3D> fbdev}/da8xx-fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/dnfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/edid.h (100%)
 rename drivers/video/{ =3D> fbdev}/efifb.c (100%)
 rename drivers/video/{ =3D> fbdev}/ep93xx-fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/exynos/Kconfig (100%)
 rename drivers/video/{ =3D> fbdev}/exynos/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/exynos/exynos_mipi_dsi.c (100%)
 rename drivers/video/{ =3D> fbdev}/exynos/exynos_mipi_dsi_common.c (100%=
)
 rename drivers/video/{ =3D> fbdev}/exynos/exynos_mipi_dsi_common.h (100%=
)
 rename drivers/video/{ =3D> fbdev}/exynos/exynos_mipi_dsi_lowlevel.c (10=
0%)
 rename drivers/video/{ =3D> fbdev}/exynos/exynos_mipi_dsi_lowlevel.h (10=
0%)
 rename drivers/video/{ =3D> fbdev}/exynos/exynos_mipi_dsi_regs.h (100%)
 rename drivers/video/{ =3D> fbdev}/exynos/s6e8ax0.c (100%)
 rename drivers/video/{ =3D> fbdev}/fb-puv3.c (100%)
 rename drivers/video/{ =3D> fbdev}/ffb.c (100%)
 rename drivers/video/{ =3D> fbdev}/fm2fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/fsl-diu-fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/g364fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/gbefb.c (100%)
 rename drivers/video/{ =3D> fbdev}/geode/Kconfig (100%)
 rename drivers/video/{ =3D> fbdev}/geode/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/geode/display_gx.c (100%)
 rename drivers/video/{ =3D> fbdev}/geode/display_gx1.c (100%)
 rename drivers/video/{ =3D> fbdev}/geode/display_gx1.h (100%)
 rename drivers/video/{ =3D> fbdev}/geode/geodefb.h (100%)
 rename drivers/video/{ =3D> fbdev}/geode/gx1fb_core.c (100%)
 rename drivers/video/{ =3D> fbdev}/geode/gxfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/geode/gxfb_core.c (100%)
 rename drivers/video/{ =3D> fbdev}/geode/lxfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/geode/lxfb_core.c (100%)
 rename drivers/video/{ =3D> fbdev}/geode/lxfb_ops.c (100%)
 rename drivers/video/{ =3D> fbdev}/geode/suspend_gx.c (100%)
 rename drivers/video/{ =3D> fbdev}/geode/video_cs5530.c (100%)
 rename drivers/video/{ =3D> fbdev}/geode/video_cs5530.h (100%)
 rename drivers/video/{ =3D> fbdev}/geode/video_gx.c (100%)
 rename drivers/video/{ =3D> fbdev}/goldfishfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/grvga.c (100%)
 rename drivers/video/{ =3D> fbdev}/gxt4500.c (100%)
 rename drivers/video/{ =3D> fbdev}/hecubafb.c (100%)
 rename drivers/video/{ =3D> fbdev}/hgafb.c (100%)
 rename drivers/video/{ =3D> fbdev}/hitfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/hpfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/hyperv_fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/i740_reg.h (100%)
 rename drivers/video/{ =3D> fbdev}/i740fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/i810/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/i810/i810-i2c.c (100%)
 rename drivers/video/{ =3D> fbdev}/i810/i810.h (100%)
 rename drivers/video/{ =3D> fbdev}/i810/i810_accel.c (100%)
 rename drivers/video/{ =3D> fbdev}/i810/i810_dvt.c (100%)
 rename drivers/video/{ =3D> fbdev}/i810/i810_gtf.c (100%)
 rename drivers/video/{ =3D> fbdev}/i810/i810_main.c (100%)
 rename drivers/video/{ =3D> fbdev}/i810/i810_main.h (100%)
 rename drivers/video/{ =3D> fbdev}/i810/i810_regs.h (100%)
 rename drivers/video/{ =3D> fbdev}/igafb.c (100%)
 rename drivers/video/{ =3D> fbdev}/imsttfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/imxfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/intelfb/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/intelfb/intelfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/intelfb/intelfb_i2c.c (100%)
 rename drivers/video/{ =3D> fbdev}/intelfb/intelfbdrv.c (100%)
 rename drivers/video/{ =3D> fbdev}/intelfb/intelfbhw.c (100%)
 rename drivers/video/{ =3D> fbdev}/intelfb/intelfbhw.h (100%)
 rename drivers/video/{ =3D> fbdev}/jz4740_fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/kyro/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/kyro/STG4000InitDevice.c (100%)
 rename drivers/video/{ =3D> fbdev}/kyro/STG4000Interface.h (100%)
 rename drivers/video/{ =3D> fbdev}/kyro/STG4000OverlayDevice.c (100%)
 rename drivers/video/{ =3D> fbdev}/kyro/STG4000Ramdac.c (100%)
 rename drivers/video/{ =3D> fbdev}/kyro/STG4000Reg.h (100%)
 rename drivers/video/{ =3D> fbdev}/kyro/STG4000VTG.c (100%)
 rename drivers/video/{ =3D> fbdev}/kyro/fbdev.c (100%)
 rename drivers/video/{ =3D> fbdev}/leo.c (100%)
 rename drivers/video/{ =3D> fbdev}/macfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/macmodes.c (100%)
 rename drivers/video/{ =3D> fbdev}/macmodes.h (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/g450_pll.c (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/g450_pll.h (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/i2c-matroxfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_DAC1064.c (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_DAC1064.h (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_Ti3026.c (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_Ti3026.h (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_accel.c (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_accel.h (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_base.c (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_base.h (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_crtc2.c (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_crtc2.h (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_g450.c (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_g450.h (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_maven.c (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_maven.h (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_misc.c (100%)
 rename drivers/video/{ =3D> fbdev}/matrox/matroxfb_misc.h (100%)
 rename drivers/video/{ =3D> fbdev}/maxinefb.c (100%)
 rename drivers/video/{ =3D> fbdev}/mb862xx/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/mb862xx/mb862xx-i2c.c (100%)
 rename drivers/video/{ =3D> fbdev}/mb862xx/mb862xx_reg.h (100%)
 rename drivers/video/{ =3D> fbdev}/mb862xx/mb862xxfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/mb862xx/mb862xxfb_accel.c (100%)
 rename drivers/video/{ =3D> fbdev}/mb862xx/mb862xxfb_accel.h (100%)
 rename drivers/video/{ =3D> fbdev}/mb862xx/mb862xxfbdrv.c (100%)
 rename drivers/video/{ =3D> fbdev}/mbx/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/mbx/mbxdebugfs.c (100%)
 rename drivers/video/{ =3D> fbdev}/mbx/mbxfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/mbx/reg_bits.h (100%)
 rename drivers/video/{ =3D> fbdev}/mbx/regs.h (100%)
 rename drivers/video/{ =3D> fbdev}/metronomefb.c (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/Kconfig (61%)
 rename drivers/video/{ =3D> fbdev}/mmp/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/core.c (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/fb/Kconfig (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/fb/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/fb/mmpfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/fb/mmpfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/hw/Kconfig (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/hw/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/hw/mmp_ctrl.c (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/hw/mmp_ctrl.h (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/hw/mmp_spi.c (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/panel/Kconfig (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/panel/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/mmp/panel/tpo_tj032md01bw.c (100%)
 rename drivers/video/{ =3D> fbdev}/msm/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mddi.c (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mddi_client_dummy.c (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mddi_client_nt35399.c (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mddi_client_toshiba.c (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mddi_hw.h (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mdp.c (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mdp_csc_table.h (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mdp_hw.h (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mdp_ppp.c (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mdp_scale_tables.c (100%)
 rename drivers/video/{ =3D> fbdev}/msm/mdp_scale_tables.h (100%)
 rename drivers/video/{ =3D> fbdev}/msm/msm_fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/mx3fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/mxsfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/n411.c (100%)
 rename drivers/video/{ =3D> fbdev}/neofb.c (100%)
 rename drivers/video/{ =3D> fbdev}/nuc900fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/nuc900fb.h (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nv_accel.c (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nv_backlight.c (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nv_dma.h (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nv_hw.c (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nv_i2c.c (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nv_local.h (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nv_of.c (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nv_proto.h (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nv_setup.c (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nv_type.h (100%)
 rename drivers/video/{ =3D> fbdev}/nvidia/nvidia.c (100%)
 rename drivers/video/{ =3D> fbdev}/ocfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/offb.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/Kconfig (100%)
 rename drivers/video/{ =3D> fbdev}/omap/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/omap/hwa742.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcd_ams_delta.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcd_h3.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcd_htcherald.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcd_inn1510.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcd_inn1610.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcd_mipid.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcd_osk.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcd_palmte.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcd_palmtt.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcd_palmz71.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcdc.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/lcdc.h (100%)
 rename drivers/video/{ =3D> fbdev}/omap/omapfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/omap/omapfb_main.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap/sossi.c (100%)
 create mode 100644 drivers/video/fbdev/omap2/Kconfig
 rename drivers/video/{ =3D> fbdev}/omap2/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/Kconfig (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/connector-analog-t=
v.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/connector-dvi.c (1=
00%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/connector-hdmi.c (=
100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/encoder-tfp410.c (=
100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/encoder-tpd12s015.=
c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/panel-dpi.c (100%)=

 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/panel-dsi-cm.c (10=
0%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/panel-lgphilips-lb=
035q02.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/panel-nec-nl8048hl=
11.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/panel-sharp-ls037v=
7dw01.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/panel-sony-acx565a=
km.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/panel-tpo-td028tte=
c1.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/displays-new/panel-tpo-td043mte=
a1.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/Kconfig (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/apply.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/core.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dispc-compat.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dispc-compat.h (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dispc.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dispc.h (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dispc_coefs.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/display-sysfs.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/display.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dpi.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dsi.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dss-of.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dss.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dss.h (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dss_features.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/dss_features.h (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/hdmi.h (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/hdmi4.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/hdmi4_core.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/hdmi4_core.h (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/hdmi_common.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/hdmi_phy.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/hdmi_pll.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/hdmi_wp.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/manager-sysfs.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/manager.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/output.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/overlay-sysfs.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/overlay.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/rfbi.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/sdi.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/venc.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/dss/venc_panel.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/omapfb/Kconfig (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/omapfb/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/omapfb/omapfb-ioctl.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/omapfb/omapfb-main.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/omapfb/omapfb-sysfs.c (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/omapfb/omapfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/omap2/vrfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/p9100.c (100%)
 rename drivers/video/{ =3D> fbdev}/platinumfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/platinumfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/pm2fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/pm3fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/pmag-aa-fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/pmag-ba-fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/pmagb-b-fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/ps3fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/pvr2fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/pxa168fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/pxa168fb.h (100%)
 rename drivers/video/{ =3D> fbdev}/pxa3xx-gcu.c (100%)
 rename drivers/video/{ =3D> fbdev}/pxa3xx-gcu.h (100%)
 rename drivers/video/{ =3D> fbdev}/pxafb.c (100%)
 rename drivers/video/{ =3D> fbdev}/pxafb.h (100%)
 rename drivers/video/{ =3D> fbdev}/q40fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/riva/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/riva/fbdev.c (100%)
 rename drivers/video/{ =3D> fbdev}/riva/nv_driver.c (100%)
 rename drivers/video/{ =3D> fbdev}/riva/nv_type.h (100%)
 rename drivers/video/{ =3D> fbdev}/riva/nvreg.h (100%)
 rename drivers/video/{ =3D> fbdev}/riva/riva_hw.c (100%)
 rename drivers/video/{ =3D> fbdev}/riva/riva_hw.h (100%)
 rename drivers/video/{ =3D> fbdev}/riva/riva_tbl.h (100%)
 rename drivers/video/{ =3D> fbdev}/riva/rivafb-i2c.c (100%)
 rename drivers/video/{ =3D> fbdev}/riva/rivafb.h (100%)
 rename drivers/video/{ =3D> fbdev}/s1d13xxxfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/s3c-fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/s3c2410fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/s3c2410fb.h (100%)
 rename drivers/video/{ =3D> fbdev}/s3fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/sa1100fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/sa1100fb.h (100%)
 rename drivers/video/{ =3D> fbdev}/savage/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/savage/savagefb-i2c.c (100%)
 rename drivers/video/{ =3D> fbdev}/savage/savagefb.h (100%)
 rename drivers/video/{ =3D> fbdev}/savage/savagefb_accel.c (100%)
 rename drivers/video/{ =3D> fbdev}/savage/savagefb_driver.c (100%)
 rename drivers/video/{ =3D> fbdev}/sbuslib.c (100%)
 rename drivers/video/{ =3D> fbdev}/sbuslib.h (100%)
 rename drivers/video/{ =3D> fbdev}/sh7760fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/sh_mipi_dsi.c (100%)
 rename drivers/video/{ =3D> fbdev}/sh_mobile_hdmi.c (100%)
 rename drivers/video/{ =3D> fbdev}/sh_mobile_lcdcfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/sh_mobile_lcdcfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/sh_mobile_meram.c (100%)
 rename drivers/video/{ =3D> fbdev}/simplefb.c (100%)
 rename drivers/video/{ =3D> fbdev}/sis/300vtbl.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/310vtbl.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/sis/init.c (100%)
 rename drivers/video/{ =3D> fbdev}/sis/init.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/init301.c (100%)
 rename drivers/video/{ =3D> fbdev}/sis/init301.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/initdef.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/initextlfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/sis/oem300.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/oem310.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/sis.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/sis_accel.c (100%)
 rename drivers/video/{ =3D> fbdev}/sis/sis_accel.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/sis_main.c (100%)
 rename drivers/video/{ =3D> fbdev}/sis/sis_main.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/vgatypes.h (100%)
 rename drivers/video/{ =3D> fbdev}/sis/vstruct.h (100%)
 rename drivers/video/{ =3D> fbdev}/skeletonfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/sm501fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/smscufx.c (100%)
 rename drivers/video/{ =3D> fbdev}/ssd1307fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/sstfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/sticore.h (100%)
 rename drivers/video/{ =3D> fbdev}/stifb.c (100%)
 rename drivers/video/{ =3D> fbdev}/sunxvr1000.c (100%)
 rename drivers/video/{ =3D> fbdev}/sunxvr2500.c (100%)
 rename drivers/video/{ =3D> fbdev}/sunxvr500.c (100%)
 rename drivers/video/{ =3D> fbdev}/tcx.c (100%)
 rename drivers/video/{ =3D> fbdev}/tdfxfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/tgafb.c (100%)
 rename drivers/video/{ =3D> fbdev}/tmiofb.c (100%)
 rename drivers/video/{ =3D> fbdev}/tridentfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/udlfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/uvesafb.c (100%)
 rename drivers/video/{ =3D> fbdev}/valkyriefb.c (100%)
 rename drivers/video/{ =3D> fbdev}/valkyriefb.h (100%)
 rename drivers/video/{ =3D> fbdev}/vermilion/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/vermilion/cr_pll.c (100%)
 rename drivers/video/{ =3D> fbdev}/vermilion/vermilion.c (100%)
 rename drivers/video/{ =3D> fbdev}/vermilion/vermilion.h (100%)
 rename drivers/video/{ =3D> fbdev}/vesafb.c (100%)
 rename drivers/video/{ =3D> fbdev}/vfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/vga16fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/Makefile (100%)
 rename drivers/video/{ =3D> fbdev}/via/accel.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/accel.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/chip.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/debug.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/dvi.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/dvi.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/global.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/global.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/hw.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/hw.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/ioctl.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/ioctl.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/lcd.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/lcd.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/share.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/tblDPASetting.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/tblDPASetting.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/via-core.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via-gpio.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux_ch7301.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux_edid.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux_sii164.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux_vt1621.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux_vt1622.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux_vt1625.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux_vt1631.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux_vt1632.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_aux_vt1636.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_clock.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_clock.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_i2c.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_modesetting.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_modesetting.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_utility.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/via_utility.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/viafbdev.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/viafbdev.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/viamode.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/viamode.h (100%)
 rename drivers/video/{ =3D> fbdev}/via/vt1636.c (100%)
 rename drivers/video/{ =3D> fbdev}/via/vt1636.h (100%)
 rename drivers/video/{ =3D> fbdev}/vt8500lcdfb.c (100%)
 rename drivers/video/{ =3D> fbdev}/vt8500lcdfb.h (100%)
 rename drivers/video/{ =3D> fbdev}/vt8623fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/w100fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/w100fb.h (100%)
 rename drivers/video/{ =3D> fbdev}/wm8505fb.c (100%)
 rename drivers/video/{ =3D> fbdev}/wm8505fb_regs.h (100%)
 rename drivers/video/{ =3D> fbdev}/wmt_ge_rops.c (99%)
 rename drivers/video/{ =3D> fbdev}/wmt_ge_rops.h (100%)
 rename drivers/video/{ =3D> fbdev}/xen-fbfront.c (100%)
 rename drivers/video/{ =3D> fbdev}/xilinxfb.c (100%)
 delete mode 100644 drivers/video/omap2/Kconfig


--BMIKUXPwW1nXiwkGsKxrXCgnechgt27iF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTT34IAAoJEPo9qoy8lh71NUUP/RRubGeibRilVXCP6K96rBq9
7aHWL5rSCPRX2v6q4JTXxZR/RDbqPT79hFIwCtRxUu8batgc7XkfPOfrW0TqnbBU
2aKGmtySCia27Lk/A/LmeOEhAi1gsGGU/OBUUT2/yxUdvlHpjlf4hL3bKcyzDFg1
Cz9ruLE6JT+1TFZT8iqaWJNc9DhBfDx0r6yRvT9Ux5xoPmJt+JjS/RlRJDMwaSuf
MUDKEGW+Gv1lSbPxnyJ+61I7JWLAiPbgZDAtloAx+trhlAmBmpQSEtRr24qxJsrc
ocHN6W29mzlf6WhhlCf7CmX/jUAgj3Gv/BMqn9FZV5/SG7js/l7P+n1TEGqY6ltt
WFGxK0kMLWt2sTxCXMdA6K9Jn6bKdT14NyAb8HX0ruAIXBYqBW7XmkXAqlcv4XlT
P2N8pe2GxpXdgdQGcREt0Q/PumNtB8doT6FC1SgiND+UmlwfkhYdDzsH8DSZLVsQ
yPtUtSDtzEfqVVjPJ7nuUfunck8QAFLf0HXvSDk+shc7TkzJMaSzkRJQ4OGdAlKP
GX3gvxaR9tF3SDqIOp4rT9ALNfUBPWqLx+4p/mZ67lH5vOJiMNX3iwu2KvvwMA59
3FZtjMowDqSOeGYPT9r718fkOjPKsTJTdKCCjHSpdoZs18t9Be9nf3rOtmr2U9OI
d3XJEiMw+UyAPGpQwMFD
=z77p
-----END PGP SIGNATURE-----

--BMIKUXPwW1nXiwkGsKxrXCgnechgt27iF--
