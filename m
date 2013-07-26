Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab3GZIvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:51:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40978 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab3GZIvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:51:39 -0400
Message-ID: <51F23892.7080001@ti.com>
Date: Fri, 26 Jul 2013 11:51:30 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, <gnurou@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v3] simplefb: add support for a8b8g8r8 pixel format
References: <1370590290-13467-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1370590290-13467-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="UkJW0d7osoSHmXtoEgTTUO8u1NO40pLUO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UkJW0d7osoSHmXtoEgTTUO8u1NO40pLUO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/06/13 10:31, Alexandre Courbot wrote:
> A framebuffer of this format is set up by SHIELD's bootloader.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Acked-by: Olof Johansson <olof@lixom.net>
> ---
> Changes from v2:
> - Fixed typo in format (Thanks Alexander van Heukelum!)
>=20
> Changes from v1:
> - Added description to motivate the change
> - Added ack
>=20
>  Documentation/devicetree/bindings/video/simple-framebuffer.txt | 1 +
>  drivers/video/simplefb.c                                       | 1 +
>  2 files changed, 2 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/video/simple-framebuffer=
=2Etxt b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> index 3ea4605..70c26f3 100644
> --- a/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> +++ b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
> @@ -12,6 +12,7 @@ Required properties:
>  - stride: The number of bytes in each line of the framebuffer.
>  - format: The format of the framebuffer surface. Valid values are:
>    - r5g6b5 (16-bit pixels, d[15:11]=3Dr, d[10:5]=3Dg, d[4:0]=3Db).
> +  - a8b8g8r8 (32-bit pixels, d[31:24]=3Da, d[23:16]=3Db, d[15:8]=3Dg, =
d[7:0]=3Dr).
> =20
>  Example:
> =20
> diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
> index e2e9e3e..f015482 100644
> --- a/drivers/video/simplefb.c
> +++ b/drivers/video/simplefb.c
> @@ -84,6 +84,7 @@ struct simplefb_format {
> =20
>  static struct simplefb_format simplefb_formats[] =3D {
>  	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
> +	{ "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {24, 8} },
>  };
> =20
>  struct simplefb_params {

Thanks, I've applied this into my 3.12/fbdev branch.

 Tomi



--UkJW0d7osoSHmXtoEgTTUO8u1NO40pLUO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR8jiSAAoJEPo9qoy8lh71fvwP/jBwbPD4RBtp5v4VoXy2+j5n
6nWWCMjSrgr1TVBhXb9gGxDhqnfY1rME+PGun8kmT16hr/NRtQftzXaAkuZPDCzw
LZBEnIC63OK5yjtBREISYIQzGu9nmsTMO0UpEjm4g7yvGfR8kM8Krg5KrFBfAQrI
arU8UhFfhIB4BtQxeT/+Qteso/CLo4m+rzh8mL8LOEPOZtAi9QHFlgF2InCxacd/
vCEIwZQ2PMiqmS8qYFOb+Djn7s6O4eFGYFfexEj62NFLFpU9Mmhu7gvSATRA5UCA
ItoUrGiczpiRzLsY0SIgyWQkD3eMRkq3RVi0AjKkrduy4pSRybJAYrJmaXGg6OaE
hIObMmnG4nrsJxkpUDx5aDSZkn23KpQo0e6HcaV2CZ0k8tgnFFCgcogUQNJDtIDD
nVWo/7RdylrUqb+h8NAfCHNI9/grDM98IpCXjCxCwS5lfEkJLi8UQzkm8jmOfOWE
LiR/kOD1gRtMEde6zEw0Ma8VWW5CJnEEknd/y16GCmGmrGivKiQ+dgZV8kZv52b8
3bca4y/UAIvaabxVIB1FHbdP2FkopyY4cjUwWg0jbbFoPynoKpTKDNavszZ3SZAN
TuX0z8mny9p0+1AZFSYAWISGVc9+EZ6GfuqAtuQFtXNaedXaTN/8tCvAUh8Wk2zD
9MxxXwN3ivXJ/oCkqSte
=95N3
-----END PGP SIGNATURE-----

--UkJW0d7osoSHmXtoEgTTUO8u1NO40pLUO--
