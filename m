Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaJGQUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:20:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38889 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaJGQUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:20:40 -0400
Date: Tue, 7 Oct 2014 17:20:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20141007162017.GI4609@sirena.org.uk>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-5-git-send-email-mpa@pengutronix.de>
 <20141007120106.GY4609@sirena.org.uk>
 <20141007130737.GH5042@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v6ieFHm5OYqyo94Y"
Content-Disposition: inline
In-Reply-To: <20141007130737.GH5042@pengutronix.de>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] regulator: Use gpio_is_valid
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v6ieFHm5OYqyo94Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 07, 2014 at 03:07:37PM +0200, Markus Pargmann wrote:
> On Tue, Oct 07, 2014 at 01:01:06PM +0100, Mark Brown wrote:
> > On Mon, Oct 06, 2014 at 10:17:14PM +0200, Markus Pargmann wrote:
> > > Use gpio_is_valid instead of custom check.

> > Patches per driver please, this isn't just a mechanical transformation.

> Okay, but you mean just patches 4 and 5 and not patch 2 right?

Mostly, that was OK as it was just mechanical.

--v6ieFHm5OYqyo94Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNBLAAAoJECTWi3JdVIfQ8mMH+gOd80gj4AsBab0LfNy5hlKC
V7V5Pc97TizsaKEDDjB+IMM+VozXSHdlTzWe3pesc57rNpJhiTXujwKcUnNgZGHM
26tW+Cg2QDF+2cYi3+6ojpcaExn+Q/U7w7U3uckILbXDVx8x5BWLgvNQ/hrnjWXq
Z3L2yB2QkIZINiwkobvRZtfW1JZcJmadvwGoUqr2XbRhcwUMVF7h6xxSWRp8Www2
GwOAi37f+oFv0Gfq7N3hFgQPr2p8KgvJs4VQdmApSqzZtEdewFrSZFWQUipTy/bX
bJqSW7GamQsPq40+Loor6JdAMMYTABkorO2xNJhvf5Hhg5EOWgWV/KpZriXwmOU=
=6Ucz
-----END PGP SIGNATURE-----

--v6ieFHm5OYqyo94Y--
