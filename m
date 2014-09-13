Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaIMWju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 18:39:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35488 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbaIMWjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 18:39:49 -0400
Message-ID: <1410647981.3040.21.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 000/131] 3.2.63-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Date: Sat, 13 Sep 2014 23:39:41 +0100
In-Reply-To: <5411A3DE.4050509@roeck-us.net>
References: <lsq.1410438733.176537304@decadent.org.uk>
	 <5411A3DE.4050509@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hTzcNXJfsrgs5/pHSNV9"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:9881:80b9:b90a:1609
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hTzcNXJfsrgs5/pHSNV9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-09-11 at 06:30 -0700, Guenter Roeck wrote:
> On 09/11/2014 05:32 AM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.63 release.
> > There are 131 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat Sep 13 12:32:13 UTC 2014.
> > Anything received after that time might be too late.
> >
>=20
> Build results:
> 	total: 111 pass: 106 fail: 5
> Failed builds:
> 	microblaze:mmu_defconfig
> 	microblaze:nommu_defconfig
> 	mips:allmodconfig
> 	xtensa:defconfig
> 	xtensa:allmodconfig
>=20
> Qemu test results:
> 	total: 18 pass: 17 fail: 1
> Failed tests:
> 	microblaze:microblaze_defconfig
>=20
> Results are as expected and an improvement over previous releases,
> where sparc64:allmodconfig used to fail as well. The failing qemu
> test was added to the list of tests only recently and is a known
> problem.

Thanks for testing!

Ben.

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--=-hTzcNXJfsrgs5/pHSNV9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVBTHree/yOyVhhEJAQpndBAAnI8QTWjOIAqmCI8+EkpDV4auntlHeQDp
2hH1rlYmgxlgSrFKqhlhW7g1SelJDnhd5FVIY/M+kDjcxN/BiHtetQA1d6kXxHOA
JdycCVXHFvfJKC6LwAdLiN5mA4ilI9tHm9JU4/BPn6DT6Kv5f4yNHhqShvJLIDel
olwiO7HE8Uj4AP/5aDmxg1D/WFu9AQDe+PDwUd9D1oiwv+lGBNw7FktbAEMGl3C+
ZNZYVO2aC1q9PI891vRCxHajxoy94RX0wRorqtA5S/xmFDsCmH8I38A/f6jjXYX3
xEXzZ70rVxZwfGLPLnfUIe8VMVVvx4yw1Nqf2N95RzhJ6+mswZ4g2Pc6W7yckv98
VxUq3jq6Ga5eU8wXjhjIaYMsaQuKXux7YwcPIp5Xzdh+QujxQ9olS7M70CDYOwNg
rHJvEZBb6pz6XI2NGwy7oACCCCpt03EbvuAGO7zTzXckPiHXaytIC6Zq0GN2RsLg
QT9Q5tn2Uc9hx/1dzizLAU82gAWQEUgIrd0RY0McTNMAOI+WCwRnbmLZBN/MSpPh
gxkGEh4m9E/FSBD5/n+FHRZWHAUV22uiDBK+JezNSkeaIJLD7Za5edMD25MZtXdA
8nfEcclXwfP5/gaY3H1qA1R2p+ibTnxFQlWPNv1j7Op2kFmnf3FV32Ocsn+CGyqj
NHXBT+GwAI0=
=QSS1
-----END PGP SIGNATURE-----

--=-hTzcNXJfsrgs5/pHSNV9--
