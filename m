Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3BYJuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:50:39 -0500
Received: from multi.imgtec.com ([194.200.65.239]:20141 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905Ab3BYJuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:50:37 -0500
Message-ID: <512B33E7.5010300@imgtec.com>
Date: Mon, 25 Feb 2013 09:50:31 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Rusty Russell" <rusty@rustcorp.com.au>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the metag tree with Linus' tree
References: <20130225094830.e45f7b56cddcc839841d6619@canb.auug.org.au>
In-Reply-To: <20130225094830.e45f7b56cddcc839841d6619@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig76022F68FED4B91394782A18"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_25_09_50_33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig76022F68FED4B91394782A18
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24/02/13 22:48, Stephen Rothwell wrote:
> Hi James,
>=20
> Today's linux-next merge of the metag tree got a conflict in
> mm/page_alloc.c between commit 22b751c3d037 ("mm: rename page struct
> field helpers") from Linus' tree and commit 373d4d099761 ("taint: add
> explicit flag to show whether lock dep is still OK") from the metag tre=
e.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action=

> is required).

Hi Stephen,

Looks good to me.

Thanks
James


--------------enig76022F68FED4B91394782A18
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRKzPnAAoJEKHZs+irPybfTYgP/2Y072Y75GABRMsitfR8Ieyb
K5HSPRT8RUjqXq/TCo/ibtiTjhmXILvqFpeDyvVrI+JGpk1n2q62MTCfiVxElKXf
kFareHy8wVd3XTwPe+gKZoVeUeZHa7bPIXqRvcg5I6u06A6hqDkiBJOhwRVOqiTK
HDeQvw8h9DXy39VK+QIienv/oe+1w3HAymEVio2FHzIwUlOS+Pcfq83Tr8lqBvRx
VxkB7XpnvXH+oowS9g0B+aD1Ju/bA6I46iokozGeydPtem4PAtZHQnv6CFocfaaz
qo7zg+KvhUEBc//5dBp69lh1mCsOEhuh131aIXXXrH9ZIQWDb2q4v87HFgTK5XHS
y/dJU+10doc98dnLp2DNApymQBh9jETiW4gwKIBD/n/D/PaTH3BTNISEsYs27Lsd
Xu6UIxNxSbUPmC/v02c6wRp2A9Zwdge910dFOFwlW30MUDtIv2tlhCW3AlGvaLjP
EJGsueULiPlJX1I3Z31fwuTaGIoXOBUeJ7ekkvXX7ATpmc6GBY+QNCKCVRBs7Xtb
t2O61hEIZaWMu8SlX5TMKLtebTWxXO+PTXIEUNPTxtB1dncITqbhWHcUQgozCdBw
XhDAPkJhFm6uQb1tzBz4+KSn3adN6S0DHKPsv52T/TWDYRbCnGROL+lDayTe6KOP
c+XWeP6Ey1tTdq2ozLBy
=/9AQ
-----END PGP SIGNATURE-----

--------------enig76022F68FED4B91394782A18--

