Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaLZEkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 23:40:10 -0500
Received: from ozlabs.org ([103.22.144.67]:39300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaLZEkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 23:40:06 -0500
Date: Fri, 26 Dec 2014 15:40:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: add the omap-pending tree
Message-ID: <20141226154000.669551a2@canb.auug.org.au>
In-Reply-To: <20141226153822.20a6bcfe@canb.auug.org.au>
References: <alpine.DEB.2.02.1412191715230.3102@utopia.booyaka.com>
	<20141226153822.20a6bcfe@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/z3rs2gYS1oEUw+FtguzyDi3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/z3rs2gYS1oEUw+FtguzyDi3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Fri, 26 Dec 2014 15:38:22 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Fri, 19 Dec 2014 19:28:08 +0000 (UTC) Paul Walmsley <paul@pwsan.com> w=
rote:
> >
> > Might you be willing to include this branch in your linux-next builds?
> >=20
> > git://git.kernel.org/pub/scm/linux/kernel/git/pjw/omap-pending.git#for-=
next
> >=20
> > It will include OMAP clock, bus architecture, and low-level power=20
> > management patches that are planned to be included in pull requests to =
the=20
> > OMAP upstream maintainer, Tony Lindgren.  He in turn will submit pull=20
> > requests to the arm-soc tree.  The objective in including this branch i=
s=20
> > to get these patches integration-tested earlier than they would be=20
> > otherwise.
>=20
> Added from today (called "omap" and with you as the contact).

Actually called "omap-pending" :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/z3rs2gYS1oEUw+FtguzyDi3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUnOakAAoJEMDTa8Ir7ZwV550P/1mqHxqxiZTDc/QB83OygPOO
qoUZVMWtsLPgxh/yfx19/XrNhIl9OA/C22r4ISU5pw61DJii1DMTB+vQDrvI6P3B
7/AIRy6ct0I22qVaJ5jnqHTab0hru9dn/TTt0XKTU37CX7sLBGASLfp9vU243vIp
iwCvgMz6kWr3OyT1Ct0od/OCIybhrFqJD2FjuXwjzZoiz5kSHY1h96+6G20+wNRQ
hJPmEZ7+c8Z0Vd4Hfy/17rj1JifZXxQwZOKjjWrQPTBbfO1LUoRbXVMdxXsVZ8CH
W5Cnjey8zPxePpOH6dxEb+QGFwFTWRKArgPJ1Kw/Jh0BIdigyZFg2f4vkZYeWMRJ
kM+JqFHT7erCurObHwV/7iRM8fwNyQHt3Q33v0T/WR8c7a65Lz5xZSf4NEweqEOb
i6vkjeBTB8rt7ZVphacRfq0HCet3tJ4G6iYQJo5o6/RJtlKOSdNQjA4+fp3mnuNS
o1lzIE67cUieTyxE3o3K2qZgCmvzCsiBUpaBBPiBmYQ/51ZixyZskqf8eSLrGPyC
ReLxU8ycBv7oVdLkNfaClGorvpR7Fqh7YXrV0cRgyyvCnHi4zJ/pelKhrpB6yH3D
ODfnT5X7c7cHAJIubSHkpqfv8W4tq73wmBXrB6HpZ2HyeTY1qSAx4umgNCSLSIPC
R7Jv8Vbq/CabIqjZlsjN
=PD4W
-----END PGP SIGNATURE-----

--Sig_/z3rs2gYS1oEUw+FtguzyDi3--
