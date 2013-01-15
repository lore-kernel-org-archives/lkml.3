Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3AOTLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:11:19 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:54754 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3AOTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:11:18 -0500
Message-ID: <1358277072.1668.2.camel@kyv>
Subject: Re: [PATCH v2] mtd: vt8500: Add support for Wondermedia Serial
 Flash Controller
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tony Prisk <linux@prisktech.co.nz>
Cc: David Woodhouse <dwmw2@infradead.org>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 15 Jan 2013 21:11:12 +0200
In-Reply-To: <1358271907.31593.1.camel@gitbox>
References: <1356901207-13536-1-git-send-email-linux@prisktech.co.nz>
	 <1358261750.2731.148.camel@sauron.fi.intel.com>
	 <1358271907.31593.1.camel@gitbox>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-RLKBgFK/epAwi1lY6fRD"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RLKBgFK/epAwi1lY6fRD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-16 at 06:45 +1300, Tony Prisk wrote:
> On Tue, 2013-01-15 at 16:55 +0200, Artem Bityutskiy wrote:
> > On Mon, 2012-12-31 at 10:00 +1300, Tony Prisk wrote:
> > > This patch adds support for the Wondermedia serial flash controller
> > > found on WM8505, WM8650 and WM8850 SoCs.
> > >=20
> > > Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> > > ---
> > > v2: Whitespace tidyup
> >=20
> > Hi, would you please take a look at these warings, identified by aiaiai=
:
> >=20
> > Successfully built configuration "x86_64_defconfig,x86_64,", results:
> >=20
> > --- before_patching.log
> > +++ after_patching.log
> > @@ @@
> > +drivers/mtd/devices/wmt_sflash.c: In function =E2=80=98sf_read=E2=80=
=99:
> > +drivers/mtd/devices/wmt_sflash.c:425:9: warning: format =E2=80=98%d=E2=
=80=99 expects argument of type =E2=80=98int=E2=80=99, but argument 4 has t=
ype =E2=80=98size_t=E2=80=99 [-Wformat]
> > +drivers/mtd/devices/wmt_sflash.c: In function =E2=80=98sf_sector_write=
=E2=80=99:
> > +drivers/mtd/devices/wmt_sflash.c:442:16: warning: cast from pointer to=
 integer of different size [-Wpointer-to-int-cast]
> > +drivers/mtd/devices/wmt_sflash.c:442:24: warning: cast removes address=
 space of expression [sparse]
> > +drivers/mtd/devices/wmt_sflash.c:458:16: warning: cast to pointer from=
 integer of different size [-Wint-to-pointer-cast]
> > +drivers/mtd/devices/wmt_sflash.c:458:31: warning: incorrect type in ar=
gument 1 (different address spaces) [sparse]
> > +drivers/mtd/devices/wmt_sflash.c:458:31:    expected void volatile [no=
deref] <asn:2>*dst [sparse]
> > +drivers/mtd/devices/wmt_sflash.c:458:31:    got unsigned char [usertyp=
e] *<noident> [sparse]
> > +drivers/mtd/devices/wmt_sflash.c:465:17: warning: cast to pointer from=
 integer of different size [-Wint-to-pointer-cast]
> > +drivers/mtd/devices/wmt_sflash.c:465:39: warning: incorrect type in ar=
gument 1 (different address spaces) [sparse]
> > +drivers/mtd/devices/wmt_sflash.c:465:39:    expected void volatile [no=
deref] <asn:2>*dst [sparse]
> > +drivers/mtd/devices/wmt_sflash.c:465:39:    got unsigned char [usertyp=
e] *<noident> [sparse]
> >=20
>=20
> Apologies - This driver shouldn't be selectable for x86_64.
> It is an ARM driver for an embedded device. Will fix.

Note, there are also warnings when it is compiled for other platforms,
not only x86_64. Take a look at them. Also note, than many warnings come
from sparse, you probably just did not run it.

--=20
Best Regards,
Artem Bityutskiy

--=-RLKBgFK/epAwi1lY6fRD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ9anQAAoJECmIfjd9wqK0kncP/jD/9YJ6ZuGbsiQ1tqRRzWct
7/dm8Ds+HIZ1SWud58ctlAD6CqWZODf/Xzfyup94tgcpr24OTduygmeewSPV2lKn
B9miQFOKczuK9VW4nDbTsF83KOM5kWjspoJ9npVrilJe2912Lr5lr1gUbzo2AGzb
sf8M5PIps2kXmA3FL8KvmT/AFRhNcPlgV0r7e0pQtd0gVPVMtde7a63v/qSSdYD6
wKm6umY6zc8usHMjOqlWK6XMAsG05FIFhaLDtkAl7DKTcZplwJUYnrqGyTWudNpS
mhmtdzwMBb2c5ko/TUv+K9oWb5lzGJqTT9T/KEaGc9wPVjEI1l58nth7WVjRMjnh
qHM7CRiXP1/Njvp30BbyHDPTadPpy1z8KFKGM/7a/6JjBRmlHsUUWG2jdmQAb6RC
CDSCQXkwNuw1U4G9EbIxGZZhCu4pODh+CeB80bNsoGUpsbMup+FlrO2bzZYzJ2JU
9nhcWiyEc1ZCkWw9Ko+DGuqTyIJHf/b643An/Nbi2IVmnzImIuVHsgo/DP86Wxyt
QQKsf6ISGzc5xEJQabzNlIWA/pF2UnCa8VU3ulqZkUVbliEgujbogAGyf1ptpc93
JkfeIbtV4tQ8/OYzyBip+39n7828v1Od1mdLeYw0z4txrEj+IzPreBgSNsGfxTvd
zjtkoO626olTmLWfVVca
=mufj
-----END PGP SIGNATURE-----

--=-RLKBgFK/epAwi1lY6fRD--

