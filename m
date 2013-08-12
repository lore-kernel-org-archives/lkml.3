Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3HLVlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 17:41:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44541 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab3HLVlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 17:41:15 -0400
Date: Mon, 12 Aug 2013 22:40:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Eric Miao <eric.y.miao@gmail.com>, robert.jarzmik@free.fr,
        kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130812214050.GI6427@sirena.org.uk>
References: <1376340564-7975-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gqUrV6DUXoHnB0ku"
Content-Disposition: inline
In-Reply-To: <1376340564-7975-1-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/16 v2] sound/soc/pxa/mioa701_wm9713.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gqUrV6DUXoHnB0ku
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 10:49:24PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding t=
he
> arity of the called function.

What is the difference between this and the patch I applied the other
day?

--gqUrV6DUXoHnB0ku
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCVZfAAoJELSic+t+oim9mNkQAJzpxYPkBF49Qv88qzBnBeFZ
PVubj8VLfgWrp/YnRUC0fIFpW5d5Z81j0GFlWtVmxrWxIkr9VGT7bLNfqNwPdXhd
Wk2KwheLQ16qfqB2sndoX2lS0K7N/49K73t+H0AOoNC2JQHWsISvLeJiqqJ9wz0I
9AZt8KIXqlQadl/dVApUaodpnAG6OsAYNQ+gYZxFrONTPp+YeDzkoxc6RopjZZ3U
1HeoF83OM6xp7D4rzjBzpjau1eEVP0Hp5PZ0N3ECC5glR+JRABiwWbMbfayIdDId
Ff/qw4XtrsZZ+oto0ERVOAFlS6hPa5d6CvnPtfff6ZPhu8Q3mm/14fKLPx43g+7a
SA++xoJx/V3euevjzUlMgT5ihNq7KrC9ubXNfl1dTC75vVPMU2/VcQ7pbcMBJoJW
ZO3fmyvmn+HFRCF5ZTWgMIXDMvjOa/pnkuosVeLsUOw8owneU7nRt4y9t12bpKil
zGYt3vv6fdirMA5SaL4foQKK/W8BodRRWyI+fgSRRHSCfHJ0CuFKPcLPjGycfjVt
gFfpCYVkxVj3QFSYXEgGofCsVui1oob6R4Li8WySFS9r0JGbv/ZNUKksajuAiS3q
SCICQLWC54xhAQLz4pfYnXEqo8OAcq2RWxf/8m5SXbR0vkxEQSsjJGr8rcASX++q
E7ozOEAvEaXOYEOojBLO
=28+c
-----END PGP SIGNATURE-----

--gqUrV6DUXoHnB0ku--
