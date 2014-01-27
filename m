Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaA0Tx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:53:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60223 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaA0Tx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:53:57 -0500
Date: Mon, 27 Jan 2014 19:53:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, kuninori.morimoto.gx@renesas.com, rob@landley.net,
        perex@perex.cz, moinejf@free.fr, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140127195346.GY11841@sirena.org.uk>
References: <1390549386-4702-1-git-send-email-Li.Xiubo@freescale.com>
 <1390549386-4702-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MzUyxqdXrKJm2YZW"
Content-Disposition: inline
In-Reply-To: <1390549386-4702-5-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 4/7] ASoC: simple-card: add tdm slot supports
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MzUyxqdXrKJm2YZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 03:43:03PM +0800, Xiubo Li wrote:
> For some CPU/CODEC DAI devices the tdm slot maybe needed. This patch
> adds the tdm slot supporting for simple-card driver.
>=20
> The style of the tdm slot in DT:
>=20
> For instance:
>=20
> 	simple-tdm-slot =3D <0xffffffc 0xffffffc 2 0>;

It's not clear to me what such a definition for the TDM slots means - I
looked at the binding document as well and that didn't clarify.  We
would need some definition of what the above means, though I think most
likely the current definition is too specific and we need something more
generic.

--MzUyxqdXrKJm2YZW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5rlHAAoJELSic+t+oim9nkUP/2P2i1qHByL9tAZRANvlLITt
jmCuhJPG+ECB3AvZYDbuen14klEbOv+qCDMbWbw3YrOtQTWbz/aYIy0Mx4GAnb4g
T2ZILDUEMsbRarika3C/T7o0VkDz5yek3fnlCvUOqYvfB1HbuAQvJ8H2V6RRkkk+
zxXzR/viovniqjhqRC+oXCnEo3wwAuV1pkNggSvSLl6FbxXVjmGJE/R886LDdkp3
tv56GzGUunfoWS0fYlvd9esaqRLwjFUuEn1DK8fmH0R5sRlyh4gdkyEi0oQkPBA6
gTHWs3we+JRDRBqwPNxoM+Sb8J7hGl3Wd9/SI6tINkumbee7Y64YIrAOcvfOMkYA
DZqNfD3GHRgnO2UnfCMPXVE98zxGmhisv3fLT2FlthFh2gF028LGUM2VumIL2eIg
Wd4ysaWG3hTiV3cdOAbLiJw3Y1m/wofHWeYTCUyKqabzzeFeZpsYID40xFYHk0WT
5lFV6EgvYzNV660MgRk+/2uHaIEj8nNVwYOdiBcIwpdIdgCd1M+kQuHj3KMk6UXB
WiwcJrgSomyMH5uQtL34DlncWrgwpMwpEPgotLNkU0cK1pZ3rihm3z/GUEItVqqQ
wPHsZiprVa5lDhD7GHXXosgtiPTtTBcZ/NQ9LaQTHh5EtCHxnTmYTDUQwt/aQOwy
SxKG7A2fpUmfNJzWgmDT
=bS6u
-----END PGP SIGNATURE-----

--MzUyxqdXrKJm2YZW--
