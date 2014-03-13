Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaCMVlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:41:51 -0400
Received: from sauhun.de ([89.238.76.85]:38041 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbaCMVlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:41:47 -0400
Date: Thu, 13 Mar 2014 22:41:46 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.14
Message-ID: <20140313214136.GA12161@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here is a Kconfig fix for the I2C subsystem. Please pull.

Thanks,

   Wolfram


The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to 62c19c9d29e65086e5ae76df371ed2e6b23f00cd:

  i2c: Remove usage of orphaned symbol OF_I2C (2014-03-13 22:33:44 +0100)

----------------------------------------------------------------
Richard Weinberger (1):
      i2c: Remove usage of orphaned symbol OF_I2C

 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTIiYQAAoJEBQN5MwUoCm2ucQP/jVO7xub0KMO1AkHtoxHCLFw
dScq/2ICdHaoUCryoJ0BVZBlvTIZNO7Z0DGPcTbLwDtg4p041GAosvHqtBGqvCtG
78M2a+OY7RDNsNcddPuVNjl79DH51nSqlRukJ89+AqbHQ/DLgPH5OWBtsrKqMD/2
ShvCJwGV1NfiLO5OhXQHNfr2ieXvfiV/VkC9T6Q/5lalU6mQAosI0PJBN/IJddOK
NdoMioCKeiAuRD/G5GDURieNWJ3xfjp7NHt0dPbBPBVV3Ftosu1hvLYQJyi6xSdG
whZTQU5ieBL+JWwjMOZq+tpwVT4cP7AMcnef4SHVRno7gSzDbIC9g6cOYOtDo9lB
zKKN0sjlaes4BZjSSomyfUTaPmdaAl9W2heR7d3jmU0UtIuTnzoV0NK7DsSRbbWM
iPjK17mreEJ/pN5ipCVeaGZFw9OLUMsmUFm4NLSqAU/GYAwmGUb5bV2soETa9Pz3
COojosAKd4WYfj82whnwj9gC6u+vj4zftNrXogreB5WVYL1bV3/Bw+e151N2akxW
w+hn1mIjqYvELmFp9LwQP+m4SDryPhhYSqbkABKL6idhGVRImY+1Pb72c0jkVbAP
RTUVcNQJq6/jH06O8vJIMat9lPJbDlf0tscebuKeZmomurKmKo/Hd3CAhIiuEvmn
uTFs8KLm2O60GhfkLmPZ
=djEv
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
