Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3FFGSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 02:18:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50659 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3FFGSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 02:18:46 -0400
Date: Thu, 6 Jun 2013 16:18:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20130606161836.df5aebcf5ce5be2b42154f2d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Jun_2013_16_18_36_+1000_9NcOcakEZh6vchJV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Jun_2013_16_18_36_+1000_9NcOcakEZh6vchJV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

drivers/rtc/class.c: In function 'rtc_init':
drivers/rtc/class.c:339:18: error: lvalue required as unary '&' operand

Caused by commit c5a32d622261 ("drivers/rtc/class: convert from Legacy pm
ops to dev_pm_ops") from the akpm tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Jun_2013_16_18_36_+1000_9NcOcakEZh6vchJV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsCnAAAoJEECxmPOUX5FEXbQP/0/HJosn060BpLk0WMzA2NqM
uTrLoqMyrzzBhlZGIKUaQ0TEVHTMQhcB+8EqrK+kFb53wgcu40yxQPTY96a1ZDJo
KMvZ0FJNSFTG/dgLdCAoMdMBIQ9/CfK67bn84lYxvcdJ0hacVD7WM8NbX+Zvx53T
n+4NW5TR5CeKLYkGj/lfqTcPbHhAXHALg3Cgq4sNDJM1esUtSg51oTAvbJmHPwsw
pQaIeSZ7eqPVSVuoa4kYbgBRMxdPwKeCwcptijkEDnzAhGMshW3TdBITZL0gke3k
FFbOZ+icaeTdD01pZL8c32uhlN3CrItZ0+p2b8ZFZbgsPkwkK6hU4ejAFpvkFsY9
rBayGSiPBHvMn72oRZyesMHP2VhoMLiH6HKmaFQRtptWPKSv0yQEXoWASWjivU/M
fjQCKbrSKFlHUF1oeFf7FiWbySZk0sF5c0zKpz2E/Pw4DO/82ItPyZbCaP+xu+fi
TsAcn6eRFf3ilPwwHEX3WqwWbGJN6iAYhOTpep/LYQB1wvCxs56J8D2wCXQIS6vr
Kjr0cSE4L/HkG9GPx7cwvlVyZSyPbBYIJyfd6CGLkHsny9U35oxkLQhNY3f2kQF0
p3/cjS6ODcVzvRd0WwnGCaGmfhNVbblO9snX8/eCf6teorQ2I7dSZpyyShZ2BUPo
cK0y6Yec6TAfneMrCCSQ
=nkVG
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Jun_2013_16_18_36_+1000_9NcOcakEZh6vchJV--
