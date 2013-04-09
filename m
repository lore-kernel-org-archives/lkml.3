Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936157Ab3DIJJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:09:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49274 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935153Ab3DIJJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:09:10 -0400
Date: Tue, 9 Apr 2013 19:09:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the final tree (probably
 arm-soc tree related)
Message-Id: <20130409190900.97dcf3a70a9c0ad727b8bc4b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Apr_2013_19_09_00_+1000_l/BO6Y7/aCnWW/n8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Apr_2013_19_09_00_+1000_l/BO6Y7/aCnWW/n8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
produced these warnings:

arch/arm/mach-cns3xxx/Kconfig:2:warning: choice value used outside its choi=
ce group
arch/arm/mach-bcm2835/Kconfig:2:warning: choice value used outside its choi=
ce group
arch/arm/Kconfig:287:error: recursive dependency detected!
arch/arm/Kconfig:287:	choice <choice> contains symbol ARCH_CNS3XXX
arch/arm/Kconfig:366:	symbol ARCH_CNS3XXX depends on ARCH_MULTI_V6
arch/arm/Kconfig:933:	symbol ARCH_MULTI_V6 depends on ARCH_MULTIPLATFORM
arch/arm/Kconfig:292:	symbol ARCH_MULTIPLATFORM is part of choice <choice>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__9_Apr_2013_19_09_00_+1000_l/BO6Y7/aCnWW/n8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRY9qsAAoJEECxmPOUX5FEkrwP/RO3tTONZRnbZAnM6oqNn+wv
h0KTfqQgBMMpt0FkhdeJZ3oZS50dcHrR5dNik2aJPIlznz5K7LGtktDqwh612sdV
0yWhLEq7US4TpPDB4aQhm61NN+KYBq2b2Zga6FQHpVy3quJPDJogiY+/9bTXSzW3
+Kp/XHmCcdSJk4kvVdUnlllXB18HjZcwGEQpXD9MjmhzfMtSWXqUL5vMKaEDwlMt
lr7EbdCk0ShXHDZsHsm/cbGWL0Lci36U9AMZCMKHTI4PyUB+lau+xLIjN0yWlorg
rOub2Hf7hp2FI0UBtWF06M+slzDCkA+FUin2SdEuC3+mEWievnyFNp9mBf421AQr
Hf7+cA+kEMY7qXdST9a8tEbTl5e7lothpo6QF7KU0KjIPsYKT3Uq9kMIG+ZU2aV+
ltyDFwBoSQyIk33aZIgDJCfaEjktILcQZk2p4pvvcdy1tUKVzb8FYOoq1QuyuPbm
JnFc1/tEimVg4vQ8yC2ruTED2d0GKbDdN17sufi8/Zk1vCN/nfRc/JMC6Ud5cuTo
DW0/FNP5/VENhRxQb9jeayRVKHFS981/s6Bc/SD9aTYBl9cqFr257pARRxRkp0BF
gkR5VkpBEZbLRDfMrfgADFZvV1E5i7YqwxtiVzcPx/0GwNGHxjsf4DUITghcdKF2
Zk0mZjyz6RTKFQmMRiTf
=TFWG
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Apr_2013_19_09_00_+1000_l/BO6Y7/aCnWW/n8--
