Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaAUS0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:26:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57675 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbaAUS0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:26:00 -0500
Date: Tue, 21 Jan 2014 18:25:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20140121182555.GO17314@sirena.org.uk>
References: <1390251236-25647-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CQBoIGqGA4YjUHlf"
Content-Disposition: inline
In-Reply-To: <1390251236-25647-1-git-send-email-festevam@gmail.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: pfuze100-regulator: Improve dev_info() message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CQBoIGqGA4YjUHlf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2014 at 06:53:56PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> 'lay' is not very meaningful, so use it 'layer' instead to let the dev_in=
fo()
> clearer.

Applied, thanks.

--CQBoIGqGA4YjUHlf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3ruwAAoJELSic+t+oim9osoP/1Wp+fpgC80qt1n2YE9ng3ah
iBX0Y6YqXuDSYEMKG5Sfd5WqkiXMN+05yLne4jHHYyefK+Eqo0jUyYZeFLIzZ2Wz
4P1cINHSq0ZJorvzYhFAnMBdBKFW8F+Zb2SYJW09nvRl0Do8vv9GQH0WVWiKrISO
yO0D7Z8wZUKCCegYUDJ0DeoUfZRpscHHHFLpttDyy2OqSBAA8oHYos3cDvKbnH/H
UHC9fXNtCxLHDbfn+KBeIPo0fm75Gcq77LJ+qtcAcSwjgF3ELOdEuG8WYNRI6e6J
CO46+KEGHdYRAwBAETFiN4rF0GAtWKYlTmS4TDsZbsIh76zX6BT5PoEzZoyr8sxP
rTJD8fEl3Vr9OX8B7CkuKUHNYnWCIYShf4KGqjm5wILvvxld4LfhrXUOim5Edxwa
nnpF4UPbh2zsTeCehihYl2/gPWZmNhXZfr2VN3qQP16iexvejmnuzzkSN6BKQGEO
yCfsBjcqbK7Gj0jjMN4K/va6hdsqd3hbL7+q3glVP+M/XDZ1tytkCQE170q5D99W
Qds/5v+y3Pb8TcEdqEYq83zp3J4hdPMe63q1E3fAHvLxM7oSe9kkjJuT+uMP06cN
gz4+c1So9S+CSTJGhbeT8lhQS1Pp6YP64B9PXBIIeP/I1wqLDScPdBrWZSJzBBjV
z3kIbxS1ARbwvDouXb8P
=X2f7
-----END PGP SIGNATURE-----

--CQBoIGqGA4YjUHlf--
