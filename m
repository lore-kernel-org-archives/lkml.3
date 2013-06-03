Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3FCGgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 02:36:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34759 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3FCGgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 02:36:38 -0400
Date: Mon, 3 Jun 2013 16:36:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: linux-next: Tree for May 30
Message-Id: <20130603163633.e392dffdacc316b490b12a26@canb.auug.org.au>
In-Reply-To: <CAMuHMdXNzmJtfxzzt3kuzROzJmfsTKkp_4_8pdg=ahLv2LdU+Q@mail.gmail.com>
References: <20130530163334.105322d3c166b74165f1dad4@canb.auug.org.au>
	<CAMuHMdXNzmJtfxzzt3kuzROzJmfsTKkp_4_8pdg=ahLv2LdU+Q@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Jun_2013_16_36_33_+1000_DWatBfwGqjKZJIfQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Jun_2013_16_36_33_+1000_DWatBfwGqjKZJIfQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Thu, 30 May 2013 10:07:48 +0200 Geert Uytterhoeven <geert@linux-m68k.org=
> wrote:
>
> The following defconfigs fail without anything useful in the log:
>   - at91sam9g20_defconfig
>   - at91sam9261_defconfig
>   - at91sam9260_defconfig
>=20
> A manual run reveals why:
> Can't find default configuration "arch/arm/configs/at91sam9g20_defconfig"!
>=20
> This is due to the merge of several config files:
>=20
> commit b3f442b0eedbc20b5ce3f4a96530588d14901199
> Author: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Date:   Wed May 15 17:19:21 2013 +0200
>=20
>     ARM: at91: udpate defconfigs
>=20
>     Merge 9g20 with 9260 and 9g10 with 9261 as those SoCs can run from th=
e same
>     kernel even in non DT world.
>=20
>     Fix the sam9261ek to allow 9g10 and sam9261 to compile together.
>=20
>     Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.co=
m>
>     Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks for letting me know.  I have stopped those three configs from
being built.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Jun_2013_16_36_33_+1000_DWatBfwGqjKZJIfQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRrDlxAAoJEECxmPOUX5FEkysP/1Oox1RTRnhtLue3fJGpGNRS
KQb/Ucr4HvVeTSfFX6JWzQFlS83206xbjZS2emZZih9mZRZnNkfbqhAx63ABHXos
qjr6tDQSkINDmTMxvu1TY2iKniUTOzA323i1ZwO4YqjevVUTgoyDd570TPgKdzW5
HYYXrnVLl7RdjM53QQmHwc6mBDUjyMB++y9+z/c4SsyNTss+bL16pvx560z6Mh8v
rGUA0N2Hzb6KzsVJ5idyf0VLxi3JlzLIZhgd/26ZqkJGpJMDRDOJzI8JUBHyOIhP
boWX0C0Fh1qLOsJq/GQ5N1jyqlFfbffuYOJA5Z6vKrTzAnEaKialydHUlNLA+U8y
WnvNIDiPj9EEuF2VedAUTuEXAGBIAtO+lww0sIxJfk4Z2VrbI3ZOSCkOQRyh0fOa
/PH0qJh/93coYqEvjWsvYp41EPWVfMYVWgj/kUSs7y1jo6zbSdHTaZHZIOs6z640
gmpxZo2F30Fy/3bPIfMSqBWPE58yAZTe1k+qY1vHGb/1G0wflkQS+yumxM6j1LlF
5TY7v1eiPbCJQkoS8lRysSlChvIFehUi3TZGH9FUsfDkBUnOO/qFYg3qkMLkkckM
IIYhUZcv2kQh6P3V8iGte81s0RXIleN89rWObB3OZyxAwCfzVXNK74wguyBveHqk
dADVyanpXAqj146F3esy
=FwBT
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Jun_2013_16_36_33_+1000_DWatBfwGqjKZJIfQ--
