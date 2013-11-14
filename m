Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab3KNRdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:33:49 -0500
Received: from sauhun.de ([89.238.76.85]:54666 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab3KNRdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:33:41 -0500
Date: Thu, 14 Nov 2013 18:33:34 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: add new ACPI IDs
Message-ID: <20131114173334.GG11022@katana>
References: <1384250250-10643-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0qt3EE9wi45a2ZFX"
Content-Disposition: inline
In-Reply-To: <1384250250-10643-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0qt3EE9wi45a2ZFX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2013 at 11:57:30AM +0200, Mika Westerberg wrote:
> Newer Intel PCHs with LPSS have the same Designware I2C controllers than
> Haswell but the ACPI IDs differ. Add these IDs to the driver list.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied to for-next, thanks!


--0qt3EE9wi45a2ZFX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJShQluAAoJEBQN5MwUoCm2OQQQAKVOCsDMjSzo5P4I7j+jk1E1
QXsi8DEMp2mPZf/kFddLZYlot2RaYkTV+swzqb3t+pCNpIBnPVqxVk1AgNed8EaT
RnvNw/TSNwtVQQlgwwW92BKZvY0WCQk0PD2+xvmW33sRMUHqgrbeMor7Bx0ouup2
A76MiD6S97DeTS//WyD2QEzEf1JYz9ECjwp7kA2Uqv/o5muC/7NvkWCdZ83oSBnr
4iYFiN+mwmrjJ69OHaHGiwSSb34bAtf+LEtS7snTboxlB3oe2MCd/U/Fx2JDE/Oy
yHS565Lcp0WlM9HxHGXtjSs0VbzSRKVANIKpRe1RTiJxOe01tcGPQw71l1R2yGb+
DfaEHANzxrGupfbZj9oZem/1ugdT8Jc943qrw/MEBGlGM7cb6C3Sh8B00k+2aMKi
8j6MjlzPwSxxt8tYuVwV0kWuuv2o/4LsQsc1adEcI3Tfbx84H/INHjkPnkd0gAol
NhaLFgp1FBNJ9gj/3SmkwUYCNMb/H3SIYc1sA4YYOrJeI06VEgj4K9xzd3T+7Fim
1PdSOjbLrqwudNqbmVF8GQYF6hUopMWtf88hVfdzc1NLr10yNNr2NMBz7Qrt5Xjt
cSSTt4OlXPd5GdhPoXe+OFb6AdecYzHzcyDGqVigpiTzuGC2X+PHUbC8XFinix0f
gdQGwgBhB+DKkRj/Eln1
=cUp6
-----END PGP SIGNATURE-----

--0qt3EE9wi45a2ZFX--
