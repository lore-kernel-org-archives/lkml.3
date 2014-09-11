Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaIKB2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 21:28:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49918 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbaIKB21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 21:28:27 -0400
Message-ID: <1410398894.13868.13.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 00/94] 3.2.62-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Date: Thu, 11 Sep 2014 02:28:14 +0100
In-Reply-To: <20140804204533.GA32681@roeck-us.net>
References: <lsq.1407170911.107020799@decadent.org.uk>
	 <20140804175544.GA7631@roeck-us.net>
	 <1407181779.8341.29.camel@deadeye.wl.decadent.org.uk>
	 <20140804204533.GA32681@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FE1ewPt6oSCzgzLlmCQc"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FE1ewPt6oSCzgzLlmCQc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-08-04 at 13:45 -0700, Guenter Roeck wrote:
> On Mon, Aug 04, 2014 at 08:49:39PM +0100, Ben Hutchings wrote:
> > On Mon, 2014-08-04 at 10:55 -0700, Guenter Roeck wrote:
> > > On Mon, Aug 04, 2014 at 05:48:31PM +0100, Ben Hutchings wrote:
> > > > This is the start of the stable review cycle for the 3.2.62 release=
.
> > > > There are 94 patches in this series, which will be posted as respon=
ses
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >=20
> > > > Responses should be made by Wed Aug 06 17:00:00 UTC 2014.
> > > > Anything received after that time might be too late.
> > > >=20
> > > Build results:
> > > 	total: 111 pass: 105 fail: 6
> > > Failed builds:
> > > 	microblaze:mmu_defconfig
> > > 	microblaze:nommu_defconfig
> > > 	mips:allmodconfig
> > > 	sparc64:allmodconfig
> > > 	xtensa:defconfig
> > > 	xtensa:allmodconfig
> > >=20
> > > Qemu tests all passed.
> > >=20
> > > This is a significant improvement over the previous versions, where w=
e used
> > > to see up to 10 build failures. The previously failing builds for uni=
core32
> > > and score now pass, as well as alpha:allmodconfig.
> >=20
> > Yes, I spent a little while digging out build fixes.
> >=20
> > I tried to fix the mips allmodconfig build, but failed - it needs
> > d3ce88431892, but that depends on 20082595d341, bef9ae3d883c, and
> > further changes I couldn't identify.=20
> >=20
> > I was unable to reproduce the sparc64 allmodconfig build failure, which
> > is in samples/hidraw - it built for me without warnings or errors.
> > Could you give me a bit more detail about the test setup?
> >=20
> Nothing special, really - Ubuntu 14.4 (previously 13.10), with gcc 4.6.3
> from kernel.org.
>=20
> This seems to be related to patch cbf1ef6 (sparc: use asm-generic version=
 of
> types.h). After backporting it, the build passes for me. The backport is
> attached in case you want to give it a try.
[...]

OK, I've queued this up with a comment on how it differs from the
upstream version.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-FE1ewPt6oSCzgzLlmCQc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVBD6tOe/yOyVhhEJAQqNOhAAzCFfQJl3cj+/VoJ9gdQrlHgQmB9WYs68
uJj+XD8O0ivxjPZml5MbKkq2mhepvckZ+bw2T5ECuChXXS7oLVYAMdtyjyxi86bv
Ir513++ppIopAdzoHcnpRK2sd4qyWZBH7AAEnA2c3hcB6DecuVjJYvcB8fLBgUh5
21wxUnwyAh2hCos6fV1iIImFvtHhbnoQBv4uNYb5qXJBwlmAVN0mTYa95cOsRcRk
9X9uhCNZboJ18FysDPEzzLHWTdCepUu2WWZjOGpeg2Xog1y7t19LqzooYh7QdWaR
XUw4GIC5M0VwHmkQzctGszmMUSXPsIswjKDTUMUdSL03dhse3LY2J2Yglic7Wamm
sUtAD8CWO/6aHDZtYPNAyvhJoJj+bU3wx4Dm/uwc+whY4Vq/oCRGcxw6iBDaf3VT
D8wryFPQz1LEYOzHWoRFgDWwO9V5o8d3kIXsNoYJg9FR7iRreXc6f3SiVi0Hb+3H
SW92LrqqcXczbMLmRxG/oj6YpLXAzw6/tHwEqTe87kbMQt6j1u+byeLUZjL/lTAk
E3sjNw2wir93khOBgoO/wwQ4aksD3rVQywN0c+H5vveRxcqrX0NK3stRJ2E8G6XW
ZWHLR5lvq4GyAEZnGAylTp3GTr+yH12q+dV+2UecBhA28FOlkYqACGcbj45hZFGQ
n9F0bsjXiOM=
=iSgu
-----END PGP SIGNATURE-----

--=-FE1ewPt6oSCzgzLlmCQc--
