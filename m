Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaL3LpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 06:45:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50038 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbaL3Lo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 06:44:59 -0500
Message-ID: <54A29036.4020507@ti.com>
Date: Tue, 30 Dec 2014 13:44:54 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.19
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="qhuBLOxK9COm3Rf8d6G3PrWF9Mv6hUmHK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qhuBLOxK9COm3Rf8d6G3PrWF9Mv6hUmHK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48=
d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-fixes-3.19

for you to fetch changes up to a32442d4f8b712b701ea577c841d6a0a7c5993c1:

  OMAPDSS: SDI: fix output port_num (2014-12-30 11:18:30 +0200)

----------------------------------------------------------------
fbdev fixes for 3.19

* Fix regression with Nokia N900 display
* Fix crash on fbdev using freed __initdata logos
* Fix fb_deferred_io_fsync() return value.

----------------------------------------------------------------
Dan Carpenter (1):
      OMAPDSS: pll: NULL dereference in error handling

Tomi Valkeinen (4):
      OMAPDSS: HDMI: remove double initializer entries
      video/logo: prevent use of logos after they have been freed
      video/fbdev: fix defio's fsync
      OMAPDSS: SDI: fix output port_num

 drivers/video/fbdev/core/fb_defio.c      |  5 +++--
 drivers/video/fbdev/omap2/dss/hdmi_pll.c |  2 --
 drivers/video/fbdev/omap2/dss/pll.c      |  3 ++-
 drivers/video/fbdev/omap2/dss/sdi.c      |  2 ++
 drivers/video/logo/logo.c                | 17 ++++++++++++++++-
 5 files changed, 23 insertions(+), 6 deletions(-)


--qhuBLOxK9COm3Rf8d6G3PrWF9Mv6hUmHK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUopA3AAoJEPo9qoy8lh71Zp4P/1mzbvgmquGW1/oQQjHn8d8t
EJiXcwFeGAvhAwtGlmYK40brq/OdRh+Y3xlSLZYZSi+cXAMN2cNqUSwamKPQvB3o
1zI8hFDNpz91ttoP1RALaEa860jZG/GgR5UqNJq6qZvqIWrOUXGIn5kYv66xP22/
2TF+75ehv78zGr6jejCwXv2G0GHZypvsABY8fpaZJJiyEIHAFxoQKTfTKWM9FwYZ
QU32M0WsdoyJhqY2CO9J+QTQdqDytiLDHXQK0bk3ku5Z4Z4FdbLKiwSTH/Dla++x
NlyoJlY71k1L57dimM96u7LaSQH8S74kqTwJzSEEUA/Fqj/mjbLdjV5xvD5wZa9R
qJsOLeFkTV3iw1lnZx4nEZU2MsrVhpKwvV2+8MhsbVSXtezROumEAaxbzcZzfFtW
i46woHxQARGQ2s5CSb9ueUFqp6tx8xAPh55acOfYwMOfdCLt2TEVC3A7EUTXlm8Y
5SWHvnNK3A842WTCqOg3t/S8ickDpFHlMsifvbnald/GTQ7hk20j+FFxzV32d3fZ
hEgAHiEcM4sA34KAgw1jwd2qp3BjMhrE/qnU5v2svaBr2vpZ3GXObP1tjS3IhPU1
IDPhJJcutQtLk04xvAbehL22QCQTctr2Wt0jaz+2mBULaZRoqg0G6zTf4+IQI/gP
1/+01g8lXd9cIdSq4sXa
=DWAl
-----END PGP SIGNATURE-----

--qhuBLOxK9COm3Rf8d6G3PrWF9Mv6hUmHK--
