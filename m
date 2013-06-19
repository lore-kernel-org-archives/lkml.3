Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823Ab3FSGpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:45:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42214 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042Ab3FSGpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:45:30 -0400
Date: Wed, 19 Jun 2013 16:45:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: linux-next: manual merge of the samsung tree with the usb tree
Message-Id: <20130619164521.f5477ccb559cc6c6f8b0a19a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_16_45_21_+1000__3CCRdVQ7BlCL.j+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_16_45_21_+1000__3CCRdVQ7BlCL.j+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
drivers/usb/Kconfig between commit d9ea21a77927 ("usb: host: make
USB_ARCH_HAS_?HCI obsolete") from the usb tree and commit 58d5b72088cc
("USB: Check for ARCH_EXYNOS separately") from the samsung tree.

I fixed it up (USB_ARCH_HAS_EHCI is no longer used) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Jun_2013_16_45_21_+1000__3CCRdVQ7BlCL.j+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwVOGAAoJEECxmPOUX5FED/8P/ikBJtIzlUjEVUvuTt3QUXc3
SeAuxrXIpWubilBI9JTygnOZ0b4KLQCoQ0oPB6ZIKpTgZkyu2RxgcUBG4MnRAdp2
U8RgI562YXFEDrRvZsbXLOWTUaclg0Qsn9f76VM7Mmner1E6HeiMZ69XsB7KE/ja
QXRZ6G1yxQkkrRNG+BE6volKGbQyJCr+f9FtamUlCaefCNxCJzgHZABoUp070GgE
EUbAs9v65NjgcDEn+FLimdxXUBfCUvnnGFHdtTFAp3sUIVHgj6OcW+zA3kXdI2q8
073tY4Jg9Bdy0IyULajpZHssCTmwXyzH0OBvwgV4/x76IK7JTDNiFCMIeEyRuqRP
4Djx/iVVnp4FdLsVoy2EEgJ92+qwlh6rcFwu8YLYeAQZRJYB4ctK5YyvyE30AOnb
HrJlMUIN9TJDcIAxdOyfw9N3ZPv412FHxC6glT/QX3KyWVzdecI3frcQAELMufRY
QuwTXncXuCcMKotFZ+KooIBbdAGQwatWM/Ud4wl9Hvl/dgImAScFg+9KN6jZd3s4
iRHtsrQlNdOC+bgxWZ8r4pYVzKkRcdzrpcaOv67+aVU0cbYnutsN1E7uSTFE+OLv
387BdZTYBSVUPVHfx9qHGc8Ncf7zRj7qigR8NNUu4JwQoe4awFesr4AJqjmnstPn
76UB7BFW2CUV6pjP9zXY
=QXbM
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_16_45_21_+1000__3CCRdVQ7BlCL.j+--
