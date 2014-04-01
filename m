Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaDALJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:09:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49833 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDALJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:09:58 -0400
Date: Tue, 1 Apr 2014 12:09:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20140401110941.GK2269@sirena.org.uk>
References: <5822859.Za3p9c1V74@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8VdhJeX3P1F5ipXj"
Content-Disposition: inline
In-Reply-To: <5822859.Za3p9c1V74@daeseok-laptop.cloud.net>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: adds missing braces in regmap_init()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8VdhJeX3P1F5ipXj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2014 at 07:46:43PM +0900, Daeseok Youn wrote:
>=20
> It need to add curly braces because the inner for "if" has
> two statements.

Applied, thanks.

--8VdhJeX3P1F5ipXj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOp5yAAoJELSic+t+oim9p0kP/jRCMc6+iNqp2sDT0XgDhjRi
/Zs1hkxEQnqDxvxFuvPodYvzRG6WaxRA12DDHWIfqMwMwH13bwM7g9C9oi8vb+xy
DAuyXlmTSQrQgiX+IJzkXDsvkn6QhYkfVJQs+ZtchtTVHr/fOrozyKEI8/JIRwAa
phG5NS+EA4E+eZwz5zi4TWqJ7zoJx3wDbFFmT8Jn8hFDvURTboZAzax7H6o9+hAQ
lKEcAP74I/6EwAzhDx3iuS06eEjMKaF4olV6IS4eIW3vW+t32iW2bRei3/ew7B0w
HnheK+1+vt9A3MASGn6IlACpCUnOK92MBh8jB34JkY7yl3mrZFYuqzJQUfWrI9JA
2ct6XevgEL4cQMo/NS1fL9kgCiFXFggU6hrl1VcE+CLom1xIzFFiAYSxGk6r/Yaw
VZg6CKE5r8FQU6r7z3pUYolqNAiAhu/wJFejrOruPK/WzqOYX7mXWjPlA5V7oIyN
uSDdRc/jnA2l7SMg3AckNsH53/ZDBqzGpuVpNiFe2MK0MM0MyB4hOCQUbGIavkQe
2cwah2B9xCIPsssLOe390G23onbYGGIVCBriczrGZ8E1Du5uAwKnQcj4PLfJ6YKA
HDcFD8OqNJYzOPTWvstjvcmUDZ3krNtYi4zZ2v5FJ0PhAdEKJlASZKuvEXHc0ruD
C/jUMODhh8cba+2ivw4e
=nCl9
-----END PGP SIGNATURE-----

--8VdhJeX3P1F5ipXj--
