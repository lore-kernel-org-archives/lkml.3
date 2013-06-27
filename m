Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3F0DC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:02:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59892 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3F0DC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:02:26 -0400
Date: Thu, 27 Jun 2013 13:02:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>
Subject: linux-next: manual merge of the pm tree with the pci tree
Message-Id: <20130627130214.40aac4893b8cb75942b83191@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Jun_2013_13_02_14_+1000_IHRZBSNjuknHpuxg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Jun_2013_13_02_14_+1000_IHRZBSNjuknHpuxg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in MAINTAINERS
between commit 15fd830dd310 ("MAINTAINERS: Add ACPI folks for
ACPI-related things under drivers/pci") from the pci tree and commit
994b942fb4eb ("ACPI: Update MAINTAINERS file to include
Documentation/acpi") from the pm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc MAINTAINERS
index 6f30491,04a5fef..0000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -247,9 -242,8 +247,11 @@@ F:	drivers/acpi
  F:	drivers/pnp/pnpacpi/
  F:	include/linux/acpi.h
  F:	include/acpi/
 +F:	drivers/pci/*acpi*
 +F:	drivers/pci/*/*acpi*
 +F:	drivers/pci/*/*/*acpi*
+ F:	Documentation/acpi
+ F:	Documentation/ABI/testing/sysfs-bus-acpi
 =20
  ACPI FAN DRIVER
  M:	Zhang Rui <rui.zhang@intel.com>

--Signature=_Thu__27_Jun_2013_13_02_14_+1000_IHRZBSNjuknHpuxg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRy6s5AAoJEECxmPOUX5FEk6IP/23Y+HbdJq7AqzvW5mt31TKD
S2z+b1u1vEY0gmbSt3kICKctJW/zU7y7qA4NU1gA6uR259Meys+leAXVXCDtyO60
Tz5NB/z7YUYeqX2pLvxEWaQsjBS2xiqdkV/6kIHx1kDb8YFjCIgzkzuciwOB88Ec
GRQbwMOWZCnGzkSoUuHN2c6l1S2ICroEkKtulATag2sCbYOzEF/RqJvF7SPtW52D
J40B3YhZaPLOQBqNr5nL7VLiu+xN3hDMQZmub0iQ9rDr8auienajJBu+vQs5XhFQ
4cGRj/k8DroabWxKFXP+33aoVhHNIHFpY2/QP1GCJD7vUi4N2auQniEFnc2XraZd
8bnS3uAFLpNBkFkR+rbgzHuMMhKCznImV5dR0WZClhzq4VXj5uCnlVpPnDAJiG9d
eZbfSogsXKT0l+7NL7+vpyEqAF8SUTuGRF0cBIZutvYJzex1am2mwy1YZWy2ARHZ
DecfZvMISVj3DPVhXM7cX0AQ6DppeAuoyVU5eguFZ7eKNwhZF4OEcjkgJhIPD2ib
0D3ZnJGxEBEnyooWkAzphLDs8nIpbql57mEXFoGZLnlMwJaibMRhJwkBwiKajWTM
bl+sYvPsASInQOBg24OadePFf7wRQzgliGeUjg3WJzXUv3xO3bCyxeHnM2y7E5uy
tcGhVUWx1S6CB19S4NOa
=NY3K
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Jun_2013_13_02_14_+1000_IHRZBSNjuknHpuxg--
