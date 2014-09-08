Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaIHI57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:57:59 -0400
Received: from ozlabs.org ([103.22.144.67]:58331 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaIHI55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:57:57 -0400
Date: Mon, 8 Sep 2014 18:57:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: linux-next: build warning after merge of the akpm-current tree
Message-ID: <20140908185747.133b3a0f@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/t=q.5VKKIIW+2ehID/WdjaA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/t=q.5VKKIIW+2ehID/WdjaA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/base/memory.c: In function 'show_valid_zones':
drivers/base/memory.c:384:22: warning: unused variable 'zone_prev' [-Wunuse=
d-variable]
  struct zone *zone, *zone_prev;
                      ^

Introduced by commit 46d9999e7374 ("memory-hotplug: fix not enough
check of valid zones").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/t=q.5VKKIIW+2ehID/WdjaA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDW+SAAoJEMDTa8Ir7ZwVlQAP/RGg8SxyEIe+liZSI8STvRmO
oLWD9brn0/fbuji7eQvyE8DJhg1wPobK8b8B9t1D89ho3pEK4Z3Uz4y72gPxA0SS
Vt271L39Lg2m5JAwQ2IjJbxCGK/o8KEdusQ8jSWnhLI+Ivoy/cQ3GMNMoYB4ATNH
yrW7VP3HvSwOfIJ7v9wgmQ3mWdRgC4B8Wu4CAKyTHECo1v60RWQz11qyrLL4KkXO
z6pkrFJEZP2ooCzLR0EqvJbJ66ydCd2vHrFJgMx6GAF0GCJsGLXGxBCZmEYOvw4l
sjt9pzxBQzpLjLVWfwE/OC9pxKPFn/HU2v5Q9vwY2myv6cwDiyLTLi5UqT6KnxWx
AhL8ND9C/5haQBRskx+zwpiIcglz58Se7mh8bWh+jgGq7J8b0IHVAxEUPsHUjORU
VUzaULCLwhIKptnScoWnL9CmhtFF92V7XAM2r5WGV0DasyMDWSV1aVj6eCuT8eQB
w+tfY4prVErECnygyFQz3rCRtRSrUCEo7bDwWvAK+/YQ5yQcgkRzS/nyVYQvX22r
UEXurY9eRpuPLKl0CaLuLJYfLD3nncxTZGO+27lWcbO/0zrtCyZEZgqtSW1/Uqmb
IkC33gM4TMB0KTZMRu8ZrOSlL/XGQ7ghUv65+temPPR1gkP9qOo3VzlynOQmk6nq
UIUQXyL+S0lVDOMlHHPX
=OVc+
-----END PGP SIGNATURE-----

--Sig_/t=q.5VKKIIW+2ehID/WdjaA--
