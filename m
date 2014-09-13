Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaIMWkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 18:40:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35497 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbaIMWkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 18:40:08 -0400
Message-ID: <1410647999.3040.22.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 000/131] 3.2.63-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Date: Sat, 13 Sep 2014 23:39:59 +0100
In-Reply-To: <87fvfxyrqa.wl%satoru.takeuchi@gmail.com>
References: <lsq.1410438733.176537304@decadent.org.uk>
	 <5411A3DE.4050509@roeck-us.net> <87fvfxyrqa.wl%satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-A25u/MJwZce5m72guhtc"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:9881:80b9:b90a:1609
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A25u/MJwZce5m72guhtc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-09-12 at 20:59 +0900, Satoru Takeuchi wrote:
> At Thu, 11 Sep 2014 06:30:06 -0700,
> Guenter Roeck wrote:
> >=20
> > On 09/11/2014 05:32 AM, Ben Hutchings wrote:
> > > This is the start of the stable review cycle for the 3.2.63 release.
> > > There are 131 patches in this series, which will be posted as respons=
es
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Sat Sep 13 12:32:13 UTC 2014.
> > > Anything received after that time might be too late.
> > >=20
> >=20
> > Build results:
> > 	total: 111 pass: 106 fail: 5
> > Failed builds:
> > 	microblaze:mmu_defconfig
> > 	microblaze:nommu_defconfig
> > 	mips:allmodconfig
> > 	xtensa:defconfig
> > 	xtensa:allmodconfig
> >=20
> > Qemu test results:
> > 	total: 18 pass: 17 fail: 1
> > Failed tests:
> > 	microblaze:microblaze_defconfig
> >=20
> > Results are as expected and an improvement over previous releases,
> > where sparc64:allmodconfig used to fail as well. The failing qemu
> > test was added to the list of tests only recently and is a known
> > problem.
> >=20
> > Guenter
>=20
> Plus, this kernel passed my test.
>=20
>  - Test Cases:
>    - Build this kernel.
>    - Boot this kernel.
>    - Build the latest mainline kernel with this kernel.
>=20
>  - Test Tool:
>    https://github.com/satoru-takeuchi/test-linux-stable
>=20
>  - Test Result (kernel .config, ktest config and test log):
>    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test d=
atetime>.tar.xz
>=20
>  - Build Environment:
>    - OS: Debian Jessy x86_64
>    - CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    - memory: 8GB
>=20
>  - Test Target Environment:
>    - Debian Jessy x86_64 (KVM guest on the Build Environment)
>    - # of vCPU: 2
>    - memory: 2GB

Thanks for testing!

Ben.

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--=-A25u/MJwZce5m72guhtc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVBTHwOe/yOyVhhEJAQrFMA//XD6JGo89B/mScG3QLHiq9qBjS7NQ1Ya8
KFooLcpM/FgzFLdMcL4pA009gQLG3bg5mRw2Y+hHRZcNUvopg8U+lccSebx9Gsx1
Cl5m9x5Hv8UIk//safAUFG6xJfgqHzj0wpP/Nsa0Hl1U54mgWM9mSnMs273deMIp
E+byhffr8VT+W0iCf1B4ZgWpXmDvroZWD/3NBS3A1pNAmwtjVYVY+uibHphhLFQu
+Q6fRool98HwTFQ9v+w+8DdXsIA/hGZC/DtWedLbjJ3V6bCejfS7Jg/FsQk2Sqb+
/n2FM0cOosmrlJ1OURUQL9yb3oU9Jrlbiua06f7uuibHsc8Mpz4/wp9XkbANAif8
T5RdrHg5+3PNcYaiVZIdO4duetB45Ka8jjjK4TsIQYPTEl5Yx8JUiDSt1WUYniyJ
JuhirXyY9HHnvqZe0+9UCrJ/DtjSvtdDyePOoO0q0M11PpuHI8cZrlGp3jYim3yE
eEOYhymtoMduobVKTR5ZeRdD8KyNQP8zfFhpmSB2LrYfk8YTF2EO/zwvXdEtCKKw
oYdjQIbfYNwqma6WIFGUsOWm9AaTsaccLHKedtLKeoYHPglohdaiLKLIIACueHdW
XNBzX6W5Brj6Njg5KgLAuqazk8J1GbYoU62zWETKYt3Yp8RvMygybH4rQ7m2KzzO
CKfObJhjSdU=
=sbbM
-----END PGP SIGNATURE-----

--=-A25u/MJwZce5m72guhtc--
