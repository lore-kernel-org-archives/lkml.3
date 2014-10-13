Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbaJMNZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:25:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50795 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaJMNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:25:22 -0400
Date: Mon, 13 Oct 2014 15:25:01 +0200
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20141013132501.GF27755@sirena.org.uk>
References: <1412803148-21255-1-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D3V7sVjesNfTdM0Z"
Content-Disposition: inline
In-Reply-To: <1412803148-21255-1-git-send-email-b.galvani@gmail.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: rn5t618: Convert to new style DT parsing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D3V7sVjesNfTdM0Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 11:19:08PM +0200, Beniamino Galvani wrote:
> Use the simplified DT parsing method to remove some duplicated
> code.
>=20
> Since this is a MFD subdevice and its device object doesn't have an
> associated DT node, the configuration instance used to register the
> regulators has been changed to point to the parent device.
>=20
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  drivers/regulator/rn5t618-regulator.c | 51 +++--------------------------=
------
>  1 file changed, 4 insertions(+), 47 deletions(-)

Applied, thanks.  That's a particularly nice diffstat!

--D3V7sVjesNfTdM0Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO9KsAAoJECTWi3JdVIfQ2DMH/RzrUIfEU5Etx4TZ9OJFfQgx
UjAyimPYXMTYSb1WkvVIUGcKPZldmCmVgNNuB6LQD1gpMl6wAup3PtEAqhuCOHzV
SBu2hBrUF2e+Lb5YL0JnmsQTVGpYQSTWIJ5OermFEPdBahmX+xcCAoRgwyd0p+gX
CJ26nOa/lhLWZc+8YPOQidXvfH7NPCcV0HiBhhWZbqt/N3NgMRSZnbzrkm7hpqt4
EdbF7LWjesfuE4R84aJE4uvYJuI/aJ/nRspSacAmM8l2q8gIBYa2YHc63C+Zts9n
651n6qM0rQM/zMte/wZ5O365gGN9k3IOJUXvsjPfU/qql7xY7x7qfm0bis+/ypw=
=KCs1
-----END PGP SIGNATURE-----

--D3V7sVjesNfTdM0Z--
