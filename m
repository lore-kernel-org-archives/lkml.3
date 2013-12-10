Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3LJC5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:57:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58435 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3LJC5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:57:33 -0500
Date: Mon, 9 Dec 2013 20:56:49 -0600
From: Felipe Balbi <balbi@ti.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, Jingoo Han <jg1.han@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 31/39] USB: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131210025649.GC20090@saruman.home>
Reply-To: <balbi@ti.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <003401ceefb6$22c930e0$685b92a0$%han@samsung.com>
 <20131209040342.GA20608@saruman.home>
 <20131209083317.GA27716@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Content-Disposition: inline
In-Reply-To: <20131209083317.GA27716@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2013 at 12:33:17AM -0800, 'Greg Kroah-Hartman' wrote:
> On Sun, Dec 08, 2013 at 10:03:42PM -0600, Felipe Balbi wrote:
> > On Tue, Dec 03, 2013 at 08:27:58AM +0900, Jingoo Han wrote:
> > > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > > is not preferred.
> > >=20
> > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >=20
> > I wonder why I wasn't Cc:ed to this email considering it touches three
> > drivers I care about.
> >=20
> > Greg, I have the original ones in my tree and I would really like to
> > avoid rebasing my 'next' branch. Do we keep it there or do you want to
> > avoid merging those commits ?
>=20
> Just keep it there and we can handle the merge, it shouldn't be a big
> deal, right?

Should not. Thanks Greg.

--=20
balbi

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSpoLxAAoJEIaOsuA1yqREIRcP+gMWVCuaSt3qTgaagnoXbELt
GTxcWT6xkxtAyXtHsumndE2VUlYt3G3JOEYZxbDwZTWK2VJV0Kg8ej64kr/up5gI
Ve45Np8ML3UCNWhnhdGS+aYZ5lhu+gRMvkSXPe72660OUxK8SDBjHhZmVTr+sSpE
b7+nTrJ1juvOCKDazgyC781OiZz+amgqEZXTvfeinmkzxtxE5xWkYcppwa7SXSfw
xC67zoH7PIoaAs5Ja/5gecXcVtgIH+d1NoqAJSxAXvakrsjd5bRYypxFfQf5Dgsb
pxNl931oZXdWSisWH3wPonCD2VrNNsbTzurEvGAQjRaU26dRbuZY5howxQoAmzsm
KasaT8FYTxcGxqCJRJ7b+ev2RJRhtEP/nNqHIFP7rizdwbj5fZ7zr2drKl5PsOB7
tS37qG3W+birCSdzCZBvlujEx/0TnkDI0E4/4mlNbzf97GkASos/JOITUFFbNBbM
iTZSjUEXBEcBl09fmOwJQ1OSKjm/coCQgzosTZnNtEf/ZLyL9EvISuZUGHn3g0sb
Hm7pzuo+PMyqBGGpKsSUnEY4lkAr/j4DjLdmS3GdRJqaWofGoXOjGBaXDCEEpCEl
GW2JlORHtvtnSpfGOslORfIrar1lUZTSpjYjGTnM3CKkhX61xwu5YX5nvt++JxU+
YVf9EACHkeZ3Xm9hAxZA
=3hfb
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
