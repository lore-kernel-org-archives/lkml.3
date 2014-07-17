Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaGQUvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:51:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:35208 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaGQUvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:51:20 -0400
Date: Thu, 17 Jul 2014 22:51:15 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        arnd@arndb.de, carlos.chinea@nokia.com
Subject: Re: [PATCH 1/4] drivers/hsi/controllers/omap_ssi{,_port}.c: fix
 failure checks
Message-ID: <20140717205114.GC13832@earth.universe>
References: <1405605234-13559-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xesSdrSSBC0PokLI"
Content-Disposition: inline
In-Reply-To: <1405605234-13559-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xesSdrSSBC0PokLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 17, 2014 at 04:53:54PM +0300, Andrey Utkin wrote:
> 1.
>=20
> [linux-3.16-rc5/drivers/hsi/controllers/omap_ssi.c:357]: (style) Checking=
 if
> unsigned variable 'gdd_irq' is less than zero.
>=20
> Source code is
>=20
>     omap_ssi->gdd_irq =3D platform_get_irq_byname(pd, "gdd_mpu");
>     if (omap_ssi->gdd_irq < 0) {
>=20
> 2.
>=20
> [linux-3.16-rc5/drivers/hsi/controllers/omap_ssi_port.c:1017]: (style) Ch=
ecking
> if unsigned variable 'irq' is less than zero.
>=20
> Source code is
>=20
>     omap_port->irq =3D platform_get_irq(pd, 0);
>     if (omap_port->irq < 0) {
>=20
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D80441
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

applied to my for-next branch:

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/commit/?h=3D=
for-next&id=3Db74d4954ae6a6799f7ee832bc377795ab506f4b1

-- Sebastian

--xesSdrSSBC0PokLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTyDdCAAoJENju1/PIO/qagvAP/RPRctwoxk+rMoVTAnXY3Qj6
2JPkVuLh9I74zsuFKxx0AAtqtkKlEUPLtVq/jvykS4TdMBFcXUOXoMc/0e8KfW9G
r7lI+C5lltzrS8vlNl+SiVRXgHoil5S5YdV4QjDjE+9bgsNkHjQPJsbiJgMfAC57
4MM55fBC94K18Qo0aLErSBQIUsreBtCzLTCJgTCASRfMM2gHKxpl9zLYmyEzW9iV
19FuttrP+OzwbhnmBtLLpuuaFT8rwIxbvS3VbdzAGXf6Ui0W9hDrTkECi4mkcM18
D0Wodr6ldCwjsNi2TrUX81wYi+yNQn1gBNox1jho8EZU7gmR23ZM3v4yC8XZLGrn
+KU+kH9E3zremaDOBJwknM7Z5d0bTW24yAPw0QXgiKRmUY3sFgFHTadeSYUGAWLZ
seKoo4xcJ9AGoiEcP6aiO9WKNqI698mlVE8cg0GbG6ivGN1a+G5ASEgagmwTFSxX
NmIWgyJeSxGeyvOrYL0CpPkxg09Z+iT8sipj70ybnUurVwhPYKby6lgA9JLh8eZT
T2zGPbknLTmAGXuzKNyvvf/HLKgzen7JzEAinh6FGcV6GMrYwj0h197l83k9KY6l
P3SAPlDp726WfsmRLqmYH2+SeDy5aGZ/b+egz/wy0zJYF1IG8Hohc3He2OGkCjfo
CuCYBmTocDfldDzV3+Tv
=O2XJ
-----END PGP SIGNATURE-----

--xesSdrSSBC0PokLI--
