Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab3DKGVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 02:21:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37027 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3DKGVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 02:21:32 -0400
Date: Thu, 11 Apr 2013 16:21:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm-current
 tree
Message-Id: <20130411162121.02448747195d0d5fa6ce0124@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Apr_2013_16_21_21_+1000_he6lm2e_ZR3aEtnH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Apr_2013_16_21_21_+1000_he6lm2e_ZR3aEtnH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
arch/arm/configs/h7201_defconfig and arch/arm/configs/h7202_defconfig
between commit e42c3074c8f7 ("ARM: remove NWFPE and VFP emulation code
from the kernel") from the arm-current tree and commit 293eb135a924
("ARM: kill Hynix h720x platform") from the arm-soc tree.

The latter deleted the files, so I did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Apr_2013_16_21_21_+1000_he6lm2e_ZR3aEtnH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZlZhAAoJEECxmPOUX5FE3q0P/0jGr+SOS9auaLrslE1CGdKU
/Pn/Wunpd7Iqxc02s3jdHiasOgusxxG0Idx2uN/EAhjFYJdpweJWjQrym7+9V+rh
/UtG94rquMYdyeWvUFrB6cvfua3MJuKIGTmRdCCSnpKB3YDOi0Ht/5BHE8gbTx6E
bn6iX6qF1CReTrEvVu/I+jvMD6xyZqs0uz82S4RvbcsA6Pw/ia4JZce4O3a8Kh+B
Z818xkLfeoHGUj7KN4Ju9MG14q5pAGu0KDWXIBA6etWYv+vWO665kaoq1/M4Okq9
XMR0r6g4fI41H7diacayNHGG5nfv1X2e0pIP2ClIy2mFUlLUDALKDChGEuVI6eo3
JO/L2qSSPRiS6p6f2Edmv8YnoBCDEowmlWOQzcCWPAFLrsY4l2gaobc/DfwPALSm
AsepYl20ghg3LV4fcQAopGlAhIcBsQiUH2NLwMgdna3XbaFVjEnXnYbVGzVqj1fV
10vtAeR3RmgZ85LQPhL+0U9IWNy7MbHz3aOofBna1jQBBYpb8gh9cResv6FC1Y4x
RQzXkoVyMuVLrXau6wH8meEYA2nDaEyme7CGUsv5eJBasPtUeFKY7A4G6ESdCXjI
IrP+xnsSv/fUAkFzHgG7yZOlR702rpHs0CJ/4Ni3ODkr7m4Qk+44bBXRoCCqkEIj
bZlgsd0yLSxaU9lFf4Zs
=lbZe
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Apr_2013_16_21_21_+1000_he6lm2e_ZR3aEtnH--
