Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaAOSvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:51:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54864 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaAOSvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:51:10 -0500
Date: Wed, 15 Jan 2014 18:50:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Message-ID: <20140115185055.GK15567@sirena.org.uk>
References: <20140115191831.5965d17e@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/sFzBD2UPiMqxCFT"
Content-Disposition: inline
In-Reply-To: <20140115191831.5965d17e@armhf>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Problems with simple-card
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/sFzBD2UPiMqxCFT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2014 at 07:18:31PM +0100, Jean-Francois Moine wrote:
> Xiubo,

Adding Morimoto-san.

> I did a mistake in the v1 of my 'ASoC: simple-card: simplify code': I
> did not initialize the pointer to the asoc_simple_card_dai_init()
> function when DT. Then, I fixed that, and the simple card does not work
> for me.
>=20
> First, without any 'format' in the DT, I get a fmt for each CPU / CODEC
> DAI: SND_SOC_DAIFMT_CBS_CFS is always set. Well, some code is executed
> for nothing, but this is not critical.
>=20
> The main problem is about sysclk: when there is no clock in the DT,
> you get the clock of the CPU or CODEC DAI. In my system, two clocks
> are declared in the controller CPU DAI, but there is no .set_sysclk
> pointer. So, snd_soc_dai_set_sysclk() returns -EINVAL and the card is
> not created.
>=20
> As I don't know why you need these fmt and sysclk, may you have a
> look at these problems?
>=20
> --=20
> Ken ar c'henta=F1	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
>=20

--/sFzBD2UPiMqxCFT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1tiMAAoJELSic+t+oim9k3YQAI7DXXd58bvI2m3PM9j2RUQv
emCPuJmDNb+HajVqWCZfz3x5KvvRs/d5ac9NTP4LklUymYsDjyaBXlhE6sq64z3Q
mjkyG/S77T0+uBf4cH2NUDjCtyMGco3592kCKkN+cEltfbj0kX4QU7ntMPfZMxOI
Ykh8n0QUl9HeN+beixJd2gXsSCZ1RBgOoMgO4uHhLpT0Jn4z8kXmVHqCSCbrnje0
5o7z7T5cMsYWMR6l5H99zLjQkjlhffxChcMa3pX/FngGllypRz5wULwyMA/LW1qH
nHkVo+boPKedLaJkfypPaU8RqGYi6WPIDxi0BOcY46eUl448zzgA8AEvVZR5xBKJ
MTDgPZ3d+pDCGmB5WWlPMytvelALQ9YW3AeJMtLuGFiX92cZXNGm/Zr+Vyy1DWCn
JKCyL4196rxzpqLBXcQ0BlPjrU4V/a/bphHWGfzdENaHGIKJOImYERw8/816z5aT
7xYtcsIwuM+n+xZtUSwa9qjETd3L060qUOcjMegDNlOaPEPnqC3t0PXxFGWH1djV
gg9V356QJ9xp6oKQvXRM7mJo4/cPmEn1mpZkuoEIbUy/9bJ6Vr/z3x7iom/n1PKk
zC4N1EawxxGUiEC5/UzFIPfOW+9z/UzofAu4R/zxVjGm5zMVB0D/w8qceNt1p+p5
sb5g8BZIuf35LaE+YpA9
=TrGu
-----END PGP SIGNATURE-----

--/sFzBD2UPiMqxCFT--
