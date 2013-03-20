Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3CTPZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:25:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52287 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3CTPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:25:35 -0400
Date: Thu, 21 Mar 2013 02:25:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Lartey <ian@slimlogic.co.uk>, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: linux-next: build failure after merge of the final tree (gpio
 tree relatred)
Message-Id: <20130321022524.37baf9fedb1848cdbdfc0eef@canb.auug.org.au>
In-Reply-To: <CACxGe6sZKRjSnwa-CHC1OhJoGP-ZQe4H2YbMYjDjNYcSdSyuow@mail.gmail.com>
References: <20130306114452.a041ab0737783f9730c1486e@canb.auug.org.au>
	<CACxGe6sZKRjSnwa-CHC1OhJoGP-ZQe4H2YbMYjDjNYcSdSyuow@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_02_25_24_+1100_1Wc0LShpCWl8Gme8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_02_25_24_+1100_1Wc0LShpCWl8Gme8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Wed, 6 Mar 2013 09:10:42 +0800 Grant Likely <grant.likely@secretlab.ca> =
wrote:
>
> On Wed, Mar 6, 2013 at 8:44 AM, Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> >
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >
> > drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_probe':
> > drivers/gpio/gpio-palmas.c:173:2: error: implicit declaration of functi=
on 'is_palmas_charger' [-Werror=3Dimplicit-function-declaration]
> > drivers/gpio/gpio-palmas.c:173:30: error: 'struct palmas' has no member=
 named 'product_id'
> >
> > Caused by commit 82d4d6637fdf ("gpio/palmas: add in GPIO support for
> > palmas charger").  I wonder if this was ever build tested. :-(
>=20
> Probably not. Looks like this driver doesn't get enabled without the
> associated option in MFD. I didn't go searching for it, so my build
> tests didn't catch it. I'll drop the patch from my tree. Sorry for the
> pain.

I am still having to revert this commit ....  :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Mar_2013_02_25_24_+1100_1Wc0LShpCWl8Gme8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSdTkAAoJEECxmPOUX5FEH6cP/RADQ4Ht+EBco0QQbYZ/9aaP
DfyU+9WQ/mwxbugqZ1X5c5w35VFrhbZOQFoC91J9RN6X+TG5uXZUWiOVqkhi6KWE
CgR4JTm+MIAwt2/9TwO3FfIOGOiMaJpemf0Ff0FuaRIk0x6GG57Uctq+YQLC6cTc
1LFJUEH4NTagnu/pgs7llxE/4JNo+LFzUdZo0s2arzs7ONdHR1cb7dY13SkhRasp
BtAw7yp35AVC9m+ddklHGwGDbgqzyESyPV20urBaw7uIu79lkgWoEJQqrcEeFd6D
aMnOYmZeM+kGYj+0YRX/3E4nWVNi2bLIZLUIG3DDm5v2ztLeumzSHSmraHjgs4d1
jXmLGuLLwt0QEGEI56KZm9E8bMfwUP7zydQDL1zF2Y9qRLYIQMXMDuVkKRJYhKIK
pkwQiwLu6tOh6xqsvdr5vRKlS7HIlHoPol0UHVRs4I5Ia4LzvsgUfhz6YrtobTOG
2/AJVg4hsKweY4ATsz1T6eC6ZyVKwe1UgNb4/y9Dc4xdPkxiimTTGNJDONnXxSaU
CGVo2wRiAO0a2Q+UXwlp2rhIyaV0lURNE5DDPF2eYR1tVri7KbaVwQNJMYKFWRNq
1PWqheFmV1iLJ9PUmc+HqtdRR/HnGfVuWInKJLeCX7vR6DQTTgS9PD06+BX8+iA1
lF3ERZog9ttkSTvjQork
=nFjn
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_02_25_24_+1100_1Wc0LShpCWl8Gme8--
