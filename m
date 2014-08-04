Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaHDTtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:49:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57394 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbaHDTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:49:49 -0400
Message-ID: <1407181779.8341.29.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 00/94] 3.2.62-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Date: Mon, 04 Aug 2014 20:49:39 +0100
In-Reply-To: <20140804175544.GA7631@roeck-us.net>
References: <lsq.1407170911.107020799@decadent.org.uk>
	 <20140804175544.GA7631@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3OJrGGt6jtr3rTxijmQl"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3OJrGGt6jtr3rTxijmQl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-08-04 at 10:55 -0700, Guenter Roeck wrote:
> On Mon, Aug 04, 2014 at 05:48:31PM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.62 release.
> > There are 94 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed Aug 06 17:00:00 UTC 2014.
> > Anything received after that time might be too late.
> >=20
> Build results:
> 	total: 111 pass: 105 fail: 6
> Failed builds:
> 	microblaze:mmu_defconfig
> 	microblaze:nommu_defconfig
> 	mips:allmodconfig
> 	sparc64:allmodconfig
> 	xtensa:defconfig
> 	xtensa:allmodconfig
>=20
> Qemu tests all passed.
>=20
> This is a significant improvement over the previous versions, where we us=
ed
> to see up to 10 build failures. The previously failing builds for unicore=
32
> and score now pass, as well as alpha:allmodconfig.

Yes, I spent a little while digging out build fixes.

I tried to fix the mips allmodconfig build, but failed - it needs
d3ce88431892, but that depends on 20082595d341, bef9ae3d883c, and
further changes I couldn't identify.=20

I was unable to reproduce the sparc64 allmodconfig build failure, which
is in samples/hidraw - it built for me without warnings or errors.
Could you give me a bit more detail about the test setup?

Ben.

> Note that I rearranged arm builds to improve test coverage.
>=20
> Details are available at http://server.roeck-us.net:8010/builders.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-3OJrGGt6jtr3rTxijmQl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU9/j0+e/yOyVhhEJAQrK2Q//Yg4IxOnr1Q5FEZ4s+jdm5Ye7R++SaFgk
uE+8861X5hLdp9rmsuBnyGewpiZFcR1yGr7GzmrFnMXjo+2WUihP7fQShEGFepN5
aMPn8eG85QkAmMXP73dOm53lAHSh+dPIGPbhPXME0dT/bPZGH9YgDY9AcajaBlBO
9yLhH56AwLtAArIac/6FhMn+Mh8taLO6bTGcnlvde4VgHhTrNwcTv7n6Az/o8QTL
V7p0JbzOuf7pfZKEX3qTRyCLr+EgkySQDQ9lpJXiKPtd/zcIYjI7AjmK9U9o4b/V
ZcDKzYtecZ5giLcX2wZBPLl+2oWaQ6NXJP/rHBWQ/iHpk0So2hqfDVPaiYYO9pfW
xm58jG8/sZxvtjk9vbSnkpTk+U8OoBDQzkq6QeHsxuKsuV/uRIZxYkP0yUSVlt1T
SovT7SQLFM76nIts1QjJwGHZ3+pAemWHJAbW4O4rm5BlNFX19taW+VXzrhe09UtJ
WOeyxD1RzjUNI0di7+aJ+ikyDlUnIpfEFGri6hL9hof2s1N9Wg7KYfsUAxIQp9NA
WMWK2hFtV2n0KRdLJm/AFG6QSB8KfS1t6KYBJ+p+yPpltBxGSI7HO1fQkEIuKTzR
QevElcwoIx51mS47qgkgEQhD2hJL1+M2LPm9ypHgvZ7QL21TcC9koYHm2QYpa/Ho
lVTCKt/is0Q=
=n8gf
-----END PGP SIGNATURE-----

--=-3OJrGGt6jtr3rTxijmQl--
