Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab3DZF5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 01:57:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44461 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3DZF5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 01:57:02 -0400
Date: Fri, 26 Apr 2013 15:56:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
Message-Id: <20130426155659.f203481f914edeaba9f1e493@canb.auug.org.au>
In-Reply-To: <517A1117.7000501@ti.com>
References: <20130426151027.db71ddf367c85fe0682cbff6@canb.auug.org.au>
	<517A1117.7000501@ti.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Apr_2013_15_56_59_+1000_OlLwstuNhuvCwfE1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Apr_2013_15_56_59_+1000_OlLwstuNhuvCwfE1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

On Fri, 26 Apr 2013 08:31:03 +0300 Tomi Valkeinen <tomi.valkeinen@ti.com> w=
rote:
>
> On 2013-04-26 08:10, Stephen Rothwell wrote:
> >=20
> > After merging the omap_dss2 tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >=20
> > drivers/video/ps3fb.c: In function 'ps3fb_mmap':
> > drivers/video/ps3fb.c:710:2: error: implicit declaration of function 'v=
m_ioremap_memory' [-Werror=3Dimplicit-function-declaration]
> > drivers/video/ps3fb.c:712:2: error: 'offset' undeclared (first use in t=
his function)
> >=20
> > Caused by commit 6ea19860d6c5 ("fbdev/ps3fb: use vm_iomap_memory()").
> >=20
> > I have used the omap_dss2 tree from next-20130424 for today.
> >=20
>=20
> Thanks. Updated patch below. I couldn't right away find where to download=
 a
> ppc64 toolchain, so not compile tested...

https://www.kernel.org/pub/tools/crosstool/

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Apr_2013_15_56_59_+1000_OlLwstuNhuvCwfE1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRehcrAAoJEECxmPOUX5FEm6IP/Rcx9iNcMzffejY9uP8h1TGr
pwF755aN4rrEfCYB2FNJ5ufhgoHPJlb6vflpo4YVSF4ukpMR41li2POBVFSyGBDv
Y3IudHIxcU4FEgfsF9QPq5mssiAhUUTANYJVUEti5/nZFZ9ZDOi3i73Tmut02IDp
OEfoIGyXZ0vSZMPgxwSClG4uzRi947cR3eh0XAMyuyvO+l4xKc8dj6zV9U3+Thqn
pvAZ2kE/xTeKWj4QhqQB+lXKFDZewBdLBSClvSjb1ZwoepX4431hpYvnLQah8t67
yalA/kFjNH5hGcs6v65tkmrEhZH4sbIm0q4gDTYc0kOWWlqUhUj+D4VbBrQLBGMH
LaY5XnpPvaLgzB4UEEV38bdAMiSb3+Nq6V1WRHlIboUzGerp/zxdzYyRuO3TnKSU
02qUkaOIPG9zn46dH768VKZ2oN17ztDhCWvb5dW6SimQKMxRWqU/xwI86735qbR1
h8mifibxbgEWz2otBU/im1h6BzvM+ATrrcdAi7K89ThKtB59ROS88QB4yuetuWfF
uig31HHBHjyUGQthnT+Iodif5tAdGnrt+2J/Ady57/jJQ0c8dpWbwo8A5G2on7ee
p19ARFlITu3HzyGE0rfpNi07ebaadBI+rQ9LNggFpWJyGr5kUz9YkMzdAs0yr1QF
lhqHX88fJt8RyUkcYc/c
=UUsp
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Apr_2013_15_56_59_+1000_OlLwstuNhuvCwfE1--
