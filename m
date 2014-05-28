Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaE1Hzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:55:40 -0400
Received: from ozlabs.org ([103.22.144.67]:37252 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaE1Hzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:55:39 -0400
Date: Wed, 28 May 2014 17:55:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Joerg Roedel <joro@8bytes.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Cho KyongHo <pullip.cho@samsung.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: linux-next: manual merge of the driver-core tree with the iommu
 tree
Message-ID: <20140528175531.4ce48afd@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/B=P+xlFUy+oHLya+Tx2d/OR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/B=P+xlFUy+oHLya+Tx2d/OR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/iommu/exynos-iommu.c between commit 7222e8db2d50
("iommu/exynos: Fix build errors") from the iommu tree and commit
8283b4919e00 ("driver core: dev_set_drvdata can no longer fail") from
the driver-core tree.

I fixed it up (the former removed the code changed by the latter) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/B=P+xlFUy+oHLya+Tx2d/OR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThZZ3AAoJEMDTa8Ir7ZwVfZQP/0OF9VrjcAIhJkrRKBdaACB1
nHPy0OhaCxMNwtYUXN+qcilW9z6f9vA5fubbkyXNzMlIwMhEZ8eqdylk0bbFhMbr
Ot5FlEkqYnsEhNCjYSzYbAwMLcEL+v5r3YCbdCE07llm4d8zI4Tz0AkrGbwQrN+k
vbu12RIu0TdhvPZUWCeMsCg9QXp7CzonGQhHI3O+tq0zSXSZDYTvag8Gc4OZZLJU
UzFm0x2JcxCUSmq1ArWe1mkGaRmva4pZluriCMgasoRRCuUrdQg9+poKprB1iIl4
tifrYVp2LPNv3PMn42Z+pVpn0whE8ELpdA8CoZYoNERCS7bQ02I0TnZPdtX26VYj
0dK3XtzRAEGovAXKkJqT63U1GfS0/E/NtD4hjcyZMjn1r5xFe+XnmMKusz5tiuRA
kmtn3KPeO/m6zDHHAamae/qL4km1huTPKSW2hqKyAtt2Zk7S+5HpNL4GodPBgCBe
ok2mLdgISWF55KI4ce1oMVC+TQobZuJKKj7cv9hTtKOMq1mbwv/SonFIxLN7Hr6/
nKeBKekt3R+IKIRMYr+nx1zV+f2rFoMOauD+CBhMztj5ZmnfFvg9AyXBYzvfwqzz
CQ1Q8gt3c6pw1X8KSlF9n8GVSejNezmGRUk1biHDq4v5LT/GP8aKLzY6uDv6BsSY
tS3Lq6LYBM6piT+xjrZP
=EADr
-----END PGP SIGNATURE-----

--Sig_/B=P+xlFUy+oHLya+Tx2d/OR--
