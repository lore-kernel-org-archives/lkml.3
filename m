Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3F1GB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 02:01:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44675 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab3F1GB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 02:01:27 -0400
Date: Fri, 28 Jun 2013 16:01:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the arm-soc tree with the mfd tree
Message-Id: <20130628160114.b80eb381637462072d7e674c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Jun_2013_16_01_14_+1000_LBOQn6C7tm5vp2QR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Jun_2013_16_01_14_+1000_LBOQn6C7tm5vp2QR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-exynos/mach-universal_c210.c between commit 555183096fc7
("regulator: max8998: Use arrays for specifying voltages in platform
data") from the mfd tree and commit ca9143501c30 ("ARM: EXYNOS: Remove
unused board files") from the arm-soc tree.

I just removed the file and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__28_Jun_2013_16_01_14_+1000_LBOQn6C7tm5vp2QR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRzSauAAoJEECxmPOUX5FEkyQQAJnNx1ZDp7BVUo7EP1QiKxb2
NtyJWMt0/eMB6f72hK3lZvISkMjJv9KYwDR6kUBtn3piPdWHhYo9WuCTxDqpUx0U
n8V6MKLXhsP19OTDbOBhUvuHjm59fQBi3TwscJFWxq+USCVHoFhIB1r9lbT1OaI+
s3vam6J//Z0q+svGBx3reFIGzKNea/zt0/E0hyD1oCFHyOOGtAR7EAgK0OwhWdTS
8XF2nIlr3c0sS5jf6Bc8YjA3s0w0eBpyrrgplk4EhVDhmkz4nCjNV86idMkzVz/+
nV7PpeaU+Lgj1CjkP4uVue+XSIMIG+CrDovWQ0tE4e/bHxoe/0D7vn2+an2aelB3
wP48kNBNBSRI5q8y36xc0Z7kwQ1ujPK+wFyp4pafKTy0u3lMeWYVsunHMl8ShaNz
1Jk7ANIcOK5/gy/yPTGukccrhV9g2+JIoof13hAQqXQP0aWl3yKUADDN1mRfwg5X
Gah1216heZJVVGMz1s2lbDUxjpOODUG5QnvWP/oaHro5N1xO4P9ID2mv6rEHBpAW
BHv1V5T53jqVd/hsdk+hJbslLP9HH0Wcvee+KVla8bzrNkxCiIqA66gynodIdIIt
aQXqTneOytSnj1BR1bWGBA5zhmrKJQAd3Hp+bVEHb9M/za3CJoksWE51CRSnsRcS
zTbV/NAe3pMPZfQiYhA1
=L5BA
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Jun_2013_16_01_14_+1000_LBOQn6C7tm5vp2QR--
