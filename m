Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaAQWCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:02:17 -0500
Received: from mout.gmx.net ([212.227.17.20]:62950 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbaAQWCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:02:14 -0500
Message-ID: <52D9A85E.8070306@rempel-privat.de>
Date: Fri, 17 Jan 2014 23:02:06 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Julia Lawall <Julia.Lawall@lip6.fr>
CC: ath9k-devel@venema.h4ckr.net, kernel-janitors@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 0/11] use ether_addr_equal_64bits
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr> <20140117212410.GA13930@amd.pavel.ucw.cz>
In-Reply-To: <20140117212410.GA13930@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wPeiUu57NahR2I82nneDslo4JQxIfmkgx"
X-Provags-ID: V03:K0:E6NxAJ4GRQ+Ek0P0NbFYfWPGKIpPiqGm1IloHYWbIW8LTDHaj93
 Ku81ZXdJTXF440QK8BvroJJTqHjU39K1gGOYvKIy9aV/0aZ+MV0ptq3dO6rSVVnpEes0cxi
 Zkf/VRFndlhdb0/5KSiS8gQUjB5PBft4vS5fs5o5nweUfVlJBeO/6mMkrFR+WRJAzsJpdg9
 XKM/1Eb1maAiHQx58lIuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wPeiUu57NahR2I82nneDslo4JQxIfmkgx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 17.01.2014 22:24, schrieb Pavel Machek:
> On Mon 2013-12-30 19:14:56, Julia Lawall wrote:
>> Ether_addr_equal_64bits is more efficient than ether_addr_equal, and c=
an be
>> used when each argument is an array within a structure that contains a=
t
>> least two bytes of data beyond the array.
>=20
> I mean, yes, it is probably faster, and yes, most structures probably
> contain two more bytes, but... is the uglyness worth the speedup? I'd
> say this should not be done except in very time-critical places...
> 									Pavel

This code run on every received beacon, almost on every wifi driver (If
i understand what you mean.)

--=20
Regards,
Oleksij


--wPeiUu57NahR2I82nneDslo4JQxIfmkgx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLZqF4ACgkQHwImuRkmbWkVzQD/RakXROCReQFxlfH2WUvcgm/s
h27RY898nl6Txplcd1QA/iBcXdKSu5CM6doc8bhMe1aOLsa1rkxYGv+fLl1IwOwr
=oOX1
-----END PGP SIGNATURE-----

--wPeiUu57NahR2I82nneDslo4JQxIfmkgx--
