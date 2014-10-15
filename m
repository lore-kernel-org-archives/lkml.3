Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaJOLXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:23:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58008 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaJOLXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:23:06 -0400
Message-ID: <543E5916.1020900@ti.com>
Date: Wed, 15 Oct 2014 14:23:02 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev changes for 3.18
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="GOBVxWPWDwmJ4jwfuAhOJMQmWfsj6eUOG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GOBVxWPWDwmJ4jwfuAhOJMQmWfsj6eUOG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the fbdev changes for 3.18.

 Tomi

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980c=
ef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-3.18

for you to fetch changes up to 33ac9dba859b07d40e9ec826057d20c857fdede5:

  fonts: Add 6x10 font (2014-10-09 11:35:48 +0300)

----------------------------------------------------------------
fbdev changes for 3.18

* new 6x10 font
* various small fixes and cleanups

----------------------------------------------------------------
Alexander Stein (1):
      video/atmel_lcdfb: Introduce regulator support

Andy Shevchenko (1):
      video: fbdev: use %*ph specifier to dump small buffers

Arnd Bergmann (1):
      video: mx3fb: always enable BACKLIGHT_LCD_SUPPORT

Behan Webster (2):
      arm, fbdev, omap2, LLVMLinux: Remove nested function from omap2 dss=

      arm, fbdev, omap2, LLVMLinux: Remove nested function from omapfb

Fabian Frederick (7):
      video: vermilion: remove unnecessary break after goto
      video: fbdev: stifb.c: use container_of to resolve stifb_info from =
fb_info
      video: fbdev: sa1100fb.c: use container_of to resolve sa1100fb_info=
 from fb_info
      video: fbdev: controlfb.c: use container_of to resolve fb_info_cont=
rol from fb_info
      video: fbdev: cyber2000fb.c: use container_of to resolve cfb_info f=
rom fb_info
      video: fbdev: pxafb.c: use container_of to resolve pxafb_info/layer=
 from fb_info
      video: fbdev: valkyriefb.c: use container_of to resolve fb_info_val=
kyrie from fb_info

Geert Uytterhoeven (3):
      video: mx3fb: Update comment for dmaengine_prep_slave_sg() API
      video: valkyriefb: Fix unused variable warning in set_valkyrie_cloc=
k()
      fbdev: sh_mobile_hdmi: Re-init regs before irq re-enable on resume

Julia Lawall (8):
      video: of: display_timing: delete unneeded test before of_node_put
      video: fbdev: matrox: use c99 initializers in structures
      OMAPDSS: DSI: use c99 initializers in structures
      video: fbdev: aty: use c99 initializers in structures
      video: fbdev: riva: delete double assignment
      video: fbdev: intelfb: delete double assignment
      video: fbdev: sis: delete double assignment
      video: fbdev: au1200fb: delete double assignment

Maarten ter Huurne (1):
      fonts: Add 6x10 font

Mikulas Patocka (2):
      framebuffer: fix border color
      framebuffer: fix screen corruption when copying

Pramod Gurav (2):
      msm: msm_fb: Add remove function for platform driver for clean unlo=
ading
      msm: msm_fb: Move to using managed resources of kzalloc

Rickard Strandqvist (1):
      video: fbdev: sis: sis_main.c: Cleaning up missing null-terminate i=
n conjunction with strncpy

Tomi Valkeinen (1):
      videomode: provide dummy inline functions for !CONFIG_OF

 .../devicetree/bindings/video/atmel,lcdc.txt       |    3 +
 drivers/video/console/bitblit.c                    |    3 +-
 drivers/video/console/fbcon_ccw.c                  |    3 +-
 drivers/video/console/fbcon_cw.c                   |    3 +-
 drivers/video/console/fbcon_ud.c                   |    3 +-
 drivers/video/fbdev/Kconfig                        |    3 +-
 drivers/video/fbdev/atmel_lcdfb.c                  |   20 +
 drivers/video/fbdev/aty/aty128fb.c                 |   63 +-
 drivers/video/fbdev/au1200fb.c                     |    1 -
 drivers/video/fbdev/controlfb.c                    |   15 +-
 drivers/video/fbdev/core/cfbcopyarea.c             |   13 +-
 drivers/video/fbdev/core/fbsysfs.c                 |   12 +-
 drivers/video/fbdev/cyber2000fb.c                  |   16 +-
 drivers/video/fbdev/intelfb/intelfbhw.c            |    3 +-
 drivers/video/fbdev/matrox/matroxfb_base.c         |   52 +-
 drivers/video/fbdev/matrox/matroxfb_maven.c        |   20 +-
 drivers/video/fbdev/msm/msm_fb.c                   |   25 +-
 drivers/video/fbdev/mx3fb.c                        |    2 +-
 drivers/video/fbdev/omap2/dss/dispc-compat.c       |    9 +-
 drivers/video/fbdev/omap2/dss/dsi.c                |   10 +-
 drivers/video/fbdev/omap2/dss/manager-sysfs.c      |   16 +-
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c     |   14 +-
 drivers/video/fbdev/pxafb.c                        |   20 +-
 drivers/video/fbdev/riva/riva_hw.c                 |    1 -
 drivers/video/fbdev/sa1100fb.c                     |   18 +-
 drivers/video/fbdev/sh_mobile_hdmi.c               |   44 +-
 drivers/video/fbdev/sis/init301.c                  |    2 +-
 drivers/video/fbdev/sis/sis_main.c                 |    2 +-
 drivers/video/fbdev/stifb.c                        |    4 +-
 drivers/video/fbdev/udlfb.c                        |    7 +-
 drivers/video/fbdev/valkyriefb.c                   |   14 +-
 drivers/video/fbdev/vermilion/vermilion.c          |    1 -
 drivers/video/of_display_timing.c                  |    3 +-
 include/linux/font.h                               |    4 +-
 include/video/of_display_timing.h                  |   16 +
 lib/fonts/Kconfig                                  |    9 +
 lib/fonts/Makefile                                 |    1 +
 lib/fonts/font_6x10.c                              | 3086 ++++++++++++++=
++++++
 lib/fonts/fonts.c                                  |    4 +
 39 files changed, 3421 insertions(+), 124 deletions(-)
 create mode 100644 lib/fonts/font_6x10.c


--GOBVxWPWDwmJ4jwfuAhOJMQmWfsj6eUOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPlkWAAoJEPo9qoy8lh71akgQAIU76RH1qn1HJ4lZPwjhv65X
0syk91Zielb6F2T0vtTG4AKbESQq/R3DAnodwpd9fTEFQKr2BTosMoS7B2GiVjVn
zLiE2YEVWyhqjrn3SzUsGqC/m44DWyW84N6JbqGInytscSkxr2ipCJAaDyiro01A
JrqP6hbzSrrQg7/mTnAijfC1fx/mu5kYZNrVUsUZk5wXoPGkxKIk8WSRcvJxHy27
osNUR2qv0v5N7ALuRXg7jNK+Q9zCVLHO4Q+BFYuboV6O7Prxmrz5vnCBhMmQ//nT
nAt6z385cVT2dW/2BbsMXOF2cYCKiD365Jj6Hs+60+MTPuFt1IcE8MtEh8xb1rUI
xzvRFZdWNuOSWs1HaLzYF2DRwKs2jEtFxIXSVCayH8cuyPOPMevgp29sIF1OnOEd
6jSKw8LgmmksFcbFljzXoC0vlHeRTaxJ8RWBdLv0/a52jtw0PC4QANUXsYyoLNeJ
jKQUva1laIWgPGZlavEoDJPGId+WRJZgOj00bdbpA/fDOqeOWX0NEgxhdTj4a0RA
aPcJIGf0RL1jnGlB3sHgVhke493oopQp3WtUkuuZBiMw05NhzcGqYgLGAY7k4fdE
aJfXqxumZoykePTTc0JuikncQfyeA5RnoXp74e5akjDFu4BRRXPQ42Xui39HQ933
bcZ1s8X+7o1Xw3Fo+OQG
=WZE5
-----END PGP SIGNATURE-----

--GOBVxWPWDwmJ4jwfuAhOJMQmWfsj6eUOG--
