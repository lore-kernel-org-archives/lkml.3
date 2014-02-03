Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaBCTf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:35:26 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52600 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753256AbaBCTfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:35:23 -0500
Date: Mon, 3 Feb 2014 20:34:31 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] ARM: dts: sun7i: Add GMAC clock node to sun7i DTSI
Message-ID: <20140203193431.GD25625@lukather>
References: <1391398346-5094-1-git-send-email-wens@csie.org>
 <1391398346-5094-3-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
Content-Disposition: inline
In-Reply-To: <1391398346-5094-3-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bajzpZikUji1w+G9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2014 at 11:32:20AM +0800, Chen-Yu Tsai wrote:
> The GMAC uses 1 of 2 sources for its transmit clock, depending on the
> PHY interface mode. Add both sources as dummy clocks, and as parents
> to the GMAC clock node.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index 1595e9a..fc7f470 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -314,6 +314,34 @@
>  		};
> =20
>  		/*
> +		 * The following two are dummy clocks, placeholders used
> +		 * on gmac_tx clock. The actual frequency and availability
> +		 * depends on the external PHY, operation mode and link
> +		 * speed.
> +		 */

If it depends on the external PHY, I guess that means it also depends
on the board, right? Or is the GMAC supposed to always have that clock
running at 25MHz, no matter what PHY is connected to it?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS7+9HAAoJEBx+YmzsjxAgQlQQAKshBcUSSlYHhXIGdt21xOgA
GIW5gRW29jBCQvJ2iOqYn1jQ1mFo8KM7SklMtr7cPEt4tmuylQYeUzPm2FgXOtrm
YCfcgGyWQNJPNrBehrigSpTm3JixDPhyp202HJKhnhxKDuJNAUmuXRl4UlG8op3M
vZ6WaomnSMLPwKN/oqlQ2735eXJUNKwOcyn3cz6R3cB6GTsLoty9QoWSDYZW1u8k
wAEg/+OcUx+EjcT6Lij6tazLmXedBERs3hUDnJ4x+BwbE/FOcreJHLxncN+v8G2V
F9PLi2RibHht3h9h+g2q93rrLTLTdUxVVlDnSxbB/MpD3hWRy6xIBlgL1J0uY1cd
HNtn5ak9goUIsb4yZefc/jV9iXFQqQglFNSA5ixdBOSkSG6jVRJiAwZ9UcikWUto
nS21RI4GPRzzSDTHdXBa/WYfuntu8jeAXfGriUGA6+3ptZ7Xk0dk4j9P04V7gL6A
O1NJAX9PzDE0lq3MJPCYf7y+gzS9M6yjZ2HzW8eW2H0Tf1VSwfwdq7L1PJXsJlb3
XtCKVaClqvoiHYfQXJQ8HLjsAh3wYtYWVMF8/9g5IsyQdOPOaEeV6JkqC7nG6nzQ
SgCuJCljciOvStqYZYOA55YjLFoltlbVlUhjOMIv/3pqhOGM1vfqg9Uh8HE8GJks
oDO1O4dNhPIPxXT5NPDB
=ModD
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
