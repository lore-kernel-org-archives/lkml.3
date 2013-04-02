Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab3DBLcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:32:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46523 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759941Ab3DBLcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:32:00 -0400
Date: Tue, 2 Apr 2013 12:31:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/16] extcon: arizona: Updates for v3.10
Message-ID: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cy9Nn4fUvYST66Pl"
Content-Disposition: inline
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cy9Nn4fUvYST66Pl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit df8c3dbee9e6f19ddb0ae8e05cdf76eb2d3b7f00:

  extcon: arizona: Fix interaction between headphone outputs and identification (2013-03-26 15:45:26 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/extcon-arizona-v3.10

for you to fetch changes up to 7abd4e2a8f1c3e534da44c35e2d3d6353573e51f:

  extcon: arizona: Make mic detection timeout configurable (2013-04-02 11:54:07 +0100)

----------------------------------------------------------------
extcon: arizona: Updates for v3.10

There's a bunch of different things in this series, I can split them out
if need be:

 - Support for configuring the button detection circuit to reflect the
   accessories supplied with the system.
 - Improvements in the HPDET based detection scheme.
 - Additional robustness against more pathological use cases.
 - A few small standalone fixes.

----------------------------------------------------------------
Charles Keepax (1):
      extcon: arizona: Check we report a valid impedance

Mark Brown (15):
      mfd: wm5102: Add registers for microphone detection level configuration
      extcon: arizona: Attempt more microphone measurements
      extcon: arizona: Allow configuration of button detection
      extcon: arizona: Don't pulse MICBIAS for HPDET identification
      extcon: arizona: Allow pull to be disabled on GPIO5 when used for JACKET
      extcon: arizona: Raise minimum microphone impedance for HPDET method
      extcon: arizona: Suppress duplicate JACKDET reports
      extcon: arizona: Tune up HPDET debounce
      extcon: arizona: Retry HPDET identification for high impedance
      extcon: arizona: Don't ground flip when using HPDET identification
      extcon: arizona: Simplify HPDET based identification
      extcon: arizona: Time out if MICDET fails to report
      extcon: arizona: Clear existing button reports before reporting new one
      extcon: arizona: Allow additional debounce during microphone detection
      extcon: arizona: Make mic detection timeout configurable

 drivers/extcon/extcon-arizona.c       |  391 ++++++++++++++++++++++++---------
 drivers/mfd/wm5102-tables.c           |    8 +
 include/linux/mfd/arizona/pdata.h     |   21 ++
 include/linux/mfd/arizona/registers.h |    4 +
 4 files changed, 320 insertions(+), 104 deletions(-)

--cy9Nn4fUvYST66Pl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWsGgAAoJELSic+t+oim9O4UP/148Yc5/J/mUNIm1Vm0eYoYU
7FdmSi4xTcF9n4+sh4O1roovRTF8VyYMmutzph3IoO1J+w4093gPbfgiEn45UwBD
ywQw3thXQyDgt010LOInz2ytxiJGXXzdoIo3XBR396b61ZR499JjegtIHBWFOtfZ
u6hwq81VK2VC6B1js+BYhH95wIlhVJtfVf8aVXt9OA7+tOlr8IfqREIoUfIbIVFL
kCKI31POGoxhN70j9OUdjFbC5EUtWWjTw+jF66J1oKXPGORYaIDosRHXrBVXq9cG
vLCWvh7XiNf3XvW0oiK1tQ+84WzVRI4v6GBPDp6wz+SDKckHv/jrDFuQhSwMj7rm
KhcQ+QuLlbFK/a2+gXBDsQEPdyBy1OzqY2dqwcILm9rsRPLCCS/rH4HXc2VRvwKp
HrushXQgSLoW9h0oEghHwzmN4nDmyNHW6gPmA9w8AYvAzEc98vmL7r4etMRmJEWH
N3ZtQne/1CKGcp4ZUbLDqvl15xHQGiPPVEGT4ScRRJ+cydWUp49l+CREL3OZjBqf
103Yms2kN9PaNClvYZIx6uOFdIAu1ZEciqlE9OCQ3iLwN+Pxblw3xR8PRaAw58Y1
S1oK/fX8+M9d91iWjBke+OiaLJmWRahBucOAlpKZ5Lvn/az6uBz/BLewra/Vd5dI
0jH5EWOmd4DXmXjzFkYl
=vg5G
-----END PGP SIGNATURE-----

--cy9Nn4fUvYST66Pl--
