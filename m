Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161133AbaJ3RUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:20:11 -0400
Received: from down.free-electrons.com ([37.187.137.238]:52624 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934323AbaJ3RUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:20:05 -0400
Date: Thu, 30 Oct 2014 18:19:33 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com,
        mchehab@osg.samsung.com, crope@iki.fi, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20141030171933.GR21251@lukather>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
 <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxNrNKeE/ptr8Zbn"
Content-Disposition: inline
In-Reply-To: <544A9FEA.6020304@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wxNrNKeE/ptr8Zbn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 08:52:26PM +0200, Corentin LABBE wrote:
> On 10/21/14 21:11, Maxime Ripard wrote:
> > Hi Corentin,
> >=20
> > Thanks for resending it.
> >=20
> > On Sun, Oct 19, 2014 at 04:16:22PM +0200, LABBE Corentin wrote:
> >> Add support for the Security System included in Allwinner SoC A20.
> >> The Security System is a hardware cryptographic accelerator that suppo=
rt AES/MD5/SHA1/DES/3DES/PRNG algorithms.
> >>
> >> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> >> ---
> >>  drivers/crypto/Kconfig                    |  17 ++
> >> +static int sunxi_ss_aes_poll_atomic(struct ablkcipher_request *areq)
> >> +{
> >> +	u32 spaces;
> >> +	struct scatterlist *in_sg =3D areq->src;
> >> +	struct scatterlist *out_sg =3D areq->dst;
> >> +	void *src_addr;
> >> +	void *dst_addr;
> >> +	unsigned int ileft =3D areq->nbytes;
> >> +	unsigned int oleft =3D areq->nbytes;
> >> +	unsigned int todo;
> >> +	u32 *src32;
> >> +	u32 *dst32;
> >> +	u32 rx_cnt =3D 32;
> >> +	u32 tx_cnt =3D 0;
> >> +	int i;
> >> +
> >> +	src_addr =3D kmap_atomic(sg_page(in_sg)) + in_sg->offset;
> >=20
> > Where does this scatter_list is coming from? Can it even be allocated
> > in highmem?
> >=20
>=20
> With AF_ALG and cryptodev, the SG is in highmem. Verified with some
> PageHighMem().

Then fix AF_ALG and cryptodev, because all of the other drivers might
be affected.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wxNrNKeE/ptr8Zbn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUnMlAAoJEBx+YmzsjxAgL04P/3wLU5wri3bag19jOZt/ZcaX
y8p8EO0EGheG0mogxwjuVDmTW31RyYstrkgOivMAGy6WRabHSE0Lv0OcZsvplkxH
ivx07+9ZNE5A+LjIy6P8slgp64AAuzdtCh0cb4EUAQmN7G3O544qL20H3poK95Gi
xuFxoGatMz43WNDYA6Hhh+h7lX3VbIo8Qt8+ccHyttw7jdIld+gmadd27L/ySDx9
rJKhQuxuh9OB7k7BplujlZCf0TXKAAmBmRm17qzI+pA2SUMoKR/U70X1qoOqhj4y
jfis4Dd2UCGW+u0SWnx1+WrJKF4YbAapkeviO+dFZ4E+5C1kI+/JWPcAmnobCYXU
41b9KA3aNecnbeMuxUS4xNFdD+GFzPXIhwRN9DyEgRdZbR2f/IArlcyIiUbN2uIJ
d10g/KNL+V8vMISHJlEVdWjoMf3CtWIbl/6CJ3gZgUdGhkHjWicdATYdbBvYa739
N6LAWS2gEvh5jhSqey4pGuEotril3LeZsEVjB0pQy362IEsctPaH0IysXZgppfO7
a0neWUaQZemjXvp1PFLAhSBNUFLC2jT1b/sunS2T7Z3zQkdTzPzd5rHjtRMEB6qN
1h4Z5ujd3gsuMUAAn82Wf8N3C7AIg9KMu9CubjOdf+9z920E/n74n93LBT7KFw1n
yKV0dorV+2ex/2fNBxtT
=C1Uz
-----END PGP SIGNATURE-----

--wxNrNKeE/ptr8Zbn--
