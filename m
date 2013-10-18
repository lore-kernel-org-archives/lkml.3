Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3JRARw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:17:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40143 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3JRARu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:17:50 -0400
Date: Fri, 18 Oct 2013 01:17:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20131018001744.GE2443@sirena.org.uk>
References: <52607371.3060805@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="23Cox7P1v+d4VROS"
Content-Disposition: inline
In-Reply-To: <52607371.3060805@infradead.org>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] scripts/kernel-doc: make unknown function prototype a
 Warning instead of an Error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--23Cox7P1v+d4VROS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2013 at 04:32:01PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> When scripts/kernel-doc cannot understand a function prototype,
> it had been generating a fatal error and stopping immediately.
> Make this a Warning instead of an Error and keep going.

Thanks!

--23Cox7P1v+d4VROS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJSYH4kAAoJELSic+t+oim9YxYP9i3siJgb+wdhTaoMEooyaLAd
u15LzvKq3Hus2pnt2FkteG0qFJRRluMq2UySds21l6lYbItOateKCloNnfudCYFx
bEvUCpgf3Bn2TKMVdJSjttbmZ1N7mLkIdXhot5JeTWzTCiBkbABkLcnuLvceVlcw
hutkP7qo36Ow+QAbDjzl590jstLs3GNgsS4nJ3d0nTaeQ83cEVPulnQGdkz66lKg
a6mETxlfM6WrqvHdhm+zDpqtk17IpTKTcVh6Ti0H62siR+7ZYKoTR/xnPhWNm+jS
DK+tIA8Zv5lVQVTvWdBQ6YYZpmLjU0vKH/s4TywaQRw0a0bChNF49NRQN8n1eDhC
wCzbhz0XqXaiyEaeD7T1Emd/XKT1gNdAazhn4nSfl88WEhEMtXNiiy77s0wRiqnC
TLhLZHXvx7QdQBVTUFxgIYcbxu5EcQbXmB9ZoFiDgBoTTLwaP0dB7qtPZtL7hzwS
Bj2n+866FKjsFGWcsEmjOG8U8FXDfofIHQUslwEVgfVsIcvLqdmvk88MMnRM5kFS
Vxo2AzC7dJFS0BOkDOzMMoUsVZPj/y6fX1NePNqtttwk9TZFSpS40VJhQt7G1BSr
SqXdi8oeKZKmvr784DHXeKeosM9BVQRZBq/R2x8I849GKIYqStcQTw43sghOyHBX
ax5IJ6SROOfuy18Kltg=
=DO0R
-----END PGP SIGNATURE-----

--23Cox7P1v+d4VROS--
