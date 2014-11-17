Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaKQTKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:10:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36504 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbaKQTKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:10:38 -0500
Date: Mon, 17 Nov 2014 13:10:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: George McCollister <george.mccollister@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Mark Brown <broonie@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Andrew Lunn <andrew@lunn.ch>, Hayato Suzuki <hytszk@gmail.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] of: Add vendor prefix for NovaTech LLC
Message-ID: <20141117191022.GB4857@saruman>
Reply-To: <balbi@ti.com>
References: <1416250957-11065-1-git-send-email-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <1416250957-11065-1-git-send-email-george.mccollister@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 01:02:34PM -0600, George McCollister wrote:
> For company details see:
> http://www.novatechweb.com
>=20
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Docu=
mentation/devicetree/bindings/vendor-prefixes.txt
> index 723999d..8f1462e 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -105,6 +105,7 @@ netgear	NETGEAR
>  newhaven	Newhaven Display International
>  nintendo	Nintendo
>  nokia	Nokia
> +novatech	NovaTech LLC
>  nvidia	NVIDIA
>  nxp	NXP Semiconductors
>  onnn	ON Semiconductor Corp.
> --=20
> 2.1.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUakgeAAoJEIaOsuA1yqREdpIQAJ99gXD/XaNemJk/4xguo390
whajlEYUJ0NNODSDleEPElnmb3quxC7SAUaHlT8ajPh7Zl0NEZ3iUpU9MULQeCw5
msZMRJwUnm0bey86Bb1FDEGxZjrfVi1/uXFOIxIIsnUr6JuAqvB/J53mfLgdruHi
4tjzdrLMBOZ6YnnfwrXWMKIivUi6i3iUUwelCUWemIZB+wt2WC5SRor6WC0vOJHo
v/HeG0vKRpVmG0/2dmhCfBzB02EAn1zv8qKzz7813Xsf0AmZ8aQZddEa5W/bn4gI
F0g3nE58ShAGZ+9PZsd14k44PGRPlp6WUgMmXsanfM2Mx9N9vp5Wj0Y1vNTVvhyK
0S7bZTYcTDx7ZsEA4E5UispXGHg9Hxaa0EQ+Zpf6utCQ6tAAptS8/beQIMwugyAd
4UbrtDs3saIACHEVD8IjU8X18OPIrRi5gu3UalcU9ZlD7q40P3TRyea/y7tSgclU
5yUAyM7qKiHZZMcQOKslzWV9MmImGx2bBqWt9MGhCtgnUrjn23PMdPXDHwwY6ekm
NsYZnTu0t9sUB4T0bUnUR+c4DF7fVdc0KBrFytssaQNbOFCqt09UhwEj4d2qV71y
XvKK2tMI83x40Nic5ChFurubjTiycodXQZW9H+5480lInWOWs7ulg6QTLRkIT7as
KGonL3Da3iib/smNUUzA
=DMSW
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
