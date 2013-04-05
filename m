Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161500Ab3DEFrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:47:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54482 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3DEFrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:47:07 -0400
Date: Fri, 5 Apr 2013 16:46:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: build warning after merge of the wireless-next tree
Message-Id: <20130405164657.e6d914b120679150a4395801@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Apr_2013_16_46_57_+1100_guOwB15ab7L3ykI4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Apr_2013_16_46_57_+1100_guOwB15ab7L3ykI4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (powerpc
allyesconfig) produced these warnings:

In file included from drivers/net/wireless/rtlwifi/rtl8188ee/dm.c:38:0:
drivers/net/wireless/rtlwifi/rtl8188ee/trx.h:553:6: warning: "__LITTLE_ENDI=
AN" is not defined [-Wundef]
drivers/net/wireless/rtlwifi/rtl8188ee/trx.h:577:5: warning: "__LITTLE_ENDI=
AN" is not defined [-Wundef]
In file included from drivers/net/wireless/rtlwifi/rtl8188ee/trx.c:37:0:
drivers/net/wireless/rtlwifi/rtl8188ee/trx.h:553:6: warning: "__LITTLE_ENDI=
AN" is not defined [-Wundef]
drivers/net/wireless/rtlwifi/rtl8188ee/trx.h:577:5: warning: "__LITTLE_ENDI=
AN" is not defined [-Wundef]
In file included from drivers/net/wireless/rtlwifi/rtl8188ee/sw.c:39:0:
drivers/net/wireless/rtlwifi/rtl8188ee/trx.h:553:6: warning: "__LITTLE_ENDI=
AN" is not defined [-Wundef]
drivers/net/wireless/rtlwifi/rtl8188ee/trx.h:577:5: warning: "__LITTLE_ENDI=
AN" is not defined [-Wundef]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__5_Apr_2013_16_46_57_+1100_guOwB15ab7L3ykI4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXmVRAAoJEECxmPOUX5FEmBwP/2T2O8Yfl+s79UGlQFPJ822g
pRChFigiJJmRQVPyOXTVM8UxjNtYzGa1uArRkfs0XKYb8CIa3Y22IIUB67ESq8TN
iZqw6R/nGUQE+zxUg9KmmVYpVCYGGH4c7wUs+Q2ZK8UaBEIZq/QNmBuN9yiE9exI
L+mPGkdugt60v50F+f2NKt0QQHz4Hs71ds00LWdASCBX3Mhmd6rQY3x0mqgUj+EN
Tbz4Gj6ikVhAHAJI0G9ENEf5qnrFtGhs9KVGlxm0hRMdLoj0bN98L2oAmQDXiIsE
J1vP+zSyuIDtOAPu/igLQVz4VhuYubKmBEB+SLKr4tR3H+YejoS7ttfy/+QivBN2
tPORyoeMgwDLIVWQqT1FT1pjOcquZ7Gcq80QlPuA9iF9e0y2+YlJxcAFx+EI0y2y
kqwBgVxspPMlsvK5IGk080+E3HCPsB0QbevPMSVSImUOxWR1KyAPt4JTTW/DUnQT
FHsMV0QIqxf1yMN9CcvWqYPes429jFsprUpsOBck1ztuxWsgO2F/aZt/72LtWMBs
ft+ZVbrrxMZgFEV+W6iXTbtZ+czY1Lkwx0etDHfep35U2/nIpiBEPAH74Lse3Pgd
8DLWDFlHx42YZlEH0Q604KBYZvktKhsJwaYIy0nJq5VEEPHGcu9TqlkLTGxUFOd8
uzZLPUjkhsxlB1ASMVD8
=W234
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Apr_2013_16_46_57_+1100_guOwB15ab7L3ykI4--
