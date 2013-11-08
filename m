Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab3KHRyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:54:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39380 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab3KHRyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:54:49 -0500
Message-ID: <1383933278.10256.1.camel@fourier>
Subject: Re: [PATCH 3.8 23/91] xen-netback: Don't destroy the netdev until
 the vif is shut down
From: Kamal Mostafa <kamal@canonical.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Paul Durrant <paul.durrant@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, Wei Liu <wei.liu2@citrix.com>
Date: Fri, 08 Nov 2013 09:54:38 -0800
In-Reply-To: <1383904422.3189.55.camel@kazak.uk.xensource.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
	 <1383876946-2396-24-git-send-email-kamal@canonical.com>
	 <1383904422.3189.55.camel@kazak.uk.xensource.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-pdvTZnml0aZlED55Ghpr"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pdvTZnml0aZlED55Ghpr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-11-08 at 09:53 +0000, Ian Campbell wrote:
> On Thu, 2013-11-07 at 18:14 -0800, Kamal Mostafa wrote:
> > 3.8.13.13 -stable review patch.  If anyone has any objections, please l=
et me know.
>=20
> This patch caused a regression in the 3.10 stable tree. Two additional
> patches were needed, see:
>         http://www.spinics.net/lists/netdev/msg256637.html
>         http://www.spinics.net/lists/netdev/msg256636.html
>=20
> Ian.
>=20
>=20

Thanks very much for the heads-up Ian ...  I'll get those two additional
patches into 3.8.13.13 also.

 -Kamal


--=-pdvTZnml0aZlED55Ghpr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJSfSVeAAoJEHqwmdxYrXhZgBgP/0Du+tkRoi5mjysGznaxR30Y
dMyR7lOe4Nc2vVTtp3ONiu+OPChe/yEEHvZRtKbuVfa9c1/aJE5UY/E0v9nC3Smg
GH0OEVwu1KmiGxEfooyZlYaySDcyiWbkm0WkUs98X6w/dz2c63N3b26/7AQuHYzQ
pcPVZJ4jqfZRIzagd3zOx9shRZS8Pu6YISw0P25j5efeqSSMAsvLFfNrEGn7G4q9
fe/y+UxRvI6n/a3vIzvAybEb/qUQTCEn3wUTtsysZAz8uEbzpjFV6sJHa+h6O6J0
7V3Utb2cGEKVpHesXhIkgFuazDlwNMMakRb6V5D3EFav0GIqiLilVImAQjiEhld+
qib2DeKxO72XtD4Y2JtUsK00AWYmdqvopBrQYl4wa99PaCL1dwcQty82P7Cx6t91
KFS10ew3IY6lkAme8BYp+jIfpKbDszMKHm9XICDWY6liinSSVR4XlPjWTtDQQY3Y
Ct3Bm33xu1nqJb9Od/7ARFfM3Ghh7Nhf3XIIaTBPbqJgIC23HInwUQ+pYennOq95
40jWkehL4R6rJm4a5u2eh5rjgt480wVj11r9SE0xwDT+//EZHlNlQLc/0z4IL2lp
pIbVOw0jUYDqLwrTJB+08ZUuj5EOjrlXTu5ZwERCpiVqhYYrn1rLcL3Eu3ikwkN+
TAAoNAJmHqthvMxqPfDx
=jpsI
-----END PGP SIGNATURE-----

--=-pdvTZnml0aZlED55Ghpr--

