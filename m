Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaERNz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 09:55:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55623 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbaERNzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 09:55:24 -0400
Message-ID: <1400421311.2647.67.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 00/34] 3.2.59-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Date: Sun, 18 May 2014 14:55:11 +0100
In-Reply-To: <20140516155547.GA32499@roeck-us.net>
References: <lsq.1400244440.390103756@decadent.org.uk>
	 <20140516155547.GA32499@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HVwHNaT4yj+NsgWMS2zm"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:58c6:ee08:6ebf:6631
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HVwHNaT4yj+NsgWMS2zm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-05-16 at 08:55 -0700, Guenter Roeck wrote:
> On Fri, May 16, 2014 at 01:47:20PM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.59 release.
> > There are 34 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Sun May 18 12:47:20 UTC 2014.
> > Anything received after that time might be too late.
> >=20
> Build results:
> 	total: 131 pass: 97 skipped: 23 fail: 11
>=20
> qemu tests all passed.
>=20
> Build results look worse than usual, but that is due to changes in
> my test environment, not due to changes in the code.
>=20
> powerpc:allmodconfig fails because it is now build it with gcc 4.8.1.
> You'll need to pull in commit 8fe9c93e7 (powerpc: Add vr save/restore
> functions) to fix this problem.

I'll put that in the next update.

> powerpc:allmodconfig and powerpc:ppc64e_defconfig fail if built with binu=
tils
> 2.24 due to a changed ABI in the powerpc assembler. This currently fails =
with
> all releases; a patch to solve the problem is pending acceptance and upst=
ream
> integration.
>=20
> unicore32:defconfig fails to build with all releases.
>=20
> Details are available at http://server.roeck-us.net:8010/builders.
>=20
> On a side note, can you add my e-mail (linux@roeck-us.net) to Cc: for the
> review request e-mail ?

Yes, I'll do that.

Thanks for testing!

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-HVwHNaT4yj+NsgWMS2zm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU3i7xue/yOyVhhEJAQrhNg/9HR8vpZDtv391jaXfn663JksmG9LyeZuB
oCvqEstNCVLCoajD6QJMcT+Q7BQPBqoIsjsVSb+b1Lc/JGmtK+gftqL2iDl58K1i
i/+GLJd/8zyYCD+Oe0pU2J6QhblZMWEXsHHK+5DaXWycdll1ObNrVb/Eydu696nP
DxKeeP3+6tl0qzIN4Hyw+I04sr+I5phZrkzAoqi1vks6wLTpvz3FL29MI0Eb9cLH
es16Ct7ZmC2zorztjpK8q5NqHo1GENhW6/XmR26KXSCApXI7JGVZsSyhPqYHVa1U
JxdFUPzw+RQlX1P4/VKxy2Ea7pmkUed4NXumM0bjPqb94cjgomT/8tjz+21cpBQu
CnteBioVNy6H2t7Pe/QQZdpiZe0+vldeqIB+AetjsQjE1NmVCMoQ7E3Z1TjVrWIA
mRjnKrhOSy8WuSSMwAaN3Z8uxDJKEWCjehhwHkEoifHAQtzUMHigkJl7Jd50spSu
CkNOK5mkXiaK0Qk17uTv1dduOVeYCWo6spZG3fJPtrcaVE6E5mEvfjyelWvSIJdh
Z/4f33qT60NgVNojKNRLkSU/hn2AZgb8zje/xb5ez6Gr0IN6HVgLhPcbAdlnoCHD
AFR51WaVdVJlaDgaKdlvvgS37TfdmxIc9cm5qkC/4KkjA3v5do14rVgZYVGk7IMm
jGMBmUdBITg=
=vSAS
-----END PGP SIGNATURE-----

--=-HVwHNaT4yj+NsgWMS2zm--
