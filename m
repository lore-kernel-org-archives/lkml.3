Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaJOU05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:26:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:33192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaJOU04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:26:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,727,1406617200"; 
   d="asc'?scan'208";a="589701007"
Message-ID: <1413404767.2412.31.camel@jtkirshe-mobl>
Subject: Re: [PATCH v2] bcm/CmHost.c: Fix noisy compile warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org, mail@beyermatthias.de,
        devel@driverdev.osuosl.org, Joe Perches <joe@perches.com>
Date: Wed, 15 Oct 2014 13:26:07 -0700
In-Reply-To: <20141015195549.GR26918@mwanda>
References: <1413399701-4321-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015195549.GR26918@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-a6fMsVpQa39g/qf7T4yu"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a6fMsVpQa39g/qf7T4yu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-10-15 at 22:55 +0300, Dan Carpenter wrote:
> On Wed, Oct 15, 2014 at 12:01:41PM -0700, Jeff Kirsher wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> >=20
> > The Beceem WIMAX was generating compile warnings on 64bit machines,
> > which were:
> >=20
> > drivers/staging/bcm/CmHost.c: In function =E2=80=98StoreCmControlRespon=
seMessage=E2=80=99:
> > drivers/staging/bcm/CmHost.c:1503:3: warning: cast to pointer from inte=
ger of different size [-Wint-to-pointer-cast]
> >    (struct bcm_connect_mgr_params *) ntohl(
> >    ^
> > drivers/staging/bcm/CmHost.c:1546:3: warning: cast to pointer from inte=
ger of different size [-Wint-to-pointer-cast]
> >    (struct bcm_connect_mgr_params *) ntohl(
> >    ^
> > drivers/staging/bcm/CmHost.c:1564:3: warning: cast to pointer from inte=
ger of different size [-Wint-to-pointer-cast]
> >    (struct bcm_connect_mgr_params *) ntohl(
> >=20
> > This resolves the issue by preventing the driver to compile if CONFIG_6=
4BIT
> > is enabled, since the driver is known to be broken for 64 bit arch's.
> >=20
>=20
> Oops.  Someone turned a Joe patch into a real patch.  Please enable
> COMPILE_TEST for this.

I agree with Joe, that COMPILE_TEST is not useful for this driver.

>=20
> regards,
> dan carpenter
>=20



--=-a6fMsVpQa39g/qf7T4yu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUPthfAAoJEOVv75VaS+3OYzMP/ROfTon5CbbyL8vwHjMf2Lg8
8drwaz1iYVbOYH3rdSBKJqBWq+rOp/vk72EoKFjgdMtGDJjPK1Fg39iI6X/aH4Hb
EKb8kFf3c0qsg87Te7K5h3mm+rkMdQgao8yikzj4O07GnC6xgMAlCB3cxyvdRm6D
H8bdqJyoE1CjSMLlYB6L7wpiX0AE67DYrVBCMEGLQtdRj1cwqNdLyHrGAs2QsjWT
bs5Q+rIZGRhb61DAd4RMjT3WRKnXYg4tq1r3rTzceCyc1pOQHe/Ht4fUU1KgUsZW
K+2fMw5QhKLZORMTtGnNaPic8QSnQECeGubTRo9l+cmOE2ITN3Q8HNmtZtUWGSV9
x1Kt0v40Jb3tXt25xqWSm7dCbny+gFm1PQiDlR++PNmziUVQUVSwFD1o1ICBPPi2
G9deoLTZXKghjIy19Dudu5MBnMwOR/ITgnCtZ/lyW24fMvbfM1DF7k6ffHsXAwjT
GzYT9GPFon5LZO9pfpfl7QobANrpzR2+ZlVV9qdXWbNXaUSopNzHKZiLsiD1/J0C
/Oh0FkUChSnthAJ99U86YmkJPdiFsO4b2y9v/ywwCvS0SXpLSNzG4guPEtpmOVGY
serFA9833gWFN1j31lGneRpTZRMMJSEO8VUlaT0qyrIpW1WOxrXlLK0NYZQYruiK
EchJuf6ooTwCuOCu5P6N
=Jkr2
-----END PGP SIGNATURE-----

--=-a6fMsVpQa39g/qf7T4yu--

