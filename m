Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaLFC5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:57:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:14142 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbaLFC5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:57:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="425785467"
Message-ID: <1417834670.3247.1.camel@jtkirshe-mobl.jf.intel.com>
Subject: Re: [PATCH] [PATCH] VERIFY_OCTAL_PERMISSIONS: Move to
 <linux/sysfs.h> where it belongs
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: George Spelvin <linux@horizon.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        rusty@rustcorp.com.au
Date: Fri, 05 Dec 2014 18:57:50 -0800
In-Reply-To: <1417834439.31745.7.camel@perches.com>
References: <20141206024952.24901.qmail@ns.horizon.com>
	 <1417834439.31745.7.camel@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vg0w71NqOr4HwTgACbAM"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vg0w71NqOr4HwTgACbAM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-12-05 at 18:53 -0800, Joe Perches wrote:
> On Fri, 2014-12-05 at 21:49 -0500, George Spelvin wrote:
> > I found some other alarming things, but nothing related to this.
> >=20
> > E.g.
> > drivers/net/ethernet/intel/i40e/i40e_debugfs.c: In function 'i40e_dbg_d=
ump_desc':
> > drivers/net/ethernet/intel/i40e/i40e_debugfs.c:855:1: warning: the fram=
e size of 8192 bytes is larger than 2048 bytes [-Wframe-larger-than=3D]
>=20
> Patched.
> Waiting for Jeff Kirsher to get 'round to applying it.
>=20
> http://patchwork.ozlabs.org/patch/411356/
>=20
>=20

I have it queued up for the next series of i40e/i40evf patches I will be
pushing.  Just waiting on the acceptance of my latest series I pushed
this morning, then I will be pushing this and other i40e patches.

--=-vg0w71NqOr4HwTgACbAM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUgnCuAAoJEOVv75VaS+3OyeAP/2Lnt/5EeTkexF/xhVd8Qjby
icWm79/btrsfm9NlWcb7K3AFuQ2iHeUo+3KiKDDXULE/eb+UIB/E3/YF5NgJNP6d
GpxuPai7/J8QuvBqlJ3EwRxbRqr057sJcgE6K2h+QaTXyCdEAJyyXbPwoNLcoxXV
SzAeYvQkvNoURgfiNFm/leZkiGxSqmTIDthhH8a0GaAO2akzoEVwXGKeDy3K26N+
PevxHfynqMZcGaGoEk6w4Oz4gu5Sckutm26VHObyGN5E0/4NLK5GRNmFqus7HDoB
lx8cF+KsLopeX7pwfJwhMlj/Ag0E55tnNWf4Js3VZeHhdzGzPvSguIoyRXDdQcaD
gkUKcJgFWuCDunosDVP4C8hT7uWMe2pTUuvpSmX20bbhjppBtczBU2ffTA7dlZnP
ePM/D6x+gWuCLFlIOtqyUCQSeOVZ9EX4YP8bXPk/owfyCnbtVtXcdXqUYXMgAG+K
XVmH0/TYC5do6ut1VBNiYWRghMUOR3ZRwe9zNwcwuzriEWCx5hjzIWX5JGdAnmhr
7CLA4fSFWIqiTe1W3GRuzuaifowLymnDVDHOLOnJ5IigN35aHDDkQZY8lbDkmZ64
T8mHEaGtgeCSHwbz4RvL1XVJc9o/hVtzDq0n4aQX236fhBVgcWlmsJNfeQVVFEyx
+kmjVij+TBk2rOWsLCuy
=t5zO
-----END PGP SIGNATURE-----

--=-vg0w71NqOr4HwTgACbAM--

