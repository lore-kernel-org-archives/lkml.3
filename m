Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaIQLIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:08:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48133 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119AbaIQLIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:08:45 -0400
Message-ID: <1410952107.3040.97.camel@decadent.org.uk>
Subject: Re: [PATCH 3.13 104/187] Revert "selinux: fix the default socket
 labeling in sock_graft()"
From: Ben Hutchings <ben@decadent.org.uk>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Paul Moore <pmoore@redhat.com>
Date: Wed, 17 Sep 2014 12:08:27 +0100
In-Reply-To: <1410818997-9432-105-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
	 <1410818997-9432-105-git-send-email-kamal@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vJMJ3qq7BF1rs71OsNQv"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:cde6:1b3a:bf85:5ca0
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vJMJ3qq7BF1rs71OsNQv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-15 at 15:08 -0700, Kamal Mostafa wrote:
> 3.13.11.7 -stable review patch.  If anyone has any objections, please let=
 me know.
>=20
> ------------------
>=20
> From: Paul Moore <pmoore@redhat.com>
>=20
> commit 2873ead7e46694910ac49c3a8ee0f54956f96e0c upstream.
>=20
> This reverts commit 4da6daf4d3df5a977e4623963f141a627fd2efce.
[...]

Which is earlier in this series (72).  Shouldn't you drop them both?

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-vJMJ3qq7BF1rs71OsNQv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVBlrtOe/yOyVhhEJAQr9uQ/9HyCQxqOuqbB+kBnJmjaWiZkf31Z+8kth
49UcwDKWel1OZJlM8SGXsROqwM+xts71aIlrBxNJhJIiJOgeMjmngXYxrU+2n1jm
wMVE4TMIkw+kxfTSoGzhH/Cgh7akpKWcvUhJ/dYAwn3Zl/bzclEtU+yYGyRct5mY
FkZgSRLdA3+zFRUDlXiEBUmE0vX7F/OPU2YI1p+/ZUVQGdpRaXZxKi6uUyBKTXn3
3eabCYb4q29ORT+Ig5QzTmz/UPx308G8WOrI8VW9fukX4QEbdlq6ffVE6cPmLnyq
HnxKukwNc1rkz2owDUVtV4vKbhI/dy4dGb7WjYtpcOfuyGrskRVcOZXECVMj2Bgy
6kS0yJM22Nas5Yte4hY32LRCwcFF+kegKhlmXnM5DeVkL3ytAd6N3Ob9v1Ib9kOO
pnhXB95pIz7Gc0fx1GTa26VweA5EmalDoamxvjtbmUfM22o38GUyANBKknqQjTno
s5uc8N0tFzgYCaoe6ZJMNtF1v8mc0pEUQSC/DjNXJ3Rls0teCHz2ocXe3JvgYwjY
3FBB8pUwN/MZVDKtwV8IzCUmaX1rJkjpJdLJJnEpMJyATgkA1Mh5cLQZqpGomttq
TBTdgN/9Aptly2IVLN1csuYlIGT1maN9AZF2gp+gDNfLbxRChUe/UjAX/pHaIKct
UeRWurfE1R8=
=5lEN
-----END PGP SIGNATURE-----

--=-vJMJ3qq7BF1rs71OsNQv--
