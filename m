Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbaDPJD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:03:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58210 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaDPJDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:03:53 -0400
Message-ID: <534E4775.8010009@ti.com>
Date: Wed, 16 Apr 2014 12:03:49 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.15
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iniACn6ADpBHQPdGm7D3FdbwW9oJGGPEu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iniACn6ADpBHQPdGm7D3FdbwW9oJGGPEu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull fbdev fixes for 3.15.

The drivers/video/Kconfig change in this pull request will conflict with =
the
fbdev reorder series, which is not yet in your tree. If that's an issue, =
I can
resend this without the Kconfig change.

 Tomi

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6=
c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-fixes-3.15

for you to fetch changes up to c26ef3eb3c11274bad1b64498d0a134f85755250:

  video: bf54x-lq043fb: fix build error (2014-04-15 12:44:16 +0300)

----------------------------------------------------------------
fbdev fixes for 3.15:

- fix build errors for bf54x-lq043fb and imxfb
- fbcon fix for da8xx-fb
- omapdss fixes for hdmi audio, irq handling and fclk calculation

----------------------------------------------------------------
Alexander Shiyan (1):
      video: imxfb: Select LCD_CLASS_DEVICE unconditionally

Jon Ringle (1):
      video: da8xx-fb: Fix casting of info->pseudo_palette

Jyri Sarha (2):
      OMAPDSS: Take pixelclock unit change into account in hdmi_compute_a=
cr()
      OMAPDSS: Change struct reg_field to dispc_reg_field

Steven Miao (1):
      video: bf54x-lq043fb: fix build error

Tomi Valkeinen (2):
      OMAPDSS: fix rounding when calculating fclk rate
      OMAPDSS: fix shared irq handlers

 drivers/video/Kconfig                 |  2 ++
 drivers/video/bf54x-lq043fb.c         |  2 +-
 drivers/video/da8xx-fb.c              | 10 +-----
 drivers/video/omap2/dss/dispc.c       | 67 +++++++++++++++++++++++++++++=
------
 drivers/video/omap2/dss/dsi.c         | 20 +++++++++++
 drivers/video/omap2/dss/dss.c         |  4 +--
 drivers/video/omap2/dss/dss.h         |  6 ----
 drivers/video/omap2/dss/hdmi_common.c |  8 ++---
 8 files changed, 87 insertions(+), 32 deletions(-)


--iniACn6ADpBHQPdGm7D3FdbwW9oJGGPEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTTkd1AAoJEPo9qoy8lh71tt0P/17jSYCuTlJbi2EMAskUKGAR
rbJjNGSH1/d40wC9vIAIy4xb2BbUSAIL0HDdcSy8K+G27gGUWszMAII5yItt074o
dUEtCdD7AuZxCYA83W65N7d2Yl+vq/7xFHhY47tauAbvzpZQMSy4UI6AGebWiK5G
StZDd6wSNEGrt4IDawTctr3ZI/4eCLk8j9FgTstkIYCNinkAB33oGOLs1Rya5mx7
d+0MIOkhdjrFTFSt4XHRRyhDoeDNpX97qDz2dpzSgduHzTRromJA4o2O4SnNwcbh
0Adxz+Fkpj9Gty/BNghd/XNimqWc3nU70apvJoexriIESaJuk3wqHhxLqYzov2xn
yzhjoSogB8sP/ymnVZndnI5gLPSw+KSwUlppgG3ap6Hg7foBNqKAObLrNCz+4AHe
qMR2WU2+wKhFsyQTUz5JrT0DDfyx8yC4oYZAgVoAfRY9FEUYl9am/kaenzcwOmvS
JwZPHbEPbS7otqZf53E/LRq90EExtPl387Bs7oT8WpX6yp9G/nbmY4m8MZnhE3Qo
NTeMchiM+t1KdLKvXd4fda8M6M20mQepIWCXz60FVvs0bh89LQP7Jc2vAOJ/NSIo
H9rQ2+YTIV4QzjAPnfIBG1sq7H1vtxbvwl2hB3bn1hoa7EGOaHmO6bg1jwmjxdM2
wlviSCX9cW6ryGVH/9dD
=69In
-----END PGP SIGNATURE-----

--iniACn6ADpBHQPdGm7D3FdbwW9oJGGPEu--
