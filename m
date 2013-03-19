Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3CSN05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:26:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32781 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3CSN0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:26:55 -0400
Message-ID: <51486798.6020708@ti.com>
Date: Tue, 19 Mar 2013 15:26:48 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP: remove "config FB_OMAP_CONSISTENT_DMA_SIZE"
References: <1363687677.1390.6.camel@x61.thuisdomein>
In-Reply-To: <1363687677.1390.6.camel@x61.thuisdomein>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigF01983F3486A559A77047ACC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigF01983F3486A559A77047ACC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On 2013-03-19 12:07, Paul Bolle wrote:
> The only user of Kconfig symbol FB_OMAP_CONSISTENT_DMA_SIZE got removed=

> in v3.8, with commit 6ba54ab4a49bbad736b0254aa6bdf0cb83013815 ("ARM:
> OMAP: Remove omap_init_consistent_dma_size()"). Remove this symbol too.=

>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Eyeball tested only.
>=20
>  drivers/video/omap/Kconfig | 11 -----------
>  1 file changed, 11 deletions(-)
>=20
> diff --git a/drivers/video/omap/Kconfig b/drivers/video/omap/Kconfig
> index e512581..0bc3a93 100644
> --- a/drivers/video/omap/Kconfig
> +++ b/drivers/video/omap/Kconfig
> @@ -39,17 +39,6 @@ config FB_OMAP_LCD_MIPID
>  	  the Mobile Industry Processor Interface DBI-C/DCS
>  	  specification. (Supported LCDs: Philips LPH8923, Sharp LS041Y3)
> =20
> -config FB_OMAP_CONSISTENT_DMA_SIZE
> -	int "Consistent DMA memory size (MB)"
> -	depends on FB_OMAP
> -	range 1 14
> -	default 2
> -	help
> -	  Increase the DMA consistent memory size according to your video
> -	  memory needs, for example if you want to use multiple planes.
> -	  The size must be 2MB aligned.
> -	  If unsure say 1.
> -
>  config FB_OMAP_DMA_TUNE
>          bool "Set DMA SDRAM access priority high"
>          depends on FB_OMAP
>=20

Thanks, I'll add this to omapdss tree.

 Tomi



--------------enigF01983F3486A559A77047ACC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRSGeYAAoJEPo9qoy8lh71V3QP/j5INq+LKbL/4PPq1p66C/q3
0utfLS5KjUOXIHVtyRhiFkTaVIqBUdVKH6RyQAQOOvFssiGfUBt1zLVj/fMAGvfy
ySTA+5KH3c+lYewrcLsSUVreXUGwGhmpxFMGDiCxZ40SFNr/P1ShHyVinN66q53C
7cUT7aDUmms0l3NNS9+TFZq9xdKMfST6PtMe6AOSyXgVzpzUEwgyeXxScV29e4TW
sV22p79eWClp1RYn/xWPdpknrdCbLxZNrqDhipP1FgFCwCW087a3wkK13rapOciJ
5g5qdDAy9oCGlxoP1EIZvwFEyO6gINUbbgkSD/aGS3Dm0iyqMnMd7WiBC538pte0
3gfkgPmr8eo1jlqj8CXWmp1NeZJtblto/eAFWgPLULomXUhpG9V1XZEPm70piupo
bI9H2yRR4JivXiHo9ebqYlyPG3n07EP0/yK+SQWhY59F7tR7YvNXjn7VYyHAMHKQ
cTzHf+YkxOcjB4mm+jRpC2n9MJd5hVNHm+mLtD+gQ0jkqPjcecYDOahdJKUEtLQz
9BWxNbkKZhNuUStZNTldc5lOqwxxyXoA/3ej/dvC+ivnX6ytYdPA8KfnDKfVGP84
lRJrrjClfljagKEXT/678mJIT7pWThNPmzn/xtHjtN8bT7aZOLeN0QBmPm/Ot+lM
oNG4BWhr/cWLQio+WASe
=YLHG
-----END PGP SIGNATURE-----

--------------enigF01983F3486A559A77047ACC--
