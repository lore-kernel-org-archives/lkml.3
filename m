Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3K2Mgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:36:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41631 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3K2Mgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:36:42 -0500
Date: Fri, 29 Nov 2013 12:36:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brian Austin <brian.austin@cirrus.com>
Message-ID: <20131129123639.GZ27568@sirena.org.uk>
References: <20131129115407.53b288138930db24718cac49@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0k2ZE0YWsaeoufzj"
Content-Disposition: inline
In-Reply-To: <20131129115407.53b288138930db24718cac49@canb.auug.org.au>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0k2ZE0YWsaeoufzj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 29, 2013 at 11:54:07AM +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Fixed, thanks.

--0k2ZE0YWsaeoufzj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmIpUAAoJELSic+t+oim9agYQAILsEWhholQIHkEWG1YyX90+
iqBVIW6+aVl2RaWIrpYZ2vpyGoip6GVBZV94l4oZ1WsEJMHBEh7lFZn/z574iXey
xS+aLmv1UX6HfTjtYIeB0P2baCyLa9EAcZONPOaLWiE6Hj+N4GkFWTc+9WD4MG/b
6WDF6O5UxcI5kk6dvDHyOk1qwcAXTYF7cl/BtBjXGsSusV06t4foQe+4+S7hJ0dO
n7So+cTiLJPkENIh0cNWA/xiyN3JXiWCogkSFhy6K1sSuGIR/sM6p7aweuGw2jBS
6nI80eAqyWG+YeDK7Q6pnJqbGns3PyQEcShnucE13hUadHp3Mf+AMO2QtIa0Buan
5M9eUP30f1/iYU2TVo0wGXXqZF5DBNvA4McC4NRbTCGT0SvH7pbf2ON+1lwwX+i1
TM9aO0U/OCA6+gtnVQOWUAuDP/A9CYEReANeJ4MACJ5VWaCuSLfmTf2u4JdZ3PMu
nfoynJbGmByIT2nDonxz583tr4HksHV3TTkzLjCxv8xuksVZLb74TjLyKOIhMjpL
3BnCBVovPbahZhqGrqISA+nhmVGKM2Eeo0yA56PPrL2X0MAjAvOyP4LVwYAvhl7D
7zK3EIHdVTAY0oXeCXVTt63niYZtquzvK56xV090A4Epm+ZUMCk4pMFBzsn132RE
t2w70hTaXV0yy1TOYXAM
=xbVz
-----END PGP SIGNATURE-----

--0k2ZE0YWsaeoufzj--
