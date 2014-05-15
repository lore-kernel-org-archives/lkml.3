Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaEOOyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:54:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51764 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbaEOOyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:54:39 -0400
Date: Thu, 15 May 2014 09:53:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: davinci: remove checks for
 CONFIG_USB_MUSB_PERIPHERAL
Message-ID: <20140515145356.GA7360@saruman.home>
Reply-To: <balbi@ti.com>
References: <1400149025.20469.22.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <1400149025.20469.22.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 12:17:05PM +0200, Paul Bolle wrote:
> The Kconfig symbol USB_MUSB_PERIPHERAL was removed in v3.1. The last two
> checks for its macro now always evaluate to false. So remove these
> checks.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
> Eyeball tested only.
>=20
> This is just a straightforward cleanup. It does remove a comment. Is
> that comment still useful? Anyhow, I do wonder whether a proper fix is
> possible here. Perhaps Greg or Felipe knows: it is their commit
> 622859634a66 ("usb: musb: drop a gigantic amount of ifdeferry") that
> removed USB_MUSB_PERIPHERAL. On the other hand I noticed that config
> USB_MUSB_DAVINCI depends on BROKEN. So maybe properly fixing just this
> small problem doesn't buy us much.
>=20
>  arch/arm/mach-davinci/board-dm355-evm.c     | 4 ----
>  arch/arm/mach-davinci/board-dm355-leopard.c | 4 ----
>  2 files changed, 8 deletions(-)
>=20
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davi=
nci/board-dm355-evm.c
> index ecdc7d44fa70..06d63d5651f3 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -350,11 +350,7 @@ static struct davinci_mmc_config dm355evm_mmc_config=
 =3D {
>   * you have proper Mini-B or Mini-A cables (or Mini-A adapters)
>   * the ID pin won't need any help.
>   */
> -#ifdef CONFIG_USB_MUSB_PERIPHERAL
> -#define USB_ID_VALUE	0	/* ID pulled high; *should* float */
> -#else
>  #define USB_ID_VALUE	1	/* ID pulled low */
> -#endif
> =20
>  static struct spi_eeprom at25640a =3D {
>  	.byte_len	=3D SZ_64K / 8,
> diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-=
davinci/board-dm355-leopard.c
> index 43bacbf15314..680a7a2d9102 100644
> --- a/arch/arm/mach-davinci/board-dm355-leopard.c
> +++ b/arch/arm/mach-davinci/board-dm355-leopard.c
> @@ -208,11 +208,7 @@ static struct davinci_mmc_config dm355leopard_mmc_co=
nfig =3D {
>   * you have proper Mini-B or Mini-A cables (or Mini-A adapters)
>   * the ID pin won't need any help.
>   */
> -#ifdef CONFIG_USB_MUSB_PERIPHERAL
> -#define USB_ID_VALUE	0	/* ID pulled high; *should* float */
> -#else
>  #define USB_ID_VALUE	1	/* ID pulled low */
> -#endif
> =20
>  static struct spi_eeprom at25640a =3D {
>  	.byte_len	=3D SZ_64K / 8,
> --=20
> 1.9.0
>=20

--=20
balbi

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTdNUEAAoJEIaOsuA1yqRET0EQAIryQZnlwwkV//7yKMpzEcxi
oLc9ZBh0Y2tI0DuUqaGxBZq3ikQ1CHWcLkJ1ON1exfGvQJKAhxTGIYEqEtOMykMD
n4HJF5WkYYQ6YvPtz/c2gPfPGTepPI2L4yo37XAILyIlc2ltEwLhg0K/go3D9hNv
01U5lzjamkZa+Ccfen+CfiSfIcoLzcd5hQabqigNPiKJURYg0a4OldgCGhiZheyo
EfYLLREm7jXVBl8aPJbKU8pegom4uGCZ+PRVpzeKZKMKNilxkL4AyNDV76HLDzaH
KPRsWQzDaV2CX9pmvI2uGClyh8rD6PEHv/YTaAwaqXdoLsntGqpi96WEn2rOte2+
3RhO/sNNVML3MzwKDDZBNngWu4AitOjk9vs6cgfcwUzi8OFnLwKM3iOsJSvdjRrx
S7hZQPbYcJeUie7cNeklHCOS+Ty4o2j6uW36+x0/LkXi1TG0+jWV1ovRWTqK/T2x
nn9pgOPJkdDeZPSVoeh8VP2j3zKQB/SG48F+yz617RpFKw/TF10+SiBpClgHFk/C
uKB+o8glUp19C68cQtICqfgmT5IEm9sLM6yUq1KyOeLJO1xZ5K68J4bUQycDCwiw
a1yYULqMcAVE5Zq/rGysOcyppwr8t4yuGgEc+WRFO3Sui+93qX0fe7N9viYgH8KZ
zCZWzAKivnu+r+/+7z3i
=awZH
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
