Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaB0MKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:10:55 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:55149 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaB0MKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:10:53 -0500
Date: Thu, 27 Feb 2014 13:10:49 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: linux-next: manual merge of the pwm tree with the usb tree
Message-ID: <20140227121048.GC21422@ulmo.nvidia.com>
References: <20140227155613.16a690cf5423d4889d887273@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qtZFehHsKgwS5rPz"
Content-Disposition: inline
In-Reply-To: <20140227155613.16a690cf5423d4889d887273@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2014 at 03:56:13PM +1100, Stephen Rothwell wrote:
> Hi Thierry,
>=20
> Today's linux-next merge of the pwm tree got a conflict in
> arch/arm/Kconfig between commit f6723b569a67 ("usb: host: remove selects
> of USB_ARCH_HAS_?HCI") from the usb tree and commit 557fe99d9d49 ("pwm:
> Remove obsolete HAVE_PWM Kconfig symbol") from the pwm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc arch/arm/Kconfig
> index c85745d2d20a,cc6ce44064a2..000000000000
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@@ -628,7 -629,7 +625,6 @@@ config ARCH_LPC32X
>   	select CPU_ARM926T
>   	select GENERIC_CLOCKEVENTS
>   	select HAVE_IDE
> - 	select HAVE_PWM
>  -	select USB_ARCH_HAS_OHCI
>   	select USE_OF
>   	help
>   	  Support for the NXP LPC32XX family of processors

Looks good to me.

Thanks,
Thierry

--qtZFehHsKgwS5rPz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDytIAAoJEN0jrNd/PrOhq9QP/jlXyYyoj6bW4jUEbwl08EXc
6ZDwFM7va9foUwKukWfcuZ11AIFTf+24fC0FJYh4Q5LXrGxPSrwHRi9+j0Q17/S8
o8uUp4SfJKIPSxcBgJMMjOI4/WGnHTw6bL4p6+Wr4kyl7xNitSP7Z8g/SnAVUUCI
1IWwNzDF9z+dbdrsF7VXgzkSU7LKxd9QHVW17R/eISv3cIHbdkJSTJTPjX1LDJHR
18rA60JhLJ+G54AEP9KryB6dNmFcL9lZNHP/o54lyIqnFLJvj5MWViEzo/TCKf1S
6AUMXH+Yf7O8vvBO3iC/qLyXpdt0dAvsfcRecwMGeGLkZxMHlwYw9NwaGl4RaZwK
3J36MOrFJHEhBJC7zNeBNKpIn2rTVmaTMSntoDSUFF/ZtYmhukbVzHjD9+hUNGiq
2cr2LNbbVosxssaGEE7pGACE78MkKIW6jsgrQP+A3XqwXIrGurPXJEqpZR0DLN64
Q/4ASSV1KY4CD75AeEQvu1VP2277QMpRxQB9hdZuRZvuQBZ163e+bxTFLjmHj1WV
xn2ArDMhpvaX25ufEpKf7bf6/AKroqqqk6UAWAT1Nrzf66ispwliOFhtiVZMcZGY
trXV+10yxkthPyJL95AIghPC1KUuLL4aoveG0IanhBKoNUIM51MVQFsFqjl/cB3P
xLJ2pXZcYo27c1hknYuV
=6r4E
-----END PGP SIGNATURE-----

--qtZFehHsKgwS5rPz--
