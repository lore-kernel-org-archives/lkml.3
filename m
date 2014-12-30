Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaL3Quh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:50:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55937 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaL3Quf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:50:35 -0500
Date: Tue, 30 Dec 2014 16:49:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141230164954.GJ17800@sirena.org.uk>
References: <cover.1419936132.git.Andrew.Jackson@arm.com>
 <af6e23a9f11ead4b8abd1f70dbf634964253b37f.1419936132.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8BcKDWTCgcPKISnA"
Content-Disposition: inline
In-Reply-To: <af6e23a9f11ead4b8abd1f70dbf634964253b37f.1419936132.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/6] ASoC: dwc: Switch to managed clock resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8BcKDWTCgcPKISnA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2014 at 10:55:43AM +0000, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>=20
> Simplify error handling during probe by using managed clock
> resources.

Applied, thanks.

--8BcKDWTCgcPKISnA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoteyAAoJECTWi3JdVIfQHEcH/0MOPT5p2RlcabPztcpVk2hA
bdZRbgtVBFRyLVt7jBmmHGieDP+AmLiVenuNpCoafiTxG9Y05/jY3nbyUkYfAXD5
f0k4xnMFGJZSblvmWfto9yEGeqknSc4ML2Ro6RCgPbEVvzm24tcLLBXzgXial7vO
2ROHu/k+O4TuVQZseBhn3NBbesRKY0oHKs1TjOyK733DCGU9QNmYDXiA94aTonwV
dwdX6B6w0IMYbYUA4UMPcbzAEzmYp/EIm0hAa85KQFOE9kkGUnI0eykEc+lVno6R
t8VY8P/OD9ICZfXwxD6beb+O/3hCi4J88x/PrKaZFb2H7IjZLz2nCtxLu2o+q8A=
=n1S/
-----END PGP SIGNATURE-----

--8BcKDWTCgcPKISnA--
