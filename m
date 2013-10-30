Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3J3X2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:28:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54924 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3J3X2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:28:08 -0400
Date: Thu, 31 Oct 2013 10:27:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] Fix build without CONFIG_INPUT_LEDS [Was: mmotm
 2013-10-29-16-22 uploaded (input)]
Message-Id: <20131031102759.9feb5963975c5ce97193d6d5@canb.auug.org.au>
In-Reply-To: <20131030162334.f4d14c0b1b135cb38dce5dfb@linux-foundation.org>
References: <20131029232351.D2E6F31C173@corp2gmr1-1.hot.corp.google.com>
	<52706790.9090602@infradead.org>
	<20131030114624.GY5442@type.youpi.perso.aquilenet.fr>
	<20131031102012.599a7a256c48feed7832a208@canb.auug.org.au>
	<20131030162334.f4d14c0b1b135cb38dce5dfb@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Oct_2013_10_27_59_+1100_=ir5aj7e==4HWhYy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Oct_2013_10_27_59_+1100_=ir5aj7e==4HWhYy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 30 Oct 2013 16:23:34 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>=20
> It needs this as well.
>=20
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix-fix
>=20
> use IS_ENABLED to pick up CONFIG_INPUT_LEDS=3Dm
>=20
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: John Crispin <blogic@openwrt.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  include/linux/input.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff -puN include/linux/input.h~input-route-kbd-leds-through-the-generic-=
leds-layer-fix-fix include/linux/input.h
> --- a/include/linux/input.h~input-route-kbd-leds-through-the-generic-leds=
-layer-fix-fix
> +++ a/include/linux/input.h
> @@ -533,7 +533,7 @@ int input_ff_erase(struct input_dev *dev
>  int input_ff_create_memless(struct input_dev *dev, void *data,
>  		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
> =20
> -#ifdef CONFIG_INPUT_LEDS
> +#if IS_ENABLED(CONFIG_INPUT_LEDS)
> =20
>  int input_led_connect(struct input_dev *dev);
>  void input_led_disconnect(struct input_dev *dev);

Added.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_Oct_2013_10_27_59_+1100_=ir5aj7e==4HWhYy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScZYDAAoJEMDTa8Ir7ZwV86sP/jkJMfjS/Oawy0YOuF4cgNT4
FPTdV3TxVr68pn9IUgaVRPM/D2jeYHbVMwBoy0Xc3ZGj10hKCwEmomgfbPC0/hw4
Vtb8Sq6Yv6rH80FQ7cA1fkt42swH3AhSNkeFiFdbxADcHTFecLiWUc7pH8bUWgTC
cB5cEr7/N/xqyKQmNBUbl9DdA1VNENRk/EWXbgIO6JrR2HgsK9Qsq+zgqo75GP1s
urj64XCsQlD7lAqx5AKqedaqxFIg9S8nC7NXj/ynBEQOvrqqlTR0YxZrECzQf+Zo
1hrhMWLdSAVdtnuMB8Er0RdG06YLd7jmdiOwaX8QK7+bkp0Ar1DhY4nBm1dSKxhQ
fd3fscDMPhi+23UtGqRT+wg3tcX2qFO8bC+fxiH4nM8bdlrVbWpjf37iOz0Gp2iX
dYaGC1m0dhY9bII9nT6Jbz4tNPiAnZMw+T6U36ScnPqDssKDJxgkW1olG6ndQ0wK
LKsL8H7h15x8vebCYidMfKWGQLHwyp24a6p1TVX7MVkiFTWCIGJChRqv4SDQ5e/K
Qfvl7ahcX2B1vzjOId4CxUAFYfUijirzhzZ54pFZsz3fNmCsQwB7nwWG/0gP2dd6
h/SrKkgX3+zwFThxziMn+KZYH2tWZSrypTVjBsvuRkjIJtN+xWNOx7oTe3sPMY7I
EZCRM4wiqsObB8RgO4OE
=ELbV
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Oct_2013_10_27_59_+1100_=ir5aj7e==4HWhYy--
