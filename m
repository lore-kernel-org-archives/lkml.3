Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaAXSxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:53:54 -0500
Received: from sauhun.de ([89.238.76.85]:46509 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbaAXSxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:53:52 -0500
Date: Fri, 24 Jan 2014 19:53:48 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] i2c: rely on driver core when sanitizing devices
Message-ID: <20140124185348.GA26225@katana>
References: <1390322914-14191-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <1390322914-14191-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2014 at 05:48:34PM +0100, Wolfram Sang wrote:
> Commit 0998d0631001 (device-core: Ensure drvdata =3D NULL when no driver
> is bound) modified the driver core to always clear .driver and .drvdata
> on remove or probe error. No need for the I2C core to do it.
>=20
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Applied to for-current, thanks!


--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS4ra8AAoJEBQN5MwUoCm2YC4P/3GE3uMNoOqncPabTxAhoPn3
Vll4PHi3W5rr9ch1TI+XgnNU+yCRkKalW6dLdA4Vfr6rU7LFqoV+slaS5MxfmPg6
d/K9IJ3Qm8YLEVm9oZjs8LPGuGcot55Veefrf8e+qg4QmhORX74ZuZeoNXAf4sFB
z6SB8dnOW0IzoImmSucbCa33rWTvKMLwkpKUJflP1kEbgVe//FefRpDdhju0M8gR
c/76TRn+CrNL+lhr92UDkW4CyJnm/0VFIN29biLJ1ZuU1HnWj4M6/6QsXVmDC0Vd
q/5/sLL4hBCAs/LaGWkmacDdgTpcAQjwQldJsk9Tsv1ZK2QNeBnyxPJ4H0XXc+Dc
LRioADSebYwTzS2KuTP//cfBPYnXiFm9EZNrJrPZrF0wSLrC0sA8p+hO3Px8X7Kh
sy8G7b9vSMvR53wKwAL6b4h2myFt6xojoMjtvLb672SFrwlugj8HmOIjoRoKT+o8
tTPUfpBLCeh5dd8l5bEjzeSReIehnyA6ShH/CRkFeXNzkF0d1lmgURcqLhQcgJZ1
+omB8aqbJrpLisH2lVyGHtg7W2Zc0P4j+aZlQfbfgqtphOr0VvMydIdJq38GhwFg
XoFStAo4QEKIj24ReZnJ2rECPBOtyZiiswjBkQdQOifLxQiZKxdsCOs5SZnOOYWa
EW0y5Y7T4CWFk6s/NJ3u
=rI7L
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
