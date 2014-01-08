Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaAHRPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:15:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48780 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbaAHRPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:15:46 -0500
Date: Wed, 8 Jan 2014 17:15:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>
Message-ID: <20140108171538.GJ31886@sirena.org.uk>
References: <002001cf0c0d$461abfa0$d2503ee0$%han@samsung.com>
 <002101cf0c0d$6d90d470$48b27d50$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E5VVhyEnnqAVmNcK"
Content-Disposition: inline
In-Reply-To: <002101cf0c0d$6d90d470$48b27d50$%han@samsung.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: mc13892: Fix checkpatch issue
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E5VVhyEnnqAVmNcK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2014 at 10:03:22AM +0900, Jingoo Han wrote:
> Fix the following checkpatch warnings.
>=20
>   WARNING: Avoid unnecessary line continuations
>   WARNING: line over 80 characters

This doesn't apply against current code, the same changes have already
been made by you in October.

--E5VVhyEnnqAVmNcK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzYe3AAoJELSic+t+oim93NUP/0qUjydqjLh2CcqfX/mjvbl2
yNfOwxtfdTY5Dl/iKmMslslBH8/R9yHoZ/MbB+1uKa+YuYP/XTYrh2xGH4RwV5Pc
lpm5cL6BzFcDvYTheGo1dwRt+n0outuFzQXuw0LizLki9E1fnhaOF5SDXOcZk4Fy
CIbBtatbFf3F3i+jE2Cyx02973Ej2JNglf1tx+1JgToRz501MtKIgmsubqkLiTST
N87Rhd5vHZC+iv13ylTSf+V1Oka+HKgZqmF3536zdkC64scyJwxpMJ3baiDcr/uC
UpWDtBJ9zFg+x/0DdInclKQgdANcO3DRe/wupHxIfwXcQPXQt8BlvLoLPVQWDbfr
cGJsp6gG9czvOeb+M97Bz2ZXBi+j1KS8XfHchtTZrHGQDX+6Wnf54MVWSiSRYn+k
yOGidILCIyqNxDEJ0xzwVEBw3VO4PDn1HCKWiEFfriBL7cBvxCWqYEp46e9xSgPv
lVnyA+ly62NvFkpiH18Hg8cyGnRtoE09jdRYLqiuOkXzg68+lDttNou8JrX+fvdA
BwxnsBiOFK7dVWdrsn/qdZvdCx6dJyLRKeZ19WeiOjBBA8dSa4u2UO17PxQ8RBY7
p1O4UhaObr+Bfy31MhoLmiAgtbt5GkcWQvy20UWuK1oi6lFy8HIObfTF2Tz6x6tl
6ar9SHhVoQrymeQb6x28
=dv/W
-----END PGP SIGNATURE-----

--E5VVhyEnnqAVmNcK--
