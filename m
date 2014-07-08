Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaGHIKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:10:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35424 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753644AbaGHIKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:10:06 -0400
Date: Tue, 8 Jul 2014 10:08:14 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org, dbaryshkov@gmail.com,
        Nicolas FERRE <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        dwmw2@infradead.org, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/18] power: reset: Add AT91 reset driver
Message-ID: <20140708080814.GL13423@lukather>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404396906-25194-8-git-send-email-maxime.ripard@free-electrons.com>
 <F9547E0F-AB97-47E6-BA09-135EE4E1BC73@jcrosoft.com>
 <20140703145957.GH31996@lukather>
 <B425B925-B75E-4761-8CE6-9B12C5AC0469@jcrosoft.com>
 <20140704091443.545d1e08@bbrezillon>
 <20140704090645.GB13487@lukather>
 <20140707184001.GH9558@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pz0BBB9QxoYXlT+x"
Content-Disposition: inline
In-Reply-To: <20140707184001.GH9558@ns203013.ovh.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pz0BBB9QxoYXlT+x
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 08:40:01PM +0200, Jean-Christophe PLAGNIOL-VILLARD =
wrote:
> > > > >> move this to an assembly file more easy to read than a C code
> > > > >=20
> > > > > Nope. It's a pain to pass variable to an external assembly file, =
and
> > > > > this makes the use of global variable pretty much mandatory, whic=
h is
> > > > > definitely not great.
> > > >=20
> > > > Not at all I did for the PM slow clock code just write a function a=
nd pas it as a parameter
> > > > you have 3
> > > >=20
> > > > so basically you have to use the current and just pass at91_ramc_ba=
se[0], at91_ramc_base[1]
> > > > and at91_rstc_base
> > > > it=E2=80=99s 3 lignes of modification, if you have at91_ramc_base a=
nd at91_ramc_base same
> > > >=20
> > >=20
> > > Yes, retrieving function parameters from assembly code is not that
> > > complicated (the first 4 pointer values are accessible through r0-r3),
> > > but then you'll have to store your assembly file somewhere.
> >=20
> > Like I was saying, there's a strong preference for the inline
> > assembly...
>=20
> inline is horrible to read and maintain NACK
>=20
> keep it in an assembly file it's so easy to read and follow
>=20
> and you just have to move the file existing to the driver/power

Well, the whole rest of the kernel community feels otherwise.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Pz0BBB9QxoYXlT+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTu6buAAoJEBx+YmzsjxAgNwQP/1iLQ1rYI1+kyi6ZeWV4+ry9
L1Occiv7/KyggCZ6kQ2QcApITn4j6iPkTH1hxXKJl0WeYuLFJn1Cy95SUj5VlOgE
2JrUudQmU4XpyOYrKXSmXs0S6VBODfY9uaElxnKRJXeaFLQkB34h9dM7sCzGCTUo
5Lm2jAAUVZD67HausPj2cF7UqNdyd10yyISZ/ztP1U14nKhIOCzrMJqlhouRKzm8
zaLefg4fgmoFnW6KFAbEk4ZqKKtG6B5jTOgl7W3p/iM8ZjWZwp/StlW7cw7sTnsA
8mb5V+XgMAzr0ayURObN6qyT4lUO14GRvnq9Er2fIFi+wTKAmANOc4kwmbgtwu+S
r6ZPatgIkyUt4rJDSheXi7taaTqpI7JdEL5pKU8vFn7aAhusc085nVhnsoq6AhfV
Ds6sU3a8xrtA7XoJtSKEdHTEvUtXNWlLZg99Ba5MIV0XCTl4c/CvshjcbfrpB4Si
Ri4G3b4ZboBND9cNyFmdLhpNVJgDEDJBxVU1//dDLBK+8qzfn+wZM777/Nd8dy0V
v0s4v/dW5oVZJBQABIVt1g91dPgfbjjejL28YA4drk88tm7UuApM88aqzM8z5Ag9
CV2Ywp/LImyh1vH4dLIepqTaIlDuj3t2jTMOKrkozST47gRk29F2mOJCkQg+upob
ehKqtiA0mFgq806e7XQq
=0ofP
-----END PGP SIGNATURE-----

--Pz0BBB9QxoYXlT+x--
