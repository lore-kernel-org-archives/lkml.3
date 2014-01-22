Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaAVUGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:06:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58328 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaAVUGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:06:09 -0500
Date: Wed, 22 Jan 2014 20:05:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140122200558.GA17314@sirena.org.uk>
References: <20140115113551.0eb13409@armhf>
 <20140115165152.0ad6e344@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r/WOGnZHPnL8Js0N"
Content-Disposition: inline
In-Reply-To: <20140115165152.0ad6e344@armhf>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 6/8] ASoC: simple-card: simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r/WOGnZHPnL8Js0N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2014 at 04:51:52PM +0100, Jean-Francois Moine wrote:
> In the non-DT sequence, the platform data is copied as a whole to the
> dynamic card info and the same pointer 'cinfo' is used to copy the
> platform information to the card.

Applied, thanks.

--r/WOGnZHPnL8Js0N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4CSjAAoJELSic+t+oim9pyoP/1/Lp/t8bAlypz+UztsPHsO2
GM1oU+F0vskE42MHA82M7MJp0VeL+vtgS5rhrRcH5COQgOxxzDn35+oKZti0WRoL
65bvC/lFJuKwFKeiZ2/IidtkkZ+e8AWaFIY9iUucqq++k2viTvazggCJssD/DTdA
lkUWbswJ/pZqMK7XryhgSu/BaRRbh1vtXV2yJTCGJB6vtPUOXhNhx2DPx4AynPnT
9BZ2DX/Z1rDAmGaU+dIkRUR6djO2B2n8G7rRApRWTUovmpWwPsocs7WS/g/zeawD
/xhsY5lK9yeWsR3ivfi4qR+fRfQ6VquBON9XiuDVVuMbaSbQGDLpr6xgMQP14tIf
IpOo0jvH84qdTnjUL6uHiS/kWkRFZq2pSXjQJ8p06FrgfVhoIHYP/mQPR5Mz2Ftu
SmwXIhH7awfFiNXEIu1eWuglIAQCpVbfD5CAti7K5TftzBOW2jSTp9cDUqv2ehoF
uestEohpnBo80IWvZDLFTv0ZPCw3/4OaxEy2LIYWLTzOpz2/hcwG5q6z+clO9a+p
nY3EUi7DwMSAqb+2nR27KLhR74qgJA3JBjQVYq5FrOd88VYPFrA+Umq9VeYF3JWG
CmNDM5jSWPZ5yuRLmYG1Rr9xEINAPCXkrUYEO8fOuYcZwo+T6PR68/oZmw0nl+9W
mXgEE211ZBshw4Vu5Z8T
=1KuS
-----END PGP SIGNATURE-----

--r/WOGnZHPnL8Js0N--
