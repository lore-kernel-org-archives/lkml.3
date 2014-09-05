Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaIETlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:41:23 -0400
Received: from sauhun.de ([89.238.76.85]:56820 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbaIETlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:41:20 -0400
Date: Fri, 5 Sep 2014 21:41:32 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.17
Message-ID: <20140905194125.GA2876@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here are I2C driver bugfixes for the 3.17 release. Details can be found
in the commit messages, yet I think this is typical driver stuff. Please
pull.

Thanks,

   Wolfram


The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to 91bfe2989af02e709ca01ccf518c4fbda3efc70f:

  Revert "i2c: rcar: remove spinlock" (2014-09-04 19:59:42 +0200)

----------------------------------------------------------------
Chen-Yu Tsai (1):
      i2c: mv64xxx: continue probe when clock-frequency is missing

Marek Roszko (1):
      i2c: at91: add bound checking on SMBus block length bytes

Sergei Shtylyov (2):
      i2c: rcar: fix MNR interrupt handling
      Revert "i2c: rcar: remove spinlock"

Simon Lindgren (1):
      i2c: at91: Fix a race condition during signal handling in at91_do_twi_xfer.

addy ke (1):
      i2c: rk3x: fix bug that cause transfer fails in master receive mode

 drivers/i2c/busses/i2c-at91.c    | 32 ++++++++++++++++++++++++++------
 drivers/i2c/busses/i2c-mv64xxx.c |  3 +--
 drivers/i2c/busses/i2c-rcar.c    | 37 +++++++++++++++++++++++++++++++------
 drivers/i2c/busses/i2c-rk3x.c    |  4 ++++
 4 files changed, 62 insertions(+), 14 deletions(-)

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJUChHlAAoJEBQN5MwUoCm2WxoP+Kc+IpaRVAQJrkAUASijQN1A
8uxNvVjJSVXevlUoJNvsxfIcvDgIgnk/yDrrXtk9xKyduMcmLecyXP5mTh7MxdMa
uIDxwNOBsCUz1LvE8ewoVPRZ1zV/5OMQYaNgy6Qa7/LqhJXAmdzFVjshkTfHVVd8
osHZU2d3HC4rwVUrl1Yw6V0RrtcB4jULOJhEX8h+25/N9G/zI2Z5SiVfG1J7ve2y
3DwCjjrXnnxLPyOSKezpRVgjKWHPswmJb4XAcZDqaxQieJwGX1D5PmCjihq2QtcK
NHX2N59i1TIcKNj0prQiONux3x+Z8s6RUH6iuIBDkWGgYNtuRAYwltm8qLh1yYzR
T5KHlWmmO3UatM/pkCinjyefvC8sGNmyS6nQVR4/BbhxyBpwyOeksY2UUmT0fmwU
HI9o1TCUgYpwb2yNkp+StWEzwB1zPCNlaUKSmoCKeXKCrOvGUBO4Dbuu4MJrRrXq
Y0WM/m4C+JP/mPsalQbjXqFgOYArvE2duujO/N08rAcntvvN1HTGRgGJH5UFWrnc
cUno4Dt3GTrTgTEzEPdeZ/ZX1WOTaI/xGQJbxCSmRL3IlF1RJDR3IOnMxtKiHHll
9kQiy62LQImeuaQunNavCB4bCq1F5cCPJo9nCTTaki3bDdxC109GWoXbRC+dlm3R
2wNMXxoAquDIXe5cgTc=
=W/B9
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
