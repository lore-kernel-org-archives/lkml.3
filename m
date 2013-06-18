Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3FRP5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:57:09 -0400
Received: from sauhun.de ([89.238.76.85]:45728 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426Ab3FRP5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:57:06 -0400
Date: Tue, 18 Jun 2013 17:59:04 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 0/2] Fix kernel panics with certain I2C tps6* chips
Message-ID: <20130618155903.GC7718@katana>
References: <1371550481-28126-1-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <1371550481-28126-1-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 01:14:39PM +0300, Tuomas Tynkkynen wrote:
> Hi,
>=20
> Latest linux-next head (next-20130617) seems to have some backwards-incom=
patible
> changes to the i2c core, which breaks the tps* drivers in our boards and =
cause
> panics on boot.
>=20
> v2 changes: Don't override platform data from DT in tps65910


Thanks for pointing out. I am going to revert the commit in hope for a
better solution.

So, this series is not needed.


--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwIPHAAoJEBQN5MwUoCm2ZoEQAKA/n0v92XanhzBsif6KFikq
FhyAgjf73vDRyTbMwhz0krrCZ6z3JxtCdmQsIQidxWEi4EQMgSBOPZcl3viBrWj0
iykiv/w1h9Kz2Hm6a89mmrvdqP3LijpssNaMGSTp88uqfF8H5vL0zutMhaNGcvX1
r/BNzs4yVJUOwMK5NXDu0wPn0bJHqo8sjeYaLeUFXxOmDWDo1NMtkZthNtrPHKw6
Rcnh9pTJQwf4X/VU+zeGBgQPoAN0WSe1zarjy1tBxfwFrfbm+pujfAbfhtoUA2T5
wbsHNwFmeRozYrJ7/GrO5pVuvLTJBJOqBiEa40DHbP5rWkiCJiYUDP2P52y7VPec
/5qsM8vZbE1KkLw3K/7s/86d6HjiiTj7D/HBhj3TblIdUWXphO9gFN7aRKoQOdIb
Frcb3q2+OZrJ1LeLMeGT4golejW62ZGHZ1rPZth8VSvEGFeCg5JURG0xx11nALro
9ksB8B1T/j8m2Wb8ev8yPZHBzHH4VzgOE72h8Kk9IB9Gcx0oGQkN1Z+iNL2UyVIh
9IUA1mg76EQDe4kwCpWBeDrcC+c7n7ypqNE0rLmbM3iXN/sk8lKRbSJLY04dIYZr
OoqQ42BNSbiwOoYWDfthZBjbODEEo1hmqrgxsCzq+VvTBZgXzzjxmGRSPE55F0hE
lgXqpDdu9s2wkwbtvMXP
=oHeR
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
