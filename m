Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbbAFPfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:35:06 -0500
Received: from down.free-electrons.com ([37.187.137.238]:44824 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754500AbbAFPfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:35:04 -0500
Date: Tue, 6 Jan 2015 16:33:04 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/3] dmaengine: imx-sdma: Declare slave capabilities for
 the generic code
Message-ID: <20150106153304.GO7853@lukather>
References: <1419873653-14411-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABYnUdqoGSokwVM+"
Content-Disposition: inline
In-Reply-To: <1419873653-14411-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ABYnUdqoGSokwVM+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 29, 2014 at 03:20:51PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> Since ecc19d17868be9c ("dmaengine: Add a warning for drivers not using the
> generic slave caps retrieval") the following warning is observed:
>=20
> [    0.224981] ------------[ cut here ]------------
> [    0.225013] WARNING: CPU: 0 PID: 1 at drivers/dma/dmaengine.c:830 dma_=
async_device_register+0x2a0/0x4c8()
> [    0.225023] this driver doesn't support generic slave capabilities rep=
orting
>=20
> Declare the slave capabilities to avoid such warning.
>=20
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ABYnUdqoGSokwVM+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrAAwAAoJEBx+YmzsjxAgZKkP/iZcqTGRuUeQmL7sfwpol/Oh
HfLzJYXY3tcpYscJ3lfzdDS8rTYAamk01MOfsic7vsJIEOKYhZXDX/P39v3RAaR7
ANSzZxE1mQrup7iFzdHOLp7Rh/SinKb4sapZu2HdBbl/969KFpx3H1ElaTDvBVl9
miyBaMY8sv11HxIy1qUo4R2d5l5yVrmMjajI/MvGiRzDFoGFlGbDYFXmR1HAUd6v
1bdgluwt8n4CD6UmFcUQY7aYZWcSuR9tymxmVImNEmzwNOIY3tyd0Z9uelA4EA84
i+yINnf+yAToi4obhxEUXTmxUyZym7rYbmryEIKr1ShUJ6IwRTtK8Yt9taXigeqL
TUPEaPhFJYFv4Y+Nilv1jxuIz0Bf3+aL9gpUuqTdmUR/ix75uo18CtT/n3KMSQGF
yoFrwVAIsYywU2KNQURJgYShPtqdjQ/V3cav7ClOS+xa9X1KAP4CeDLKcqzXm52y
kQPyT0ZNxdjJfTKeZjV6l3x/16c5ijLfTluicJgkidrYqbJJTv7LxXXmIRqZ8eKh
vHgT6UTlGUYzLkRkxeRLZJNuwTh6uHQBz1c1nTZ1i2TABIRGJnRTmlNadzThxkRh
SZNEQJwEvgj93YC1U83soYTA8AU0uQYYKzMlFLgySLobymEMrFJaBIKdo45FJhcw
EGUKAOXcaLnTKPXH0b2i
=fmnf
-----END PGP SIGNATURE-----

--ABYnUdqoGSokwVM+--
