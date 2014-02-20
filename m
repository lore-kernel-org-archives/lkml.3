Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaBTEFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 23:05:18 -0500
Received: from ozlabs.org ([203.10.76.45]:56605 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbaBTEFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 23:05:17 -0500
Date: Thu, 20 Feb 2014 15:05:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd-lj tree
Message-Id: <20140220150508.79bfff95fb5d93c651801ffd@canb.auug.org.au>
In-Reply-To: <20140217141446.454ab86eb19621fd397be6ed@canb.auug.org.au>
References: <20140214134217.aa7e1994b4cab7ee563c8307@canb.auug.org.au>
	<20140217141446.454ab86eb19621fd397be6ed@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Feb_2014_15_05_08_+1100_iQaUD1/+lJ_RPpJv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Feb_2014_15_05_08_+1100_iQaUD1/+lJ_RPpJv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Mon, 17 Feb 2014 14:14:46 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Fri, 14 Feb 2014 13:42:17 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the mfd-lj tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > In file included from drivers/mfd/max665x.c:19:0:
> > include/linux/mfd/max665x-private.h:31:1: error: expected ';', identifi=
er or '(' before 'struct'
> >  struct max665x_dev {
> >  ^
> >=20
> > Caused by commit e77bb5297293 ("mfd: max665x: Differentiate between
> > MAX665X devices").  Clearly never built by anyone :-(
> >=20
> > I have used the mfd-lj tree from next-20140210 again for today (since t=
he
> > other version had other problems).
>=20
> Still seeing this error.

Still ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Feb_2014_15_05_08_+1100_iQaUD1/+lJ_RPpJv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBX75AAoJEMDTa8Ir7ZwVA2UP/2wj5gpxTnj+gbeAAsq0ZEuy
1AoZ8GIrPU+A1hDM56DI/HXkNyNKULxOTFBGb1gUtmk8ZD32USXahkb3X9Un7RRw
sB8fKAm9240LlpP0QQ4eRlQIuBE5twWqu7rZjCDs3DNMK/CbnB1ElvAMek/Uq6fo
7thY4vioPih/HwOFHfLqL/O6tHieA2JH5xEmh7NDRwiyw6Qv1fE89JIh9UXQb9PI
44IryMIXBA3s6T9ZT1BMBA02FcfJPdwioCmIrxlmiKka9GmwWROwTGY1iDZ6ZtiY
klzFO4A+vXdXrg6xl9rNsrovtjtlIRE9U2ob1C6hnS19Tm+LDkylODeIqhoG2mV/
qh1ETQXGxL6GbzfG4k/ZBeWvK+MRi0xJLc/s9C1Oix6m7JU+6kdQf1zHUCxYCAe3
E/XNhWNL3B9pOmsvGKRZ6emxpLaKKLggvuGJPP8KOAhUScFkLILqGmpt44lFX3qv
tW6NX+M7B7BQe91U+kHK/wCEPbwboQ1ivenOYiSyAQTAkN5Y+IthH08zw+wmUJRa
WWp8AbhsgRMimd0pD1DWEZ2fwIEq3HGPSuLRVNaqWZ/ZUxHJPZ8zDrhjwSpnHHkv
cQj83p3+cFfjqY8QiM//Tp1YXTKkkK3Vl7IIgknTvD89pH/tT4M7Iqlh34C2jL4I
Qlkbo+Oh5VNPE9TSn8lU
=tba4
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Feb_2014_15_05_08_+1100_iQaUD1/+lJ_RPpJv--
