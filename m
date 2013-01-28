Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3A1Kq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:46:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42736 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3A1Kqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:46:54 -0500
Date: Mon, 28 Jan 2013 21:46:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: linux-next: build failure after merge of the usb tree
Message-Id: <20130128214644.a3906eecaf9123b05216dcaf@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Jan_2013_21_46_44_+1100_t8=fYUS2Ub9MwPvf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jan_2013_21_46_44_+1100_t8=fYUS2Ub9MwPvf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/usb/core/usb-acpi.c: In function 'usb_acpi_register_power_resources=
':
drivers/usb/core/usb-acpi.c:226:2: error: implicit declaration of function =
'acpi_power_resource_register_device' [-Werror=3Dimplicit-function-declarat=
ion]
drivers/usb/core/usb-acpi.c: In function 'usb_acpi_unregister_power_resourc=
es':
drivers/usb/core/usb-acpi.c:234:3: error: implicit declaration of function =
'acpi_power_resource_unregister_device' [-Werror=3Dimplicit-function-declar=
ation]

Caused by commit 88bb965ed711 ("usb: Register usb port's acpi power
resources").

I have used the usb tree from next-20130125 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_Jan_2013_21_46_44_+1100_t8=fYUS2Ub9MwPvf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRBlcUAAoJEECxmPOUX5FEt7UP/2R7LLeoZ8uJLkLynwhnhMJC
9DZCM3AfVjs/XB2+dsW2aGqNC7z2WhUCF3dld/LQnVWpaiCTj85nPdbYDTDDRXa7
WIlUy/ZjgffcczDdaCxaboDdGew4ZDYzyNvfITKKB1t1lj+OhsyPZ73itTjIxdy8
uUaI52jd35kEOKtK+5q38/PVSthUZLjPAyGe7A31Nw0D/bl/qCrSEEaZWo/IgpIm
f/IISAxSjakxQFoKiCrumv6/y2it3S4mdN9mejJ2dLUc5dZkc2U9dj8gUww5sgiI
aK5x9nRz+lcOhnzSKS4zNQ6CCHO9+AUm9EpNsFsk2O6EXqdHdLIid+lqOsCqvM+0
g9ovf1hoojDnsG4dAHH+KX67DeNEVPvq6TIFHmPd2vV1i54d1QaWYz2xVTa4bMtc
S182QPHM/DjrWuUE/zz5y6BVQ4vuXsy0Be/vG2N/jVNuOvB2eDJFAce3b3kntmvq
5/PFIyYpuB62n/D7/qGGCnWQpWSADwrPPwlqiiy/Yu0L3NN2C8nibZ+oH1ZLGDys
vhJd+/P6QCQd9RLP/7tN/be5x/ytPQV0N1pE5gcIxtkt9wCqRBBfa35k4zSjFuQF
EcZgWcGowFOVXifB+omwpkTBdaXzfmlffXcQ/BlhonU/S8yrZ3C73YKlkNZ4U/Yd
d3frR6Vvg8rBl+9A8LGp
=XWUx
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jan_2013_21_46_44_+1100_t8=fYUS2Ub9MwPvf--
