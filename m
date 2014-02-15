Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaBOUgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:36:18 -0500
Received: from sauhun.de ([89.238.76.85]:46691 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbaBOUgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:36:16 -0500
Date: Sat, 15 Feb 2014 21:36:14 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.14
Message-ID: <20140215203610.GA20244@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

i2c has a bugfix and documentation improvements for you. Please pull.

Thanks,

   Wolfram


The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to fde1e418ab2c4269035f7f576e678b6ad3117d7d:

  Documentation: i2c: mention ACPI method for instantiating devices (2014-02-15 19:46:34 +0100)

----------------------------------------------------------------
Wolfram Sang (3):
      i2c: mv64xxx: refactor message start to ensure proper initialization
      Documentation: i2c: describe devicetree method for instantiating devices
      Documentation: i2c: mention ACPI method for instantiating devices

 Documentation/i2c/instantiating-devices | 41 +++++++++++++++++++++++++++++++--
 drivers/i2c/busses/i2c-mv64xxx.c        | 33 +++++++++++---------------
 2 files changed, 53 insertions(+), 21 deletions(-)

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS/8+6AAoJEBQN5MwUoCm2ngsP/iL9fPbWZoeLIm7GSCAqwPMO
0Ej4okTvrGBBmLHsfe3EqirKsomH1T9J4LKy2kzLRHcmiWQP4THKkzqmvyGVFzFo
xM6PGGelf/tpguFYnBUtewBd+JWTkRZ1CbRIa5qgTVE8pRIJbMs7gli1TBuneHbv
LxSk3/NV/LgVH5GY2JiQXnWaUEX/FCpFq8Oq6QPSWCEZSEbsWh9xOsaGYtQdheLR
Nx0RI5A+H3h5DaAh9THDV314VGiMgaqQuD7DipGbKFY2Hf3YMTHBV7RUOvnL3Hs5
A+MsANbxCbRQz9thgNwvSoh6o+zcLKwMnu/1i2WTbh7+f2sJlkQD+6DbK8s+TQZ7
Y2oXV5IvJ5hVWqooPaykzdeMYPnYWhJt7laZ9B0KFXB2gPJAKExqQbY2jPfMb94o
ctk7IqlRKOpiaiBP8dW1zCqzp+qBTzDWMmc4xPmwK8bip7TzG4OtBJ7pBq5lrBdP
5/dNkB0ivAjvB+sBuXsXngN2eHCciqrmAoDKFhtLtwFpnxWZ4YXC8UvlDDrP5IeZ
EHho4hfsCtcAIbbJIgYJn6VV40iRJQM63hDWdhdhQ+oByb975U8zFTqAW+BtPX0p
1PG+06Tuo2MptGaPhqVjEBXIviPCYCfzdOlz1u8xUjPZEKhRX7elOZwstf6wivUw
I5T4wufH+CWAZBjJphq3
=J1Ho
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
