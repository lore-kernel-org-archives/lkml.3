Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaKKRGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:06:54 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36322 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaKKRGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:06:52 -0500
Date: Tue, 11 Nov 2014 13:06:46 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Rui Zhang <rui.zhang@intel.com>
Subject: [GIT PULL] Thermal management updates for v3.18-rc5
Message-ID: <20141111170644.GA4265@developer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git fixes

to receive Thermal Management updates for v3.18-rc5 with top-most

90a21ff5824c3ae8b49c1c0498b137792b935aab:

  imx: thermal: imx_get_temp might be called before sensor clock is prepared (2014-11-09 15:42:53 -0400)

on top of commit a1cff6e25e6e3b55183610dddca91546951b20e3:

  Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal (2014-11-04 11:57:27 -0800)

Specifics:

- I am sending thermal fixes for 3.18-rc5 on behalf of Rui Zhang this
  time. He is currently unable to send pull requests due to troubles with
  his machine and he's currently in a business trip.

- This week we have few fixes:
  . Fix in IMX thermal driver to do the correct loading sequence with CPUfreq;
  . Fix in Exynos related to TMU_CONTROL offset in Exynos5260;
  . Fix the unit conversion in int3403.


BR,

Eduardo Valentin

----------------------------------------------------------------
Bai Ping (1):
      thermal: imx: correct driver load sequence for cpu cooling

Bartlomiej Zolnierkiewicz (1):
      thermal: exynos: use correct offset for TMU_CONTROL register on Exynos5260

Heiner Kallweit (1):
      imx: thermal: imx_get_temp might be called before sensor clock is prepared

lan,Tianyu (1):
      Thermal/int3403: Fix thermal hysteresis unit conversion

 drivers/thermal/imx_thermal.c                     | 45 +++++++++++++++--------
 drivers/thermal/int340x_thermal/int3403_thermal.c |  8 +++-
 drivers/thermal/samsung/exynos_tmu_data.c         |  1 -
 drivers/thermal/samsung/exynos_tmu_data.h         |  1 -
 4 files changed, 36 insertions(+), 19 deletions(-)

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYkIaAAoJEMLUO4d9pOJWxjEIAIsBOd3SiSwpMz+N8XZP82Hc
2T1iwKKHQPWdGmngkNfocf8BljwvzrU8I/IORIXEkvsPTodohRoXS0D4iBGIpTid
PIYScEaYyE5Z7Wgh9x6PRsa8GXerSHR0fJ9gAF96hCvUSzoCjQkPDT1vdPicRgAV
puBbZCdGlPRGI/UsiXBOMMftPmQ0ekr4MjKTXzwqKeM/uJdJKQD+8lK1ECS/C5cV
S4htPyC0zX9eA3i3G+jm0p1fb4XtFZulmhUJelNvE4WpZ92P+wjr1y+RA7Xw19GI
pqt0NsA3ujbIzR2jZNpjnau99WgS7e8e3I/SXuKf3o/lAZ8j+YN9i9aC0Y8o2fI=
=iwfo
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
