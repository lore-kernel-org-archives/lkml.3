Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3GWBc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:32:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33388 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3GWBc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:32:57 -0400
Date: Tue, 23 Jul 2013 11:32:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20130723113245.a71f780b34193953a4a5cb45@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__23_Jul_2013_11_32_45_+1000_8Apl0CU3gSj.F/VM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Jul_2013_11_32_45_+1000_8Apl0CU3gSj.F/VM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/ethernet/broadcom/bgmac.c:19:27: fatal error: bcm47xx_nvram.h: =
No such file or directory
 #include <bcm47xx_nvram.h>
                           ^

That file only exists for the MIPS architecture ...

Caused by commit 6ffdead8027c ("bcma: make it possible to select SoC
support without mips").

I have used the version of the wireless-next tree from next-20130722 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__23_Jul_2013_11_32_45_+1000_8Apl0CU3gSj.F/VM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR7d1BAAoJEECxmPOUX5FEFKkQAJ/4HJR4p9BSAge3sLjcqQDH
Hsh5eWU7TYo7f0YU6X0wAm6tRMeCA8BLf2KdzkBffDNmRcC94ZZS0ZvEZJHzaiKY
ntHOLt/UP2ExoXPhuqrnYs4StezIAZx3Cr7bF0U/W3VH8haHZhPf/mdKe8KdMc1c
QWRS8BHFvzK61n91H+jvDafoBAbw9JCKjc0V32jhDgMim3gBWBelaTgOvA+h0/v3
lgn9s6W12Nz8waz0EgJfGJuUMzWZ6vJH9pCKleHcVx8yP43I3wBYsvt++BVricFX
XRh6TG04EurafRWUP2D95CiMqjbCLHJwhHvM75/yY3sjucMorV4G1T+l/qyk7tTT
exUvNGmtazb1UyU7VebFRvhEqyoa8SWv2Py7gBhFqFPizjocxxf3AwRZdB0bOiOC
1BuxdUZNPejX7A4QQIyXSVB4uTTLjyXt8EetbZNWsW6IU1x/cE95nxgpXm6wClAY
xUey3Oz/NuNSqXOsAYw9NtPGrHZSHkTzfaPngVTz2cxuIJyPV6y8O+FhzNC7E1vB
6GQKEEURW6aNRidT3y4QK+JoR4uTw8OxVMZFk1TMIdRxGnxUiWF1aJQs2p9/A6ZE
WokY5PL0D/Fmtj5DIFj9OE0B0AjVeRFbTe715YmR0qm4p20Zz5oLzn0hftLjiFir
SMdpH5JmPXhL8rXMf+Oo
=NTFf
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Jul_2013_11_32_45_+1000_8Apl0CU3gSj.F/VM--
