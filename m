Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3DZPd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:33:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36175 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558Ab3DZPd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:33:56 -0400
Date: Fri, 26 Apr 2013 16:33:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: ab3100: Fix regulator register error handling
Message-ID: <20130426153354.GZ5019@opensource.wolfsonmicro.com>
References: <1366984629.31523.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="70fLfmUGd5x0AJTB"
Content-Disposition: inline
In-Reply-To: <1366984629.31523.1.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--70fLfmUGd5x0AJTB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2013 at 09:57:09PM +0800, Axel Lin wrote:
> Ensure to unregister all regulators before return error in probe().
>=20
> The regulator register order depends on the regulator ID pass to
> ab3100_regulator_register() function. Thus we need to scan ab3100_regulat=
or_desc
> and find the index of successfully registered regulators, or alternativel=
y just
> call ab3100_regulators_remove() to unregister all registered regulators.

Applied, thanks.

--70fLfmUGd5x0AJTB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRep5VAAoJELSic+t+oim9/XcP/iCNZV7S1juKsavnymZ/uPLu
hpewWKFWZmZFoFKR/wLhShkzjr5qqrRrJkJt33vArAlEKQl749lMaIcFgZ7IqjhE
l9AwBNdnPyIQDfhR77K1RVxpY8GULWtNnNnw3AuD7QFF2VohqLInZyonLrzFvmUH
+aQMU324f/UptSds5jS62C4mKEVP86p5BSEGqji43ZcI5bbJJP/WWJ2u1bvb80XO
6D4pxIjftUj7n8T0xmuFlKQ5g5xMstcV9Yg1LqAKDNAe96vmbYM6gqx9q0oLjrez
48Z9hKIXD8K3tT7RRk63cvpwxbBQxqMp4vNalnZX1HcF+ehkbsTgcO+UW3b2I7ee
JUXTcaxErX4iaXlfa7zeRpokaZQ9AS354aQRBsKns/KPqIoKwZL8oT3W+lbmyLg6
Smke8JoqKm5u12o5ibxrnQE0pWJnctEgpZG3ZDHu7TIkuFCDi2nmoIXnX2CKsXFK
ITiP2S7/zXF23REgIsmXxEupr6fxAolDxEURQ0ToOQjlcATIcg+HXRX10IcOvTha
n3PQBnU4zM510lWYPLxpeussRRj1a7vJGW0zAK5EL3jYoMHfbUPYA/hT7usYXvPC
YxG+nwJ9TvsLdqdZIBJAZTFFbWKGfPWFqElU3bGeatoX6Es1YgITHfqpZ9GXkvFl
l3tufSNvP8N6hpncvtBG
=zfdA
-----END PGP SIGNATURE-----

--70fLfmUGd5x0AJTB--
