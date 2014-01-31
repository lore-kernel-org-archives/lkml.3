Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbaAaPlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:41:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27134 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbaAaPla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:41:30 -0500
Date: Fri, 31 Jan 2014 10:40:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.14-rc0-late-tag
Message-ID: <20140131154021.GE22527@phenom.dumpdata.com>
References: <20140131153857.GD22527@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <20140131153857.GD22527@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2014 at 10:38:57AM -0500, Konrad Rzeszutek Wilk wrote:
> Hey Linus,
>=20
> Please git pull the following tag:
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-lin=
us-3.14-rc0-late-tag
>=20
> which has bug-fixes for the new features that were added during this
> cycle. There are also two fixes for long-standing issues for which we have
> a solution: grant-table operations extra work that was not needed causing
> performance issues and the self balloon code was too aggressive causing
> OOMs.
>=20
> The signed tag has a good description of what these fixes are.

And I fat-fingered the GPG sign key - so here is my signed response to the
original GIT PULL.

>=20
> Please pull!
>=20
>=20
>  arch/arm/Kconfig                    |  1 +
>  arch/arm/xen/enlighten.c            | 77 ++++++++++++++++++------------
>  arch/x86/include/asm/xen/page.h     |  5 +-
>  arch/x86/xen/grant-table.c          |  3 +-
>  arch/x86/xen/p2m.c                  | 17 +------
>  drivers/block/xen-blkback/blkback.c | 15 +++---
>  drivers/xen/gntdev.c                | 13 +++--
>  drivers/xen/grant-table.c           | 95 ++++++++++++++++++++++++++++++-=
------
>  drivers/xen/swiotlb-xen.c           | 22 ++++++++-
>  drivers/xen/xen-selfballoon.c       | 22 +++++++++
>  include/xen/grant_table.h           | 10 ++--
>  11 files changed, 197 insertions(+), 83 deletions(-)
>=20
>=20
> Bob Liu (1):
>       drivers: xen: deaggressive selfballoon driver
>=20
> Dave Jones (1):
>       xen/pvh: Fix misplaced kfree from xlated_setup_gnttab_pages
>=20
> Ian Campbell (1):
>       xen: swiotlb: handle sizeof(dma_addr_t) !=3D sizeof(phys_addr_t)
>=20
> Julien Grall (2):
>       arm/xen: Initialize event channels earlier
>       xen/gnttab: Use phys_addr_t to describe the grant frame base address
>=20
> Zoltan Kiss (1):
>       xen/grant-table: Avoid m2p_override during mapping
>=20

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJS68PhAAoJEFjIrFwIi8fJBhoIAMR2YtLNOVJ1uZYbiVy27lDe
6+mxjO4rpHm9rT6qhSsUsdND76/TvWPV9TKIxfFWWKrgDbMNjjOUpkMrp0UR5lcF
rKz+gfuxaX+ZZg887EnTpsnixAnV8UHT66wnKg7c1pXujiDtD+Nv68DIGbvyeKMj
Ad5RgYRYqRBKUmauSNw5DtArl5mFVw0ShEc7uvvqACefD7nQ79lg7R0iL3Xr7AGX
iGMrBlLiz3S+hLxwiGMCy+7pX/pJhfGTWMlyxrd19ZwRRrgYHFRDtRmwF5BhttVO
IlfHWlHZPwOWRur6NN3Q8Riho3vTDZWfj78mMXU/MENL2sn7tzsZw4T0OAu4Pu0=
=O4+L
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
