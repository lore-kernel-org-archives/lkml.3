Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3EUSNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:13:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46821 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3EUSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:13:04 -0400
Date: Tue, 21 May 2013 13:12:30 -0500
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20130521181230.GF1627@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7phR3qVEw/4Cnor3"
Content-Disposition: inline
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 0/7] mfd: arizona: Updates for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7phR3qVEw/4Cnor3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-v3.10-rc2

for you to fetch changes up to f773fc6dca4619bdf8da767eaba101a83b766059:

  mfd: arizona: Change fast_start pdata name to better reflect functionality (2013-05-21 12:41:54 -0500)

----------------------------------------------------------------
mfd: arizona: Updates for v3.10

A bunch of enhancements and fixes for the arizona devices, adding a few
new features (the main one being device tree) and improving robustness.

----------------------------------------------------------------

There's going to be some changes following on from this which overlap
with ASoC, it might be simplest to merge all this stuff in via ASoC if
that's OK?

Charles Keepax (2):
      mfd: wm5102: Manually apply register patch
      mfd: arizona: Change fast_start pdata name to better reflect functionality

Mark Brown (5):
      mfd: arizona: Read the device identification information after boot
      mfd: arizona: Add missing cleanup on remove
      mfd: arizona: Disable interrupts during suspend
      mfd: Add device tree bindings for Arizona class devices
      mfd: arizona: Support use of external DCVDD

 Documentation/devicetree/bindings/mfd/arizona.txt |   62 ++++++
 drivers/mfd/arizona-core.c                        |  234 ++++++++++++++++++---
 drivers/mfd/arizona-i2c.c                         |   10 +-
 drivers/mfd/arizona-spi.c                         |   10 +-
 drivers/mfd/arizona.h                             |   12 ++
 include/linux/mfd/arizona/core.h                  |    2 +
 include/linux/mfd/arizona/pdata.h                 |    2 +-
 7 files changed, 294 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/arizona.txt

--7phR3qVEw/4Cnor3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRm7kLAAoJELSic+t+oim96KQP/0KYkWcOlgwuv88GQOqBhKAk
bYSZTeYr4WcFPQS6KeC/NkVor//O689XE5vfbZ3xhhArmtPkoMwcXFBQRpbY5y0i
1sXpWBfB9dYyVeTSYmSTKDIO5OpaQkP35672/CvflgIqE2pjV8PN9HlpunKBb7PE
xGc2SRIVDJGDUHcMxJswico46YXbEBO086+wZJ+Tes/UCoxo7rtPfIyROe6cdMOj
DDCrSDfAL9yOBkyW4Y43k1gpp33W8f9YdDVERgIOS+ioK+wjvDUdjBOAhYR0KsDZ
7HsUaIOUrx28EVo/6THw+fcMzJbQ16yxg3aEjyT1BaQpZ3Vg1gF7XDcjD/xAnlo4
eFxF2AapBJ3Qe7FixJpT6PAfx9do/To+3fiqurY718j9akEcgL6GTvm9O/hfI/7o
HvSzDAymPZYEJWSTAhWKVrunHPH/H05ZvkmdLxWSpmc+iNoyX8MbbUqsczpkV8KJ
/DaWJ6e28etp90vx0B+4qFgqr+njjl2ua1UJ1rBG+RjeqRhijUQJalcIoDykTVcU
guoNS08AEjvbaeEHrD2MyVFLy+YsGtpwgV7fuybSOVeKVADBPIpAPbekeiwNQvDp
llpRrA0ReZubPixbqpvxojplQH2tiRbrMKTB5H4Fx/3Em0b0sxNgq+4Y+Tfk1AOc
QrqwubYPntBBm2KCmIxE
=AI1b
-----END PGP SIGNATURE-----

--7phR3qVEw/4Cnor3--
