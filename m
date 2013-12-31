Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3LaMeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 07:34:25 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40598 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3LaMeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 07:34:24 -0500
Date: Tue, 31 Dec 2013 12:34:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20131231123420.GR31886@sirena.org.uk>
References: <1388428882-28217-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fRTiclqxXzPSgD3k"
Content-Disposition: inline
In-Reply-To: <1388428882-28217-1-git-send-email-festevam@gmail.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: pfuze100-regulator: Fix MODULE_ALIAS()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fRTiclqxXzPSgD3k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 30, 2013 at 04:41:22PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> We should use 'platform' in the MODULE_ALIAS for the regulator.

Applied, thanks.

--fRTiclqxXzPSgD3k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwrnJAAoJELSic+t+oim9TKgP/0GpS1bZ6tfAJgeQ6TfPrAEl
gh+2EjyL0+j0Fk4M/jpCrwyjYGEPzSS9fQIxGMOw7O5qzU4GVBvlmGQkTcBCrkF7
BIlPvEU7zPasrCuWIhdJog5DICUoaGalPEiq0fXhwuoSYaAWkV2XrspUH17am/H8
NEpgm/fCXdJSsJaUFaP+YCU4Wbc8ZNyYC6Pxle/QCCBa4a1rQn3zec4HZTrHPXCr
ZwMKrpAaB9E3L6H+x+17Q6dVJnKQbQcnFvom3H+Lk4ohRMNAughBGjpgomiZg2J0
LF3/aZCw4NG0jCqf9K1vhR3uNWfeJvzmC2LynNugAEwFqSJq0SXjOPI60u5eeFXy
BM+tTwDwIbTJQbMdljx9gZiQCqAhaQFkH5L2uJF1aLkMur2jdE04A0tK29rboVR5
RerZ6ii0ewpS69787vdmpt3P7cjRj9Y16sOP7g/gKKHrGfnowoSwF0QkWsVCO0By
3IrhClzc/VCtj9U8V49HYj9HhF38AAtwCB1wwWRo4RE9+AwEx7j7eYKuSKoMECEE
VBfBTyQVphTfiMGgJZQQZzMHbyMsyjeQoK/IC0WlUZBY0Ndp8bVTEFrXacKoIgSE
I7+AA0aaTL/v8/WA96w0G5eif4YPpkgdq/rMksyV7L109m5uO3VHD2AejsVIN3bd
zck7SXn9e9tI1s/7UeI+
=blmJ
-----END PGP SIGNATURE-----

--fRTiclqxXzPSgD3k--
