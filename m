Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaJFSls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:41:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37333 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaJFSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:41:46 -0400
Date: Mon, 6 Oct 2014 19:41:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Message-ID: <20141006184119.GS4609@sirena.org.uk>
References: <1486422791.288728.1412617735622.JavaMail.open-xchange@oxbaltgw54.schlund.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BuGwuXnZwGGQ9GEc"
Content-Disposition: inline
In-Reply-To: <1486422791.288728.1412617735622.JavaMail.open-xchange@oxbaltgw54.schlund.de>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Regulator: Questions about constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BuGwuXnZwGGQ9GEc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 06, 2014 at 07:48:55PM +0200, Stefan Wahren wrote:

> Should a regulator driver rely on DT regulator constraints or not?

> In case the constraints are not set by DT, what is the recommend behavior of a
> regulator driver?

The regulator driver should just pass any constraints it gets to the
core, it shouldn't look at them or care if there are none.

--BuGwuXnZwGGQ9GEc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUMuJOAAoJECTWi3JdVIfQkQwH/0fXU86EJFCGRkVuDFrJy0+I
r6UqrZgV1sX+1EPBSG96AABKYNrXKyP81cFRKImsO9AEu4JoD1vWZnPKoyaUH30Z
kAZqkGo67s2V5G1f0FwiZB/DBDj/W3jQ9LYL7X5GtnCZQnkkPBJOLtqXVsnDfqNd
EjEF/eDTcJJnhWqdoaKCuqCTRjgNBk4rnOuBXCjmoKx3Xlh8L1n6yXRH210vi7Fg
JspjAVvnd5JDPyk2WNm+VUoGQOGFBq/GzZBym5MNbEgbN2YFDglF2Ium+2VMQG0d
MKbK9S8sC3wYTdctX97ryoBDJwtEds27zM4x419Bdb0uV3QtOhP+iqDGx2gI2Tg=
=FBJP
-----END PGP SIGNATURE-----

--BuGwuXnZwGGQ9GEc--
