Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaGGHX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 03:23:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50711 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaGGHXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 03:23:54 -0400
Date: Mon, 7 Jul 2014 08:21:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: addy ke <addy.ke@rock-chips.com>, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, olof@lixom.net, hj@rock-chips.com,
        kever.yang@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, wei.luo@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>
Message-ID: <20140707072140.GB30458@sirena.org.uk>
References: <1403582852-9751-1-git-send-email-addy.ke@rock-chips.com>
 <20140704183249.GC14896@sirena.org.uk>
 <53B9FB1C.7080008@rock-chips.com>
 <5578791.jcBVzrGadW@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <5578791.jcBVzrGadW@diego>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] spi: add driver for Rockchip RK3xxx SoCs
 integrated SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 09:08:41AM +0200, Heiko St=FCbner wrote:
> Am Montag, 7. Juli 2014, 09:42:52 schrieb addy ke:

> > > Your DT binding defined some additional compatible strings, please add
> > > those to the driver.

> citing Mark Rutland (one of the dt maintainers):

> --
>   That's why I said in addition to the common one. I'd only expect the
>   driver to look for "rockchip,rk3066-spi", but a DTB could have:
>=20
>         compatible =3D "rockchip,rk3188-spi", "rockchip,rk3066-spi";
>=20
>   Seeding the DTBs with the extra strings early makes it more likely that
>   we can rely on them later. If we don't happen to need them they only
>   clutter some DTBs.
> --

> so it looks like the driver is doing the right thing right now

The driver will work but it's better to list the strings that are
supported explicitly if only to document that there's nothing specific
Linux should be doing for them.

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTukqBAAoJELSic+t+oim9y9YP/iBo9058c6SwePOuNDRAUk+N
rXpMex2zepuEd04RRELHgu09VP8haN6A2nnHzP2QLSKgfJLkXfzi1RAIIe+cEMi1
bMacdpvV0fViEEDX6i6RT/ZNCLhVzkLEn/hfyjTOhClEwgUGETDvjr34Sscl/Nzh
6Fli+Iw1Qex3QbtnD4II7QkVpPZcMdZCxRoeERL20I+pQVn9ysMit4hoYXMnp7pi
TIMo6GbtuxT1o1cvBq1fbqgOhgY53UvOmPZ+3RDmmZvrgagE4UMKO7fXRvf9AcjI
qv/C22TjmuvP5OL84f443FGnI+LyEUu6yQFRmjjvsVXNpVJ88oxv1vGnR8DrOlMy
jYtkazqk9+rowgv7zkqxqHR+5lgPp8tmGyaiAemp+jBJrXBbsg/XumGBV7Z1X8V5
4u8GEKaj48/ZYTB89S0kJOWKUJeB3AusY29bh5ttudvnoRRPjtZYCYWYlJOBQCZu
UjSiZD/QYb3dufqKDoCiynQnuMtxNBvmgxnvG83x5O4/jHZZrPsfJjVH9dYww0x3
x6u4p6IIQmpW2ENzEJm1e7cJ76ae2FmFqlfPjCjM0wJDLk6SEZUVEm8dcZ+yEmk+
I1jm/USNsyNGKgINUvHmqBadVlq+6VQMO59D/9LLbCLW7WC5kAL/cOJc+sfL8eiU
FExHYFzpCXOd0FTvG1/S
=lIvz
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
