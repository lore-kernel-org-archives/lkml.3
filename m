Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaGHIPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:15:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35495 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751649AbaGHIPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:15:05 -0400
Date: Tue, 8 Jul 2014 10:12:59 +0200
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
Message-ID: <20140708081259.GM13423@lukather>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404396906-25194-8-git-send-email-maxime.ripard@free-electrons.com>
 <F9547E0F-AB97-47E6-BA09-135EE4E1BC73@jcrosoft.com>
 <20140703145957.GH31996@lukather>
 <B425B925-B75E-4761-8CE6-9B12C5AC0469@jcrosoft.com>
 <20140704091443.545d1e08@bbrezillon>
 <20140704090645.GB13487@lukather>
 <20140707184001.GH9558@ns203013.ovh.net>
 <20140708080814.GL13423@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+ARLBH93C7pgvpZY"
Content-Disposition: inline
In-Reply-To: <20140708080814.GL13423@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+ARLBH93C7pgvpZY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 10:08:14AM +0200, Maxime Ripard wrote:
> On Mon, Jul 07, 2014 at 08:40:01PM +0200, Jean-Christophe PLAGNIOL-VILLAR=
D wrote:
> > > > > >> move this to an assembly file more easy to read than a C code
> > > > > >=20
> > > > > > Nope. It's a pain to pass variable to an external assembly file=
, and
> > > > > > this makes the use of global variable pretty much mandatory, wh=
ich is
> > > > > > definitely not great.
> > > > >=20
> > > > > Not at all I did for the PM slow clock code just write a function=
 and pas it as a parameter
> > > > > you have 3
> > > > >=20
> > > > > so basically you have to use the current and just pass at91_ramc_=
base[0], at91_ramc_base[1]
> > > > > and at91_rstc_base
> > > > > it=E2=80=99s 3 lignes of modification, if you have at91_ramc_base=
 and at91_ramc_base same
> > > > >=20
> > > >=20
> > > > Yes, retrieving function parameters from assembly code is not that
> > > > complicated (the first 4 pointer values are accessible through r0-r=
3),
> > > > but then you'll have to store your assembly file somewhere.
> > >=20
> > > Like I was saying, there's a strong preference for the inline
> > > assembly...
> >=20
> > inline is horrible to read and maintain NACK
> >=20
> > keep it in an assembly file it's so easy to read and follow
> >=20
> > and you just have to move the file existing to the driver/power
>=20
> Well, the whole rest of the kernel community feels otherwise.

Thinking a bit more about this, would using symbolic names instead of
the indices in the inline assembly work for you?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--+ARLBH93C7pgvpZY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTu6gLAAoJEBx+YmzsjxAgf0QP/3hpciXTIwKTwZkj074LbJV3
jCmZnijx4A5r+tOThdNDWT9slr0YlAqJVeI5Ilt8iTz8jC0+CjQiyXOvfqtVYAf5
YfglSy4KD4yuO26TKZdgturjKw0LhOxbuedIGx9N4x3xGapfHmVE+8IrVqojh8Vs
fk6Ykmd8pHUxfxHEucndiilzhUy3UDphP+cyGqwSe8st4rbwHflrS/epBXuW8QSu
V8jYw73AQ07vdGiNEjFelBUfOhYsiSFAx5unLfZEmE9bCHHBWN3yaL/fe/JIwtot
2mbeLUk4yKXAKZQ6Jr8yc56+UgcqLVfGLUphERIQwqIXvDi0yHRFQBK/wB2ceL5W
aWpvIERkeeXucwCdQGkWgjoCDumUr5EAy8dYceeRERWX53wNXsWRmcz63+n84YbT
GoryBsDGok6OOGCRV99W/ofeewImHNwd38LI5dAR/veI0lwXu1qQqlrOxn7yPloR
4FFRjdWWkIhUo+pIVrv7tl8QfLFQrOJBkb8DrNX40qmyrlsViEBfcK1cxi/75EF9
+J4eEP0PRZG6Nka4pOQ0c+Ka5jsWL3d9gB6RzH/tifBrYW32pFAo/IUlWdYjwmNW
3sGpvBc4Awa2y2HNUDXHsqXoLYIW/4Tt+vJBPtKxS1GN5BFimysHMhSLCZjPtxsQ
I0TCuqYqEq+GcYApLPPH
=vWRz
-----END PGP SIGNATURE-----

--+ARLBH93C7pgvpZY--
