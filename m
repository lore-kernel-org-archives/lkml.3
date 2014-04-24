Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaDXNAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:00:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37835 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753204AbaDXNAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:00:05 -0400
Date: Thu, 24 Apr 2014 14:59:04 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        arm@kernel.org
Subject: Re: [PATCH 5/5] ARM: sunxi: Remove sun4i and sun7i machine
 definitions
Message-ID: <20140424125904.GY24905@lukather>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com>
 <1398265476-29373-6-git-send-email-maxime.ripard@free-electrons.com>
 <1401022774.yKcHJAmPtb@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2MC+DK0smzICZJ/6"
Content-Disposition: inline
In-Reply-To: <1401022774.yKcHJAmPtb@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2MC+DK0smzICZJ/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 06:02:51PM +0200, Arnd Bergmann wrote:
> On Wednesday 23 April 2014 17:04:36 Maxime Ripard wrote:
> > =20
> > -static void __init sunxi_dt_init(void)
> > -{
> > -       of_platform_populate(NULL, of_default_bus_match_table, NULL, NU=
LL);
> > -}
> > -
> > -static const char * const sunxi_board_dt_compat[] =3D {
> > -       "allwinner,sun4i-a10",
> > -       "allwinner,sun5i-a10s",
> > -       "allwinner,sun5i-a13",
> > -       NULL,
> > -};
> > -
> > -DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
> > -       .init_machine   =3D sunxi_dt_init,
> > -       .dt_compat      =3D sunxi_board_dt_compat,
> > -MACHINE_END
> > -
> >  static const char * const sun6i_board_dt_compat[] =3D {
> >         "allwinner,sun6i-a31",
> >         NULL,
>=20
> I'd like to hear more opinions on this. We could either rely
> on the generic code, or we could keep the entry with just
> the .dt_compat line and the name, so /proc/cpuinfo contains
> a meaningful platform name.

Ah! I haven't thought of /proc/cpuinfo. I agree that having something
meaningful in there would be much better.

I'll respin the patch if Olof agrees.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2MC+DK0smzICZJ/6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTWQqYAAoJEBx+YmzsjxAgH3sQAK613d2GG64QcTQ4CkV5E9hD
3e4jb8vBd6vCk39ShDnW5atuTUgWavVSdhEh9ufCitEauVW7MqKmAC5n5+rPwodC
30AEb6zH1eOjno+Qg1s0u7T7DgLk6EnmUP/cCe5yhvdKl5JRFlvZ7EVUp0O9VI6K
OV+Ki2gOUCiaf28Kfw/x1sKaJ/S6/VbNZhdIS5qfr5POL0wMtUiyx104LVaDZ7b3
gsT2JumWROxrazLIQVqK9JskxN5p8G3hztqMduEdmyrI0XY223oGDTUQ4Y9yeuaE
3/DqZcp36bzdDIg4smWRpeW/UJbcXXN32Jlpi89FIwxuI80IIlzx4SS4X//vF5pb
07GlqHHTEp5y4xNFmocDVf6W5uAQ5h3rIxOROhAQQsrqg7jxE+wg8zcIklSRo3UH
90xnKX9UV0aZIFeOzErz8ueKZoKBvB7uaG7p8EOsC40o4/ErwHtgQh6/jvUINY2/
PSRNHQCuZAYQt7hJfaWcGXbRIfSY5pGrD8VhO30IExIfbVHM/ylCwpB8B35kXkvi
fZ0pJGU2veGp1Xe1sVwGoZld4PzyzIyc/lTkIyc3pnmsWwLLKpvQyUT8nTLXto0p
2tS5BXaT/o5TSMWMFAn4pmgBnPwVZdXEDqPXAni7m8ulmLRPfvnRQbSho4/oAZR4
vGo2wQmOXYvow5WVJ5li
=L4Wd
-----END PGP SIGNATURE-----

--2MC+DK0smzICZJ/6--
