Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbbAEUKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:10:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36732 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbbAEUKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:10:08 -0500
Date: Mon, 5 Jan 2015 20:09:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20150105200950.GH2634@sirena.org.uk>
References: <1420448659-9636-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dx9iWuMxHO1cCoFc"
Content-Disposition: inline
In-Reply-To: <1420448659-9636-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: fan53555: Constify struct regmap_config
 and slew_rates array
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dx9iWuMxHO1cCoFc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 10:04:19AM +0100, Krzysztof Kozlowski wrote:
> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const. Make const also
> slew_rates array.

Applied, thanks.

--Dx9iWuMxHO1cCoFc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqu+NAAoJECTWi3JdVIfQAT4H/2Rs3c+m0Nxap5CO9wmAuAsN
dTUZh6wQ+2MLdsKviVZeVWDvMHlZgZ6dl7Faf1KrrIfcxOcfNAv5tJ4s9VB2O0/5
KMhAihAmaJd9xzBWMuYyM0hnRjqnThdgPYoSPAqGHsvG22wTSLWXudzPxW+ykqk7
11tkvieIy+LQ86H50X/4V+97wqJNeaT9cvJOzsxZMDWZDaXC5hdj1cMwsZVN1GO6
3K3uazMWLCB7JOJ7QKtWQo3i87mni5u4QmPoSpZlULHUMrdAuYxQyhbyXJ5kY7/Y
3l+xm5cJfBzDWuhStP4kz/yOKkDJ1x84XFVndrD0ibA042N1f02ckKzJOzJe0s8=
=dLHp
-----END PGP SIGNATURE-----

--Dx9iWuMxHO1cCoFc--
