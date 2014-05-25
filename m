Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaEYNKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 09:10:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60941 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751415AbaEYNKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 09:10:08 -0400
Date: Sun, 25 May 2014 15:07:47 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Marek Vasut <marex@denx.de>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, LABBE Corentin <clabbe.montjoie@gmail.com>,
        linux-crypto@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, davem@davemloft.net
Subject: Re: [PATCH 1/3] dt: Add DT bindings documentation for SUNXI Security
 System
Message-ID: <20140525130747.GH10768@lukather>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com>
 <201405241321.32147.marex@denx.de>
 <5380F0E3.7020008@gmail.com>
 <201405242143.42693.marex@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G44BJl3Aq1QbV/QL"
Content-Disposition: inline
In-Reply-To: <201405242143.42693.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G44BJl3Aq1QbV/QL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 24, 2014 at 09:43:42PM +0200, Marek Vasut wrote:
> On Saturday, May 24, 2014 at 09:20:03 PM, Tomasz Figa wrote:
> > Hi Marek,
> >=20
> > On 24.05.2014 13:21, Marek Vasut wrote:
> > > On Thursday, May 22, 2014 at 05:09:54 PM, LABBE Corentin wrote:
> > >=20
> > > Missing commit message. Please fix this and send a V2.
> > >=20
> > >> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > >> ---
> > >>=20
> > >>  Documentation/devicetree/bindings/crypto/sunxi-ss.txt | 9 +++++++++
> > >>  1 file changed, 9 insertions(+)
> > >>  create mode 100644
> > >>  Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> > >>=20
> > >> diff --git a/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> > >> b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt new file mode
> > >> 100644
> > >> index 0000000..356563b
> > >> --- /dev/null
> > >> +++ b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> > >> @@ -0,0 +1,9 @@
> > >> +* Allwinner Security System found on A20 SoC
> > >> +
> > >> +Required properties:
> > >> +- compatible : Should be "allwinner,sun7i-a20-crypto".
> > >=20
> > > Why sun7i-a20 ? Is the crypto unit different in other sunxi chips ? C=
an
> > > that not be described by DT props ?
> >=20
> > A widely used convention is to define compatible strings after first
> > SoCs on which particular IP blocks appear. It is quite common among IP
> > blocks for which there is no well defined versioning scheme.
>=20
> Well yeah, that's fine. But in this case, "sun7i" is the entire group of =
CPUs=20
> manufactured by AW. I find that information redundant, the "allwinner,a20-
> crypto" would suffice. But I wonder if that IP block might have appeared =
even=20
> earlier ? Or if it is CPU family specific, thus "allwinner,sun7i-crypto" =
would=20
> be a better string ?

No. sun7i-a20-crypto is perfectly fine, and the pattern is used for
all the IPs. sun7i is the SoC family, A20 the actual SoC. In the A20
case, they're equivalent, it's not the case for other Allwinner
SoCs. And I definitely prefer consistency over plain mess. You might
see it differently, but that's not going to change.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--G44BJl3Aq1QbV/QL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgesjAAoJEBx+YmzsjxAgZrMP/RyhenToFyfpgTRulfZhFISQ
ffvPucwoQB2GFP+ThBuN9szc5v5ksPUfSGfaeRYtD7HMy4X5x2B8MYE9EVViawMv
V4Rgw+BEVAIIki32crKDRatSDAzX4Jb6UGPTbxq7M+K74S3hNw+94s2zJWPXgTIz
vlNh0wpRFXxoFkAiTRZMHz+jd6sKEFrOG/lOsrjm6xI8h5k9y1gTQGUo65WQ8oCe
0UZXVhLs/5U/BR27B5FV0xiWAhYYvJ61+LxOJSJuYwhFPwM5QWY4qKsWEedy5OrY
waXgTnAEwtNdYsZi/+/HjteYQQ2Sg48wVbtDDYmP0Z0sgXR+oTzf322StCDXoGRk
8U5l3HII9K3Z0VQVx5W0G6213Wk5ckA1j97jd5PsCw2d0JzCwPGfo+3fGJb+iCcM
p/dYvfA6aqKbuI30b1jtUstXjKo2F0Fvs/c1LWomDeq9LfUUUmktITmKs7mQKLrY
tITVOIirbonlDDlC1ivDHsapzocpJgX2kxgihTSREwiSOSEqH1T1bwFWMxV1AC+x
vbPOeDAtTbQrniM9G0TOxrIXEz4B0qcuQwueCuEH3bG2PiooyitMT7n+LZidjfgJ
BqOHd92geMr+mlW4nNarr2WPXq/z2vZ2WulULiUpOLQO4I7WNh3yVMPp2e2wPaxp
XFlysFwfQVkRQmDesDJf
=B1nM
-----END PGP SIGNATURE-----

--G44BJl3Aq1QbV/QL--
