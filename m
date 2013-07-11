Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3GKBBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 21:01:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59780 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755392Ab3GKBBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 21:01:51 -0400
Message-ID: <1373504502.24446.49.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/1 V2] linux-firmware: Add AMD microcode patch firmware
 files
From: Ben Hutchings <ben@decadent.org.uk>
To: suravee.suthikulpanit@amd.com
Cc: dwmw2@infradead.org, sherry.hurwitz@amd.com, linux-kernel@vger.kernel.org
Date: Thu, 11 Jul 2013 02:01:42 +0100
In-Reply-To: <1373503376-5841-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1373503376-5841-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rwqtaHGWqBuomAlEzWKT"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rwqtaHGWqBuomAlEzWKT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've applied this, but:

On Wed, 2013-07-10 at 19:42 -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>=20
> For AMD Families 10h ~ 14h Processors
> file:   amd-ucode/microcode_amd.bin
> md5sum: 55ae79b82cbfddcf7142058be3c9ec2d
>=20
> For AMD Family 15h Processors
> file:   amd-ucode/microcode_amd_fam15h.bin
> md5sum: 122ac7e56442c2b7c28eb26978b2d57c
>=20
> Version: 07_10_2013

This is not a suitable version format, as e.g. 01_01_2014 would be a
later version but will sort earlier.  When dates are used as versions,
they should be written in ISO 8601 order, yyyy-mm-dd.  Old releases from
amd64.org were labelled that way.

Also, the version belongs in WHENCE, so I added this to WHENCE:

Version: 2013-07-10

> Signed-off-by: Sherry Hurwitz <sherry.hurwitz@amd.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>=20
> ---
>=20
> Key Name        =3D AMD Microcode Signing Key (for signing microcode cont=
ainer files only)
> Key ID          =3D 8C0108B4
> Key Fingerprint =3D 916A 7708 23A7 B27A ADE0  1565 A5E8 DBC9 8C01 08B4
>=20
> GnuPG Signature for file : microcode_amd.bin.asc
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
>=20
> iQEcBAABAgAGBQJR3dkLAAoJEKXo28mMAQi0/9cIAKraXlbchZkkIPzyMrZBZZJe
> zapMterpLdDYL6zukfqgF7Frg94+ilGPK9yKAFsvC+EJyHrF5lbRQ/JthANdRv+Y
> 8sBKz5/knVI72WdjSjg+473I1rFdIUK+YN7Ygp6eAwP3fg/IQ9UD9iQfWKbbUnx0
> WSEMCZm/izsyU2LQMJvtizJ2gz9ktFoALUtTvj0bv34CKr++qqngEVFy/WKQdR6x
> R3l5MjFAhvzO0O9gV59s1tXbPU56HRhMbvSBn3NIVZu17pwAFySHwQLAeW10GH0j
> UfgpKQppbz90iLLaSh8vseTOoTBn5SegDtK0JEJNMOuK1VoZ+kgv0cqGCs17HBQ=3D
> =3DFnHv
> -----END PGP SIGNATURE-----
>=20
> GnuPG Signature for file : microcode_amd_fam15h.bin.asc
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
>=20
> iQEcBAABAgAGBQJR3dkfAAoJEKXo28mMAQi0iTsIAJ5nCgz/+jFYag2W/OH+kOQe
> BDXYSC5diXQR5wF/HUkXWh0sl+jNK/OrRVxT7sFaEgAUhEXhK6Df/h7qnJAYQGFr
> 5+CKhfSr/0Qbk1ziWYAXVKMOXbuLWSSIov1SCcwLsps7A7puITK6xDemLby7KDGC
> xCUfKIM/BO6DyFpNhKQ+xJdDi+yVxUKQhbdk/8gY94VdUnVZq3CTK9UStpBuaXu0
> qJNfhbaU+OzgZmnmLq5+xGsCML1xfbgF6sexVRx7oT/Jv30tm97YQJWR0h4DU7jU
> zjID8kGtYRVV7+i8jC+jVpFo21yDVUkHUcqtNXXRB/lbOYFAm+UJviAEc4NEdSw=3D
> =3DJaWY
> -----END PGP SIGNATURE-----
[...]

I added the detached signatures to the commit as separate files, so that
distributions and other downstream users can verify the signatures.
linux-firmware.git itself is not currently being tagged, with or without
signatures.  Please include detached signatures in future.

Ben.

--=20
Ben Hutchings
Reality is just a crutch for people who can't handle science fiction.

--=-rwqtaHGWqBuomAlEzWKT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUd4D9ue/yOyVhhEJAQo2dw//QNJRlIsbUG3jj6AYXWLFEJha2zb3hQom
tN3Uugse7AEyZ+ZNgAuRv7Z0w45iOC3wrtmIpbcjUhsrbEe//Vwdo8jTFiJVHfGO
labWSPQFmtM129XEz+Df3UprmEdQ8dqVS1spj3ZxY3NFpPIXzcbs+lxzSf5zYlRI
8lN1+S70Of+JTmkGr25mcMF+KJQ9qwsl1gfvrP59wl2ThJYcrcpFdSb+t2tQ88I6
p1Jb9BxgyPL3cqdIK7NwIceu8l3XwJlD+hVBnZocZfsXthDAcg1G84Ji9vY0ll8C
2mOEPNAgAIF2pz1ZZ4OqTNqvX48bGqR4TTCi0/Z3NcSIibqtOm43RucGV6wrdrCi
ckA43NRPZ4kiL1Ov3EUehzKAHSwOIU8yLVqEPuTlu70UK2aa11dw5iFRXvKeQMc0
E+BAR3wiLCxEsgJ5pBxKT8xXTK70+ohZHVOYEiNjVjgBszhtLHMigCZ5GQ85Kqzt
VKWxOA0VNAbSfsQW7PrnFCBUaoNm4pe+O1VIIUmL/vB15N0iMX5cWCBSKQScAJnD
F4bygQxbnwRZB2woo6TY3B7xWho9JqB5pao6vKenv86Y6QM3Osupr6QWdwBcZKCo
pw54VJ2NBP8fVTeOlLg6csDLf2TEXxBOjJjUCHx7SNRqWr9m5x2fvZvSAj2u7YaB
dN8MFlA83eg=
=8Oa8
-----END PGP SIGNATURE-----

--=-rwqtaHGWqBuomAlEzWKT--
