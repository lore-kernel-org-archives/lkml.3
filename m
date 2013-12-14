Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3LNMcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:32:54 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:40194 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3LNMcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:32:53 -0500
Date: Sat, 14 Dec 2013 13:32:49 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20131214123248.GD17467@mithrandir>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <20131212144210.GA1527@ulmo.nvidia.com>
 <20131213020258.GC13333@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Content-Disposition: inline
In-Reply-To: <20131213020258.GC13333@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 06:02:58PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Dec 12, 2013 at 03:42:12PM +0100, Thierry Reding wrote:
> > On Thu, Dec 12, 2013 at 03:36:29PM +0100, Thierry Reding wrote:
> > > This is a simple test module that can be used to allocate, export and
> > > delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
> > > systems that lack a real second driver.
> > >=20
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > >  drivers/base/Kconfig        |   4 +
> > >  drivers/base/Makefile       |   1 +
> > >  drivers/base/dma-buf-test.c | 308 ++++++++++++++++++++++++++++++++++=
++++++++++
> > >  3 files changed, 313 insertions(+)
> > >  create mode 100644 drivers/base/dma-buf-test.c
> >=20
> > And attached is a small test program that I've been using to test this
> > new module. It can be built with:
> >=20
> > 	$ gcc -O2 -g -Wall -Werror -I/usr/include/libdrm -o dma-buf-test dma-b=
uf-test.c -ldrm
>=20
> Please put this in the patch as well (scripts/tests/ ?)

There is also samples/ which already contains various test programs of a
similar nature.

> Also fix up the uapi stuff for the ioctls.

Will do.

Thanks,
Thierry

--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSrE/vAAoJEN0jrNd/PrOh0MMP/A3O3HWkcTfk2452WNjKm2WJ
pQfMyxa+zW72EDwUQY0+JumVWmJfOSgKvl6ttze/8kGnGVbZlrKeJc/qO7/MPGjs
nRoWmEqBrufkOIpMl0rGnKL8EAWcFaeEGlizPFFe3jKMTlBXZt8YjqyutFlqhqjt
Y3kb9mCC0nRNC36rVFAORYhtX7YLT1aYtvewFxicZt6anctFwazVFu7p0t2m2UkO
Fm6sFfpaMf7kDiHIhFgSuZ/PCDkSZtOL3ZUBllvRUywkDN732aPMaqjaWxiQ0p4I
1/GiIIyY3RPoIpFrOtsr7bfiKnEBX+ZXPZRNhPJtO6XYR0DIjyZrEIROlvenmYc0
sYRqXGZD2dXKy3j+f9byiABOG/b9Mzz7xIgm7EvHtUdHEUDl6fXyyiEQYdSZjAve
GpYHLefO2A4zatBwHtDMc0LoF+z/qR0E1wRET23DQCd4xxTQ/8aZZh1rfaqpbU8u
8T/0yhzQecM5sjc3EET30DNppUB8EbHnQbzcgmMstEjxa3i4q0VCYfqwidIMOQLF
xDcWIuKZ5NDMClq4eFt7A4cH+S7g3fvFGZPr3roto5fnB0lPcYgbQtmv/4XZc7i4
GIe/G5SaoE33e+AeV5SawoOPZoWVziJJL3j0ODQ/nh9UnBb5lDN5kUcSLO9j2d9G
RSctYIE4DymCDdVsX+r0
=4fl5
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--
