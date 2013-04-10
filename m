Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936283Ab3DJHRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:17:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35661 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3DJHRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:17:50 -0400
Date: Wed, 10 Apr 2013 17:17:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>,
        Kukjin Kim <kgene.kim@samsung.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the arm-soc tree with the pm tree
Message-Id: <20130410171743.2ffa67388b330991228a6775@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_17_17_43_+1000_ooEOTyZZyygsQj8M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_17_17_43_+1000_ooEOTyZZyygsQj8M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-s3c24xx/Kconfig between commit 785f40040874 ("cpufreq:
s3c24xx: move cpufreq driver to drivers/cpufreq") from the pm tree and
commits fb278af74b28 ("ARM: S3C24XX: Removed unneeded dependency on
CPU_S3C2410") and a4e4d22c6f53 ("ARM: S3C24XX: Removed unneeded
dependency on CPU_S3C2412") from the arm-soc tree.

I fixed it up by removing the sections from arch/arm/mach-s3c24xx/Kconfig
and can carry thefix as necessary (no action is required).

P.S. those arm-soc tree commits have a bad Author email address ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Apr_2013_17_17_43_+1000_ooEOTyZZyygsQj8M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZRIXAAoJEECxmPOUX5FEugUP/20P7BgYgGzsw2Cfx8MaWqyv
YFMKmEt1qXR7qRk4Yog2g8eJ/EvgZVg1xUOO5vV0TbUZOZYigDRBxPwfNTLLCD2y
ex0XpZ/ZvMD3EcRSA5LxteCN2GKU0P7XzdJ5YVK8rCn92fBTuuktNPGUHu439Ow0
oizsWDs5ZFKi15l+3zvBRIK3B1wknYLAcTirda//xycf3M75+QTXO2PODzonlOIx
Kia9NdZHfqlT+Wj626fFNdYvaXIm39a9hVuJ0wDSyKUazGJwmWEI/recdbtEELZu
ApIF1dwsH/qB0PIjYIrADtu80ifUNrt5Aejqb82NUDZGvOhBOH6Wm6EqEZFoEA8U
ymdy2iowNjtjPZfeo0tAum26sNmSsmC62vICyU1eFquB7/4GwiXNmy2KxAVXJi3q
lXAb+1QoE+jA+OqQ/NEpZy59YvBcMT7IubsV8JXcMBNvNS5KI0A07ToJYk0Qwve6
iU0ld65s8dwpnSOX7Ic3AT9QDxdrieOQiaWXFv0ty+eis7TH1mmgkNAfO7oF9vMF
aE8kOURBzEaKSil7TLtQqsJ0Sfi+o3wG5FUqeUJM/EHqlsZulCtBz4WjVgHcw5Je
edD+bPjOUHfZXDK25utzzV/8z/VH6d0UoVUG/ZVa+0dLf/TyH3oAERHmMwLtLSIE
vhEjDq98tW/tsQ1ET4d9
=kNLL
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_17_17_43_+1000_ooEOTyZZyygsQj8M--
