Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974Ab3DCSE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:04:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53529 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762890Ab3DCSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:04:26 -0400
Date: Wed, 3 Apr 2013 19:04:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/15] arizona updates for v3.10
Message-ID: <20130403180423.GA6985@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20130401172748.GG18636@opensource.wolfsonmicro.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 01, 2013 at 06:27:48PM +0100, Mark Brown wrote:

> mfd: arizona: Updates for v3.10
>=20
> This is really a few separate topics which I can split out if required:
>=20
>  - WM5102 updates to improve robustness
>  - Improved support for interoperation with edge triggered interrupt
>    controllers
>  - Support for some unusual clocking configurations
>  - A couple small single patch updates and fixes
>=20

A few more updates for this which I'll post just now, I've updated the
tag and branch:

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-a=
rizona-3.10

for you to fetch changes up to 241979cb90eb0ed5814a5b207298518a25b3f032:

  mfd: wm5102: Don't wait for boot when boot sequencer is disabled (2013-04=
-03 14:19:22 +0100)

----------------------------------------------------------------
mfd: arizona: Updates for v3.10

This is really a few separate topics which I can split out if required:

 - WM5102 updates to improve robustness
 - Improved support for interoperation with edge triggered interrupt
   controllers
 - Support for some unusual clocking configurations
 - A couple small single patch updates and fixes

----------------------------------------------------------------
Charles Keepax (7):
      mfd: wm5102: Manually apply register patch
      mfd: arizona: Factor out register polling
      mfd: arizona: Add a hardware patch mechanism
      mfd: wm5102: Deactivate standard boot sequence
      mfd: wm5102: Update defaults to match patch
      mfd: arizona: Wait for internal clocks to startup after reset
      mfd: wm5102: Don't wait for boot when boot sequencer is disabled

Mark Brown (11):
      mfd: arizona: Disable all wake sources by default
      mfd: arizona: Clarify error message for failed primary IRQ request
      mfd: arizona: Basic support for edge triggered IRQs
      mfd: arizona: Allow GPIO to be specified for IRQ line
      mfd: arizona: Try to use interrupt flags from interrupt controller
      mfd: arizona: Support configuring MICBIASes into bypass mode
      mfd: wm5102: Update patch for latest evaluation
      mfd: arizona: Fully support the use of MCLK1 as the 32kHz clock source
      mfd: arizona: Unconditionally enable 32kHz clock
      mfd: wm5102: Only use the lowest three bits of device revision
      mfd: arizona: Hold device in reset while ramping supplies

 arch/arm/mach-s3c64xx/mach-crag6410-module.c |    4 +-
 drivers/mfd/arizona-core.c                   |  253 +++++++++++++++++++++-=
----
 drivers/mfd/arizona-irq.c                    |  106 +++++++++--
 drivers/mfd/wm5102-tables.c                  |   56 ++++--
 include/linux/mfd/arizona/pdata.h            |    7 +-
 5 files changed, 345 insertions(+), 81 deletions(-)

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXG8fAAoJELSic+t+oim9e9QP/2YwTpujwxrtm/WilSAyPDKL
Uha2TEWpTA58BBRiwAas76b3mL953LxuuXJvqU1Q5yH9jZCOrtMkRE3wLvtUwx8m
Hp57jS8GSlX+7AwUm4CatDfflefQCFvLWxdrC3uETI1E/+COJx+q9ImOurlADljH
dwv8QITI273ECmTrMoL847Fo1A31uvHMqwk+6xcH4YLsSUuox9FSef7fa6VBqXmY
RvkYttkc4K0tK5Oc251JTdoadtypcncMIhauuvAa3ODLRyl+JT37qvBQ435y5BYa
JBjPFWoWYLZHFRYQQNUR0NpBTQPNEC7p0RxnEczmlQVbUlexrj9raHmBk/rezov1
FbgY7pOpKl4A2DkSWU+/2STRAWc0TkpzN0Qtt3GFrVWmrNxMckjshlLuweWhWaUj
L79A2zBopTVCDkvJsxLdDCrOAhCEfsHiiobZuLhTbnUXi3JYZ280CqMzsvSnpcfb
9VmrfawfY2hF/XFnkWgNtUtVPJC0/Jj41defqVnAJnO5Ls4V9PGgTJ9TLr45HXTt
fDJNtmGuCOaMZdcChP9bjBbb9doZVhHcuTEWvgOr0wkpD0j5sbuj33BUDn3RodM/
9SqUnR6QBYLRZ2BaypWDucwGyrX39QVj4yBdr8SvwRa8MlRoBFbY5e31p0LwerNC
sXTEJDwdRBxN14OxOrXe
=HvDM
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
