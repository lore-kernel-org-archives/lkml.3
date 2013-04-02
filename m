Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779Ab3DBB5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 21:57:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55681 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab3DBB5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 21:57:21 -0400
Date: Tue, 2 Apr 2013 12:57:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the slave-dma tree
Message-Id: <20130402125711.02c750493475fc6a119ef3d8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_12_57_11_+1100_sgE.GxbBGv0E=4Uw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_12_57_11_+1100_sgE.GxbBGv0E=4Uw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

After merging the slave-dma tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/netdevice.h:38:0,
                 from arch/x86/net/bpf_jit_comp.c:12:
include/linux/dmaengine.h:973:1: error: expected identifier or '(' before '=
>>' token

And many, many more :-(

Caused by commit 896b29f155cf ("Merge branch 'for-linus' into next").

Please at least build test your tree *before* publishing it :-(

I have used the slave-dma tree from next-20130328 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Apr_2013_12_57_11_+1100_sgE.GxbBGv0E=4Uw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJRWjr3AAoJEECxmPOUX5FEPNcP+LO/jYSWnXGS5zStcgmnf6Vx
Dl0jSqYx09SDaZ3LtamlBsoOGip0dqU+FB1SJxbfEko0IgSAa8g/VwVKgDW5LFvQ
nZILCFL4J9gspYOvv46r0f3IPG5uqGrOH7Jf5RCO6c2JUGkuYPNcgcHaqYyHG2B/
MaUbvNSNPjVEqfvcJwZOXFU/AKsRrOxpWeXs6s1tA64dOY4epg3/XhdrjhFzo/DV
Z/QiES9+v2Y15852ODeXGRUt8UNDxZue0QEUfqItkpVKId3a4ijORiafg/4p0cza
uygjuCVtYbmzrIelwwmYt4CUodURc4R/n2LaATMs2jpCQ8nFObtaRhzryV1wAdhK
SW5C7vOZSTaOxSjo/AKN8BVBFSna/u2WLdzYrKvjm5/kY0XdXuCeStdl2MbJ7Fet
Dlns7rIvepCKtm1r5Tqle37gbFEbljGEUZikhOxhLB/Mg809HjFBlaXJ7gm5A7tT
28kJCxzhp/aDlnSKTVLrf7eMketpY0CD2obB7sKgHBdBbmtNc3nl/+FB96tZYuuK
6EmOZxqWze749B6shEBbEgG7kP2Lb0S1t3qiGqJBo5Koq8ktoMkpSW22FV3SiZGv
x0SfBLuYvmWzF4P/b9lCA4iUPKSu4iE/HYToUwtkFJf1mcjmEizrtwZDHffpb7T6
N/CIlWmie9pzyRrz82M=
=eaox
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_12_57_11_+1100_sgE.GxbBGv0E=4Uw--
