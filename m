Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaBZECJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 23:02:09 -0500
Received: from ozlabs.org ([203.10.76.45]:56833 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaBZECI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 23:02:08 -0500
Date: Wed, 26 Feb 2014 15:01:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>
Subject: linux-next: manual merge of the crypto tree with the arm-soc tree
Message-Id: <20140226150159.7ea5e60285ee9d0193bde811@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_15_01_59_+1100_mQ7SzSDg8/SNYd_V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_15_01_59_+1100_mQ7SzSDg8/SNYd_V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next merge of the crypto tree got a conflict in
drivers/char/hw_random/Kconfig between commit 2257ffbca73c ("hwrng: msm:
switch Kconfig to ARCH_QCOM depends") from the arm-soc tree and commit
f9bee046c915 ("hwrng: msm: switch Kconfig to ARCH_QCOM depends") from the
crypto tree.

Two version of the same patch ... I just kept the arm-soc version.

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Wed__26_Feb_2014_15_01_59_+1100_mQ7SzSDg8/SNYd_V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDWc8AAoJEMDTa8Ir7ZwVBY8P/R5vuzMJoriyt1Tgy4IcY3Ke
lepR565wi7BYri3uad2RIzmiXFjt+ReImyw4t0CGDny/ZasI/UkujSNTTBdhCsrt
Cmq+JEoPxoJJIdny0+ayQVpJkk9Mh1u8FH9NOPcohSMZXOCYxJl/es8eW6IxIfck
LfhkAGqeZ0lPBBJfLK4iy9Wk7NrrMfiOnnSkRK6dB5mQy+U7C5uwn5+tAkbzGoGn
+2OuDqDQnbLi399KMYhAdqcc8q2bYG16fywCKowaAtkN0F0/2oXDv7w8zDGX1T5J
V4ONom/MaiAGFqrRWpRMygUdypZ2X7y/DR8GKyAZwztUt2ey1W4+eUeTphGCCccm
B7VyayM2AEwKso4Ki3Id/yoX+CnImAfoacErD3AXo3ABC8bEJWuFBaPPK9rc2sd/
yVet8irmQMK3fxkZs2aA7FzKLpgCYPP/07blr/RlyQly3qoNPRkyyLKivQa2Qja+
yrJEjE8P+L20FOwE/G2H2VawAEw9PHJAPe+oyvxeR349UUlYsl2gGSyVeNeFhfAX
S8hucPcsLc+OSVlKBRJrbOV++zAIlCFFNXD15ErIoos7k8b0UWi4nqpgiRxTwTtY
YV/SL9t6+p4svOlCMvDxixdjMPqMa4JJWMXC16VW/Sw3A2UbuaN26ral7RKMlNFj
L5KIMcgSpT4L5lQwFp9L
=2/jK
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_15_01_59_+1100_mQ7SzSDg8/SNYd_V--
