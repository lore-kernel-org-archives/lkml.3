Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbaJ3NUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:20:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55357 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013AbaJ3NUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:20:15 -0400
Message-ID: <54523B0B.8010003@ti.com>
Date: Thu, 30 Oct 2014 15:20:11 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.18
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="4CBQKDreR6C7sBvXt7OEsmCJ5fRkHj6e4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4CBQKDreR6C7sBvXt7OEsmCJ5fRkHj6e4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull fbdev fixes for 3.18.

 Tomi

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355=
e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-fixes-3.18

for you to fetch changes up to a942535d6e5c23f0015d6674d28c91dd59a720e4:

  Merge branch '3.18/omapdss-fixes' into 3.18/fbdev-fixes (2014-10-30 14:=
53:49 +0200)

----------------------------------------------------------------
fbdev fixes for 3.18

* Fix fb console option parsing
* Fixes for OMAPDSS/OMAPFB crashes related to module unloading and
  device/driver binding & unbinding.
* Fix for OMAP HDMI PLL locking failing in certain cases
* Misc minor fixes for atmel lcdfb and OMAP

----------------------------------------------------------------
Alexandre Belloni (1):
      drivers: video: fbdev: atmel_lcdfb.c: remove unnecessary header

Felipe Balbi (2):
      OMAPFB: add missing MODULE_ALIAS()
      OMAPFB: remove __exit annotation

Maarten ter Huurne (1):
      fbcon: Fix option parsing control flow in fb_console_setup

Marek Belisko (1):
      omap: dss: connector-analog-tv: Add missing module device table

Mark Rustad (1):
      video/console: Resolve several shadow warnings

Tomi Valkeinen (10):
      OMAPDSS: set suppress_bind_attrs
      OMAPDSS: apply: wait pending updates on manager disable
      OMAPFB: fix overlay disable when freeing resources.
      OMAPFB: fix releasing overlays
      OMAPDSS: HDMI: fix PLL GO bit handling
      OMAPDSS: HDMI: fix regsd write
      OMAPDSS: DISPC: fix mflag offset
      OMAPDSS: fix dispc register dump for preload & mflag
      OMAPDSS: DSI: Fix PLL_SELFEQDCO field width
      Merge branch '3.18/omapdss-fixes' into 3.18/fbdev-fixes

 drivers/video/console/fbcon.c                      | 19 ++++++++--------=
-
 drivers/video/console/vgacon.c                     | 24 +++++++++++-----=
------
 drivers/video/fbdev/atmel_lcdfb.c                  |  1 -
 .../fbdev/omap2/displays-new/connector-analog-tv.c |  3 +++
 .../video/fbdev/omap2/displays-new/connector-dvi.c |  1 +
 .../fbdev/omap2/displays-new/connector-hdmi.c      |  1 +
 .../fbdev/omap2/displays-new/encoder-tfp410.c      |  1 +
 .../fbdev/omap2/displays-new/encoder-tpd12s015.c   |  1 +
 drivers/video/fbdev/omap2/displays-new/panel-dpi.c |  1 +
 .../video/fbdev/omap2/displays-new/panel-dsi-cm.c  |  1 +
 .../omap2/displays-new/panel-lgphilips-lb035q02.c  |  1 +
 .../omap2/displays-new/panel-nec-nl8048hl11.c      |  1 +
 .../omap2/displays-new/panel-sharp-ls037v7dw01.c   |  1 +
 .../omap2/displays-new/panel-sony-acx565akm.c      |  1 +
 .../omap2/displays-new/panel-tpo-td028ttec1.c      |  1 +
 .../omap2/displays-new/panel-tpo-td043mtea1.c      |  1 +
 drivers/video/fbdev/omap2/dss/apply.c              |  2 ++
 drivers/video/fbdev/omap2/dss/dispc.c              |  8 ++++----
 drivers/video/fbdev/omap2/dss/dispc.h              |  3 +--
 drivers/video/fbdev/omap2/dss/dpi.c                |  1 +
 drivers/video/fbdev/omap2/dss/dsi.c                |  3 ++-
 drivers/video/fbdev/omap2/dss/dss.c                |  1 +
 drivers/video/fbdev/omap2/dss/hdmi4.c              |  1 +
 drivers/video/fbdev/omap2/dss/hdmi5.c              |  1 +
 drivers/video/fbdev/omap2/dss/hdmi_pll.c           | 13 ++++++------
 drivers/video/fbdev/omap2/dss/rfbi.c               |  1 +
 drivers/video/fbdev/omap2/dss/sdi.c                |  1 +
 drivers/video/fbdev/omap2/dss/venc.c               |  1 +
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c     | 18 ++++++++--------=

 29 files changed, 67 insertions(+), 46 deletions(-)


--4CBQKDreR6C7sBvXt7OEsmCJ5fRkHj6e4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUjsLAAoJEPo9qoy8lh71gOwQAIjG4xI2BiAyOcK6QVc9fftX
1ya7qr7m6Z2nBmmUdBxPfb2EXxYA+47SO4gJivwJMAQHr8nQfiapJ73MqHQheh++
yaIqwAAypztiYaH9QF7hnx8DyFzcWnwi82c34jnYXbWDAkqLVvWUEDEAE3ya1udn
eQE0IMyfHQ/u1baQWEp5ps6q5gHci+ysI/JUTYTddoPfOqzzLADkkocYqxZRcZ1V
2DZ+splqErMwAflcCL7Dy27n9OJx+LjfM/h3n4HIBPw7K3ujfimnOZfl1HzhmLtU
szhIk8JvqNh5suGBaH4SeWLsPWAGOTuS42hlZUCCObRjYmOh4uJmL39bWB9KtLKC
Cs8LXInik+/0aHctblqXNt89z07juWkiDUdB8oe9oY0VZ6/GHh3k1ndWOXNDyEzR
TlKxOq1NuX/cVHiQykBhdOetoETxOo5IuB9z7LfoGKXnoC1id1hyWOlC8Z7CIHiB
rYu6z/bzUq3csLD21d3nSVeV5CClRHJpFGqn4w3bS6dBrI5scQKqOjJlJgo71Y+R
2eFWTdfAsadODt0YISt0uc6IG4rMIOSYMtRB0bedKsF/h2OFZvJQ0n1TWaBlo49t
ACmuGdYk4H9LvxBURCxKCFqV/hAcZVAwWj3/2gWHzNpb0z8WlYPWUKh1+U5lOmMQ
DxdaDHT6dBSnoo6IstlJ
=oTki
-----END PGP SIGNATURE-----

--4CBQKDreR6C7sBvXt7OEsmCJ5fRkHj6e4--
