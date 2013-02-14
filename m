Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931Ab3BNR10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:27:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39006 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194Ab3BNR1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:27:24 -0500
Message-ID: <511D1E79.8030909@ti.com>
Date: Thu, 14 Feb 2013 19:27:21 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] omapdss fixes for 3.8
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigBE1A649C6F70936B4C3DEA1B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigBE1A649C6F70936B4C3DEA1B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

It'd be great if these two late fixes would still make it into 3.8. The o=
ther
one fixes ARM kernel compilation when using 'allyesconfig', and the other=
 makes
DPI displays function again on OMAP3630 boards.

 Tomi

The following changes since commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c=
39:

  Linux 3.8-rc7 (2013-02-09 08:20:39 +1100)

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git tags/omapdss-for-3.8-rc8

for you to fetch changes up to 91e83ffd6d3ba4de21202b4f541777a7a8db02c8:

  omapdrm: fix the dependency to omapdss (2013-02-14 13:08:29 +0200)

----------------------------------------------------------------
* Fix ARM compilation with "allyesconfig" (omapdrm: fix the dependency to=

  omapdss)

* fix DPI displays on OMAP3630 (OMAPDSS: add FEAT_DPI_USES_VDDS_DSI to
  omap3630_dss_feat_list)

----------------------------------------------------------------
NeilBrown (1):
      OMAPDSS: add FEAT_DPI_USES_VDDS_DSI to omap3630_dss_feat_list

Tomi Valkeinen (1):
      omapdrm: fix the dependency to omapdss

 drivers/staging/omapdrm/Kconfig        |    2 +-
 drivers/video/omap2/dss/dss_features.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


--------------enigBE1A649C6F70936B4C3DEA1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRHR55AAoJEPo9qoy8lh71RPwQAIwCZiZ4zXzZSg55Nf+umd2f
ZQAwTROXos0fqf/cYsiCAu+/lXnNlpToTJTUpxb57cZtS8xKugg7g/1zd/9sN9h7
SjEOiVL/Qi6MqBI7PCPFDWcc8D2OQlkp23r0IFfnimBbub55fdbtOwk3m4JDY8p7
Ha+AuZmucphgncemrGRBcW2W9jw4HxXYc38J/BOFdBM8m3R5plpOu1P/A3d6pmhl
FxL9Ypu6BZI5s75qBmN0SjcaMNuz7iHruqeSkVU6pU4wb5PLMt5xHRtqI082bPXQ
0GoseBYvQptL+XcEQXriKnEKHg2KJBNpLoia0nw6nAr61iBiCBNjTY3ApF7PeZ4Y
TY6LD96QQVwyeMAfArFQLXTQNeBEAOxtiJgFIp319N9JwfP/1d0usIgC+CQQM3Em
bD4raYVu6o5tzJonti0Fx6uMLuqvoBkY+599aTlCkG5ZqVHikHqzKKk2cWHcD46u
ZK55lYyIwI7RDC3pEJ4yA1vUfBMesw3CBsx/QLsy3lhDaBUAuI87TQl0lVRhLhSd
Q16xSIkCOI3Egr8dRrbKDv2UD5zNcawrcN+Uj9IvaWevn26O1aBznVHSuSPSC5HR
wvqGY7y01JrVTwfhBBm8OUdczWoFBI6tHpSSOEK5xHrYJH2nk41/kcBHgLgmz8Ad
QJkVIMrbMiu1fUGUtY+5
=Wzsp
-----END PGP SIGNATURE-----

--------------enigBE1A649C6F70936B4C3DEA1B--
