Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935980Ab3DJISq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:18:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41597 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3DJISo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:18:44 -0400
Date: Wed, 10 Apr 2013 18:18:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: linux-next: build warning after merge of the akpm tree
Message-Id: <20130410181836.e3d308a710e35f540f57b779@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_18_18_36_+1000_UzIo=9.HkblMCYzs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_18_18_36_+1000_UzIo=9.HkblMCYzs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

include/linux/genalloc.h:109:3: warning: 'struct device' declared inside pa=
rameter list [enabled by default]
include/linux/genalloc.h:109:3: warning: its scope is only this definition =
or declaration, which is probably not what you want [enabled by default]
include/linux/genalloc.h:110:49: warning: 'struct device' declared inside p=
arameter list [enabled by default]

Introduced by commit 3f364a866cf1 ("genalloc: add devres support, allow
to find a managed pool by device")
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Apr_2013_18_18_36_+1000_UzIo=9.HkblMCYzs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZSBcAAoJEECxmPOUX5FEcKwP/3mgbVqLTr9SYTXrWlG117N5
VXrFql03QTM+PXO24cSGb3m6UZhyi9Luz6h1ibGNzrtnmbvFktXSlyhrYw8wjaDo
fQDpqzecImCRIfmVPhkb4dW6wmrLtFd70Eczk4sJn9HfM9H81ciS+hLuQvhnUbQJ
z63LJyadOs6NTNocmdT3YoBaWuxtlQtmbunjXhOc0m159BHR7A/XwJqN016IBOAm
8U0buL8Vu17ADixiNHvXpJtjbC1v+c27G8Q36eU7Jya95z61IY6A7YtSakuNINsk
M03/S1BBA9R6GGALwbYGppdIBRYQfzgkKPTNa8GOXlg2bq2iY/3E1ZMXd3pefEWv
CmpYUvoi3vOcbXzUKOC0MIS9pozakyqzxCNcnILC8y+9NAVZd+kvux+oVLGnN62L
rIZ28J9jftrY9sr53U4/8jBCaV07MIxhA4gQDwc7txhM++AMdXLuOEnf6bJpILiQ
N7Z7h3A/nXbmQS2+VCphmaU2tXXAfAsD/yLiWQXZ4J/bEiQ3KBJ7YGiQFlBuPjCQ
WwWceBPNIeB35X9lyKNfMfyMazNAsjLp/XOH1d9SlUxcXJke42axPk6qaJ6xUojM
o9cFpTi92o8Jz2K4hPxBKhSs6QbrVKpKdShL2XdBelVgy587qnZokWxuIDqRQooW
Ea59aEhi3KICyBjAY66F
=PzsU
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_18_18_36_+1000_UzIo=9.HkblMCYzs--
