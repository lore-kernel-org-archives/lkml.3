Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab3BKQ0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:26:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51280 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757760Ab3BKQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:26:17 -0500
Date: Mon, 11 Feb 2013 16:26:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 00/11] extcon-arizona updates
Message-ID: <20130211162614.GH4607@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TBNym+cBXeFsS4Vs"
Content-Disposition: inline
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TBNym+cBXeFsS4Vs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 689557d3c7045320958d5bc4141088f7b4dff7ba:

  mfd: wm5102: Add microphone clamp control registers (2013-01-15 15:42:18 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/extcon-arizona-3.9

for you to fetch changes up to bf14ee5a460276a99ed35f9034bae9e74b01600f:

  extcon: arizona: Use MICDET for final microphone identification (2013-02-11 16:06:25 +0000)

It'd be nice to get these into v3.9 if we can.

----------------------------------------------------------------
extcon: arizona: Updates for v3.9

More updates for v3.9, a mix of fixes for the code that's already there
and a few new features.

----------------------------------------------------------------
Charles Keepax (2):
      extcon: arizona: Remove extra jack flip increment
      extcon: arizona: Clear _trig_sts bits after jack detection

Mark Brown (9):
      extcon: arizona: Disable debouce for accessory removal detection
      extcon: arizona: Retry failed HP measurements
      extcon: arizona: Remove duplicate rate configuration
      extcon: arizona: Support additional configuration of microphone detection
      extcon: arizona: Use regulated mode for microphone supply when detecting
      extcon: arizona: Add some debounce time before starting HPDET identification
      extcon: arizona: Don't HPDET magic when headphones are enabled
      extcon: arizona: Always take the first HPDET reading as the final one
      extcon: arizona: Use MICDET for final microphone identification

 drivers/extcon/Kconfig                |    2 +-
 drivers/extcon/extcon-arizona.c       |  240 ++++++++++++++++++++++++++++-----
 include/linux/mfd/arizona/pdata.h     |    9 ++
 include/linux/mfd/arizona/registers.h |    8 ++
 4 files changed, 221 insertions(+), 38 deletions(-)

--TBNym+cBXeFsS4Vs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRGRueAAoJELSic+t+oim9D2oP/3wj1o4R1YJURMvPHzl55l9y
/8JsEMNhCnF4yZNd1sILhxz6CkpUh09uAe4uKvECyc6LiXS/x1qsdKvjegRoGynV
SwMrg4Rylde81Pu6k7dR1B+pN46i9ExY+Qpgw6s4KPgp8cKzMzqo3MboVPyk8u+Y
LEOJJDG0sMPtyiKJNDY+DqSuE2yAkrDkMxjPHHoknmMasUEQEgrHdkoYr8KUzlAs
Y9zWiYZ045uqW7Lf3G6+710wMUHg6F9xGnDwQpgXGV0pYoJF4pJuAmypQRWgjzAd
e+H1PAOsEepmXFYd2y4FaMvOBlUco1nFQt2EAJFt6FrlPpEfbYeTn+D+hZVFxjBo
z+ZlR/H7oFBe1/XZZs7VCYspxXRcgYFP/aelDgWK4qmyaywPNgEZuxJNgmfeffCr
D2oQf236ajngAAAONVWoyCcYVMZoBTgV8/9IWGW2NSg1lod9MEyoRJMVct5rxYUg
JFnt9qU/tNM7sHHFel/hVJBTgEyDHqimBORHjrwe5paQakVMXcKyzbUMvAzyW6Bn
2pbb8Iq7t9kDRkFNqJJLFUH1QMgpUjYvxRgwkXVxMwG9dthYOKIBnnyspRah6IU5
7gCydKSL+xlPUX2+7F+hSUHhpLJ5o2WeyO6I1E+Vyubq8ZUpBqpV5XMr5M1i0dgb
R4q2NIkXBil+/G+/X97Z
=6H7C
-----END PGP SIGNATURE-----

--TBNym+cBXeFsS4Vs--
