Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaJOUnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:43:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50839 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbaJOUnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:43:15 -0400
Date: Wed, 15 Oct 2014 15:42:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] base: dma-coherent: fix device_init initialization
Message-ID: <20141015204251.GA5040@saruman>
Reply-To: <balbi@ti.com>
References: <1413405140-17777-1-git-send-email-balbi@ti.com>
 <20141015133959.dd2814e196eaa3fc3bcb7b93@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20141015133959.dd2814e196eaa3fc3bcb7b93@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 15, 2014 at 01:39:59PM -0700, Andrew Morton wrote:
> On Wed, 15 Oct 2014 15:32:20 -0500 Felipe Balbi <balbi@ti.com> wrote:
>=20
> > commit 7bfa5ab (drivers: dma-coherent: add initialization
> > from device tree) added support for dma coherent pool for
> > DeviceTree. Unfortunately that commit introduced a new
> > build warning because of a wrong type on the definition
> > of ->device_init(). This patch fixes it.
>=20
> Guys, when fixing a warning please always always always quote that
> warning in the changelog.

will do.

> Presumably your patch addresses the same mystery warning as did Marek's.

seems like so.

--=20
balbi

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPtxLAAoJEIaOsuA1yqREpSwP/idlVlM+XTmcJnEhBpGR3RWc
5hdZoatFMKS36R3huPvB1rv+NMNHlTq+jaPKHcnEcgtkCBXJ9lmn4C48se9acKzp
3lrKVabc9tB5XoEGJdRv8DHANvoN1+UA+mHVufvjdMcJtEcRfqmUr18FUZgOQhOg
xeEraIEVgD4kPq/EARWdzou7FPKPi2H/rp8w7ge816x2NvxOyc2xq1Lo6wfj1qvg
UwIN73TpAQxxZ16cXfC1Vpad8Cq3dMWyhr18PNHlz/h+3hqEp1UmGmQOkJTaSsEy
O70pfA+xLl8kA6k8axjtHkxXo0HSqzEM2Ef8NIWiaR2wlAlhnYsCWHL/rPny/cTk
qS90rdyCcogYzgjrU28fHIzix2OYULKUYj2zQgi9Ih+TVgIT+ECUxeOdMl8geLxV
L65HkvaICs7OmP0ORI1eFn6PSuQMP+XpUPEM9EhBImemIjjmE7tvNGE+/GSBhN69
SxwrQRgXOQV64vxZpgxz8y50ZUdBZO5APBTIyyJsogqniqx2hcNLgqfsKR1n3DCT
8v5jK0HncgniWoyooagEbIhgveOKqD0H1+Zr9YA1Zkrbn4n2rrNUL4guld8gKf5A
hyKDdbNJ5ZT6w8tNg/DccRtkYh2l3PcdL57+5BE/l5Y8T4/jcM0Xet4flowCdhWk
Y2uZoBYG7GmMd3s36m0g
=s5/V
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
