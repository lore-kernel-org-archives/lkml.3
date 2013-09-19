Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3ISMKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:10:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53070 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3ISMKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:10:23 -0400
Date: Thu, 19 Sep 2013 13:09:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Marc Reilly <marc@cpdesign.com.au>, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linaro-kernel@lists.linaro.org
Message-ID: <20130919120951.GO21013@sirena.org.uk>
References: <1379527587-14567-1-git-send-email-broonie@kernel.org>
 <1379527587-14567-2-git-send-email-broonie@kernel.org>
 <20130919091318.GA22389@lee--X1>
 <20130919095628.GH21013@sirena.org.uk>
 <20130919100434.GB22389@lee--X1>
 <20130919114107.GL21013@sirena.org.uk>
 <20130919114910.GE22389@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3h+hNn3PVp185ISI"
Content-Disposition: inline
In-Reply-To: <20130919114910.GE22389@lee--X1>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI
 I/O function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3h+hNn3PVp185ISI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2013 at 12:49:10PM +0100, Lee Jones wrote:
> > > Either way, it needs changing.

> > Let's see if someone actually tests the code first though.

> I've taken the liberty of bulding it, but I don't have the h/w to
> actually run the code.

> I get:
>   drivers/mfd/mc13xxx-spi.c: In function =E2=80=98mc13xxx_spi_write=E2=80=
=99:
>   drivers/mfd/mc13xxx-spi.c:97:14: warning: initialisation discards =E2=
=80=98const=E2=80=99 qualifier from pointer target type [enabled by default]

Sure, but like I say let's see if the code actually works first.

--3h+hNn3PVp185ISI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOumMAAoJELSic+t+oim9E4gP/1R5iMPJ+adeA0/5DtJp3+ia
0XohInPtVvSPQCCMSegpQ/vSu1uWychJL/WrB4SHJBgzbKFH9LqKGEP9wF5USSrJ
BD+cDrIwwn0dzQGlNCEMcrEaupXZrDC7SMbzTm85VSRng7SqSutc/bIP//r5nQ/V
5S19xkVjaYvx88F8ZpUMkajue7UVpzj8OK7GHYcrwieSVdYP1+b9YMhociTjv7Hl
J/OHas43PBJoq1N2OWNEa4dLUE/RvIVWZKNj+NTtn+kCsqIUJA2OCXEdrGp4YYBY
wyWOt5Ir0Uy4X6y6nlHxMUs10r3/vULNlKARaNpNmCPa33AL0N71SMgnP6iEP5jF
9MiyY6SPgsHeHvzatBv8lbZNMnH6WzX52Yy3XO+qTC0m42GcndVvpNOGY1YR/wv+
Z5fide2BgzRrcoSvUMvzXehPmqBRBI7EYbVUBMHc/Mp0udBwyBrHkJxq7LFH7UTH
iHy+L6eanzdV+jc+Y6SJ+Q4H/y+6H8UHeC2EykE5KZOScTw70dAaD2OROCBtSi45
wx+cRvtmq17WbZ8FG/kWklOB8pmXFIi9bV19HyHq/nDPQffqeb6M1uAvuhyVkl8R
GYNqSZqgX0ktQOOf9EMFlZv24j3x7FhylFxlIiZI9+mjZOohWRuPeCkbyPS3GAlr
jhcgRoBTxkC3+EPy4SNv
=V+bL
-----END PGP SIGNATURE-----

--3h+hNn3PVp185ISI--
