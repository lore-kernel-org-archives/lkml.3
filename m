Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaBNJKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:10:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53299 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbaBNJK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:10:27 -0500
Message-ID: <52FDDD7A.7070806@ti.com>
Date: Fri, 14 Feb 2014 11:10:18 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] fbdev fixes for 3.14
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="8qAPbhfSagkkd19kIVnpwotTGP0H8odVT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8qAPbhfSagkkd19kIVnpwotTGP0H8odVT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull a few minor fbdev fixes for 3.14.

 Tomi

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9=
ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-fixes-3.14

for you to fetch changes up to b359bb0d9c5132abb6fec1ef555c48daf267de59:

  video: Kconfig: Allow more broad selection of the imxfb framebuffer dri=
ver. (2014-02-14 10:44:52 +0200)

----------------------------------------------------------------
Minor fbdev fixes for 3.14.

----------------------------------------------------------------
Denis Carikli (1):
      video: Kconfig: Allow more broad selection of the imxfb framebuffer=
 driver.

Sachin Kamat (1):
      video: exynos: Fix S6E8AX0 LCD driver build error

Tomi Valkeinen (2):
      OMAPDSS: DISPC: decimation rounding fix
      OMAPDSS: fix fck field types

 drivers/video/Kconfig           |  2 +-
 drivers/video/exynos/Kconfig    |  3 ++-
 drivers/video/omap2/dss/dispc.c | 16 ++++++++--------
 drivers/video/omap2/dss/dpi.c   |  2 +-
 drivers/video/omap2/dss/sdi.c   |  2 +-
 5 files changed, 13 insertions(+), 12 deletions(-)


--8qAPbhfSagkkd19kIVnpwotTGP0H8odVT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS/d16AAoJEPo9qoy8lh71ko4P/iA53mAne0Tn1SCTTi2i4rvF
PETOH9sGNaZxIwVD/4thL+kOigDzaqNneJ0gOeF0HRK0TH4Xi4UsffgTRYhGP7MM
N4Y7mU6mY8kshe/wavqj5M6/8J89rx4iynEY0GPhdT87YA3g25a+n6p4v/5GpirF
JaLSqDtNtpsyaGQsSYpotgWA1LGXsm7oAF6QgOMlpP84ET5CZs2/Tbs4OX7aLh9T
1VTctWdevRsX5DzN2zmiWrDzNdrjzkn/lUPf653BTMZNqFPoDDleRSgC+eV6Yhx/
ix+AKyXJpgqLS91aITZ+4qBbQ+WNW42Eef9tMEqRJFtF8s4ESNz1uudxLBvPgWgj
T1K4JBjPYqzzMSOEgkRJb0ZyQQDB/+N7uZOzmOKnh2YhR4I1moDuhGpKg2bmPe3p
o4rmsEeXceBMGIdu6uh8xadB4qjXNTN7BdQpuTJ87FfN9UdxRfhceiMD5BAlUQJ7
eGoxHXSNKvMjkBF1AHYEj+ZKjHnMRUhoWnVbKjmOSKihQlmhK45ht3QFwwtV/uSf
FCszXUoXhn8IQAguKP6Mo0NXcuGd31OIT4G5Ovom4hFDxYEfgIsG60V7Lb9Dsr2B
Cc9cPa0FtXqqOIFAH8dQlifxc/F3fOeV0Cyiyae4cXdc492A4gWPxceaLWIPRgvJ
VRJbSAJ3i8ktPuoAXkKv
=HED0
-----END PGP SIGNATURE-----

--8qAPbhfSagkkd19kIVnpwotTGP0H8odVT--
