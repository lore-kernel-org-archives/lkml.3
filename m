Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaA0UI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:08:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60286 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaA0UIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:08:23 -0500
Date: Mon, 27 Jan 2014 20:08:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140127200818.GM11841@sirena.org.uk>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-12-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HJXn/kF6DSjhJ2mL"
Content-Disposition: inline
In-Reply-To: <1390553044-11860-12-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 11/14] spi: rspi: Convert to
 clk_prepare_enable/disable_unprepare
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HJXn/kF6DSjhJ2mL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 09:44:01AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> Get the driver ready for the migration to the common clock framework by
> calling clk_prepare_enable() and clk_disable_unprepare().

Applied, thanks.

--HJXn/kF6DSjhJ2mL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5ryvAAoJELSic+t+oim95zgP/0X7hYaEYNfIANL9qSFu0eFE
7i5O+btT0M3uVZNjjQFLb31/vVgahpvs6BVsWizP6t3kSqoTnf9vf3M41zDPR6lU
UWfoEiGEvx90ez1tDvFD1gtOaJPR8frsBfjfYQQs808edat+YHdIXnsAB3HrwBLP
p+asXmRmEihncKrui/J0aL8TbnlesBpWf4jQsa6X1tQEc8qp7IDzgU6FOi3B4u0y
1ITpPgN5KwSgefjccgQQLxQ2KfKxf1kFbGbnPoFAJmw6X8Z2HhdsCxCFKMWvdT9X
ENzwKHiHtBpZo4cC/e5eC2hwtIF+b1fLLSSnRzT+CMgdKj8izobAmp7Q12Nb86ra
w/40soFedttjLW2O5OEQXH/DgCQYl8KCZJhL1H2Um8jazuY5CV5cvvMhTS5y8wWu
dI37VL+ZdXtSmGoHAI2iCTP8OqOF3E2/fVE2fLooeFZ1W3ZuudRrgH0rEpqCEI1o
YeHoy3SasrRrMghJ2GeuJTZp0cnVz8RIeCatOzHXik16oFzYXRl0kfQaseEtVw1A
uXFjhFotMudUM0T7c8znQenDzsJ7rLBZK+ZCi/UkZFZyLB2dSKfUxhnEZOx08aAu
vo6svGG1KVV1icY93ZBoIuqZ/4tmsRLUP1cki7z0KS9fuOUMNeTGstTPlVExbt5m
3wdYHu5iNTlyeBypVD96
=cRkz
-----END PGP SIGNATURE-----

--HJXn/kF6DSjhJ2mL--
