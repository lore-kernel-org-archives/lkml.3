Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3GESGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 14:06:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57151 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3GESGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 14:06:33 -0400
Date: Fri, 5 Jul 2013 19:06:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Bo Shen <voice.shen@atmel.com>, devicetree-discuss@lists.ozlabs.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Message-ID: <20130705180603.GG27646@sirena.org.uk>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
 <1372667978-4718-9-git-send-email-richard.genoud@gmail.com>
 <51D2472B.2010407@atmel.com>
 <CACQ1gAji8KkjXee8o=9jt8O38611LBJ95yXimxbfn1qLaLOcnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h0Uwb96Xetxfzqgd"
Content-Disposition: inline
In-Reply-To: <CACQ1gAji8KkjXee8o=9jt8O38611LBJ95yXimxbfn1qLaLOcnA@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 08/13] sound: sam9x5_wm8731: machine driver for
 at91sam9x5 wm8731 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h0Uwb96Xetxfzqgd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 05, 2013 at 05:15:05PM +0200, Richard Genoud wrote:
> 2013/7/2 Bo Shen <voice.shen@atmel.com>:

> >> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> >>
> >> Description of the Asoc machine driver for an at91sam9x5 based board
> >> with a wm8731 audio DAC. Wm8731 is clocked by a crystal and used as a
> >> master on the SSC/I2S interface. Its connections are a headphone jack
> >> and an Line input jack.

Always CC relevant maintainers and mailing lists on patches...

--h0Uwb96Xetxfzqgd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1wsIAAoJELSic+t+oim9y1QP/3V0NznXtsLit+31m4HhXHX3
hmZb6Qc8FicqbcebjweuYHnxspDr10pv0pRbmq9eh9uIX0x3Kch6YOXEifQj53jy
o0UBCOVpZ0NU1CAcTdqJq+jFikxRU34PAw5WjCEuvitWFe6jlzd+3rTP/J3TNNdN
B9iji5pHPMTDaINZ6Ey2k79zzwcLjTFwCFjAnSbUp2nIg7ioX60Fwwk+s0QgKELx
ZW5MQBJbIwvnGuUElG+pBQnUblar1yQYgN5OU8h5xcryTC5ahddjNo8RmwBYONPF
4FNGU8fmVUgqLcB+FyFpOrZFAmqiDx2FzFRvsD2WaL4ugGdJBFsz5xSzLm8w/Q2x
IddBhhAM6W+4Cx2n7AU0B9tfoCT7ANnGVjZizZ5UqqYHLyMRWtRYsS0ijoqvM10U
iRli73pSXKZ+hXOk5shRGoN3RmfzK4xkNurkhQFHUkjniUcgnFAhBevFAjmiAjuk
JyrYrOGCpowXPlvrYTsLmW3eT/htSObF2L0DwIY0/BTrLpS+WvItvnv6mtX0NPT6
8E/e35XNt979UplZSRnqpyCpwUvu1QTrCaeOObN8mTFqpXpxMxz12G7oqYjgwyPv
0nuJFh0xoA64GjKnaWLuRsyo7qGv3xoIMZAnIysumOIfxfsT+0Kp1XiES188h1LZ
7PoYSPBGwXj3XvLoOGAv
=7jhG
-----END PGP SIGNATURE-----

--h0Uwb96Xetxfzqgd--
