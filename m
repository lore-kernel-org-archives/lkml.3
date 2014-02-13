Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaBMLQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:16:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41184 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaBMLQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:16:54 -0500
Date: Thu, 13 Feb 2014 11:16:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140213111648.GP28112@sirena.org.uk>
References: <9348920.79Ktlcbcai@phil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N7hiGSZV0P2B4+ho"
Content-Disposition: inline
In-Reply-To: <9348920.79Ktlcbcai@phil>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: gpio-regulator: fix forgotten gpios-states
 reading
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N7hiGSZV0P2B4+ho
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2014 at 12:48:52AM +0100, Heiko St=FCbner wrote:
> From: Heiko Stuebner <heiko.stuebner@bqreaders.com>

> Commit 934624d6e9f0 ("regulator: gpio-regulator: do not open-code counting
> and access of dt array elements") forgot to convert the recently added
> gpios-states property using the same pattern.

> Convert this instance to use the of-helpers too, resolving the build erro=
r.

This doesn't apply for me against either topic/gpio or a remerge of
-next that still has your patch on it (I applied a revert for yesterday
to avoid breakage in -next).  Can you please check and resend?

--N7hiGSZV0P2B4+ho
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/KmdAAoJELSic+t+oim95BgP/0gkl4RPyyIaJ19ztOUL/hOs
5sgCDn9JThT0wE4Sjqcmnxl00gH26R3rUpaGVx09kFaky88GTCnrrrMqMastiZiQ
VIz91LkO+xjHcFDoKixB3FeP0i5HpbW1DRu2ew72KBYEow3ReRCyCYgv933Q3gJ7
rjC/BImAazT33iXhk9krlBBXx4eVEgVQLPkeeDOpSV6sG70QsSUTn5n2SvRMU0l5
NpF49DGBabY581wTJKMCooiZy/jc4YjzHNppqS00jzAupqHIpmv7Cp2S7RN8VnT1
CvL33NseOmayLeRKd5F35SPX8iXqXEISTY421BjfCTzfTvEHBalgcQFc84bsIyyl
mQO6Ux3aG2MuRkVERAc7eoewCbEPrPbTfVppTaiV0aeeFfxfso1MFV8sHz9s6OEe
1SJG99bz/HjiyTa4HgmHMBXC3Ew+MQDQiW6IkPV2xtEhOqjZeBp8AYrk36VT5Qlf
eChsZfgX1Kyote0Ra8hsJZ5PQ9gqJRkz8gsBYYIsiklLgBkgQ22bBWlhumvY6U3d
Kk4TRhfqhNBDyztgCcaWij47k1qEbmcrM255Zm/K9ko9A3lJHJ/F3T4tlUK4WgaP
N7vJlLfREuQmTDDoQBumhgwwRPGbSZVtjKxQQJ30AdW1dI7MIn/Cbo661f5wyc6L
V9SwhVUcDGDETKzLyqZK
=DHaE
-----END PGP SIGNATURE-----

--N7hiGSZV0P2B4+ho--
