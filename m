Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaLVQwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:52:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44157 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbaLVQwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:52:32 -0500
Date: Mon, 22 Dec 2014 16:51:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141222165151.GB17800@sirena.org.uk>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
 <2842090b2c7a8a98aed0cfa02addcef0b2e8ec6b.1418826016.git.Andrew.Jackson@arm.com>
 <20141222142636.GT17800@sirena.org.uk>
 <54983E0A.2050005@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NctWKJLgDreUm1FS"
Content-Disposition: inline
In-Reply-To: <54983E0A.2050005@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 5/5] ASoC: dwc: Add documentation for I2S DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NctWKJLgDreUm1FS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2014 at 03:51:38PM +0000, Andrew Jackson wrote:
> On 12/22/14 14:26, Mark Brown wrote:

> > This is a name based lookup of clocks but the code doesn't use
> > apb_pclk at all; it needs to or the binding needs to say that apb_pclk
> > must be the first listed clock (which would not be good).

> I can remove apb_pclk: I was modelling the device tree entry on=20
> various PLxxx examples (c.f. amba-pl011) which also reference an AMBA clo=
ck
> but don't use it.  (The effect being to document what clock the block is
> driven by.)

With the AMBA devices the AMBA core manages the bus clock for the
drivers IIRC.

--NctWKJLgDreUm1FS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmEwmAAoJECTWi3JdVIfQjScH/3Yk376mDDobaz9ioBVvzEWa
iVzK7Ke2oJPFyPU0Z6Zqa3rgXf2axlAcUu4IPMEIeKNlByt61/weFntwIJlGaYax
VwVXLKyz+/RwBxxHc/GLOaH4JCZSjAKz1juFYMGvR5EkiyELCoitBfmVL/zTlcnK
f/tgHmNcPdkQE6VE1OFMpwJ/IOn8t1v913PdPLA0aNPx0W0VyNT1rohvShf0h7p5
N3P+XTVAhZrEsJf1DaWQVcKRPdI4HywiBN6diqcW6gcz3pvptF3+bV+X1y0hTESu
t/YeK9ZFMA9vJYdz3cw4kGcr0UX89jOrSwllXYpUzRI7TJY5MRbBQGb9oD5LDu4=
=D5+w
-----END PGP SIGNATURE-----

--NctWKJLgDreUm1FS--
