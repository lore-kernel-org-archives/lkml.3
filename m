Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3C0A6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:58:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42471 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3C0A6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:58:02 -0400
Date: Wed, 27 Mar 2013 11:57:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-Id: <20130327115743.7d6c10f1e1c67f02e9c96ff8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Mar_2013_11_57_43_+1100_Nsh5HxZ5UA=__njk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Mar_2013_11_57_43_+1100_Nsh5HxZ5UA=__njk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
include/net/ipip.h between commit 330305cc4a6b ("pv4: Fix ip-header
identification for gso packets") from Linus' tree and commit c54419321455
("GRE: Refactor GRE tunneling code") from the net-next tree.

I just dropped the file (as the latter change did) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Mar_2013_11_57_43_+1100_Nsh5HxZ5UA=__njk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUkQHAAoJEECxmPOUX5FEgGcQAIpoYOTTVWNFnLPle4ds+Wdk
QA+vgzI/RM7vK3CGHC7dcDenJdAgp4bmxgFImiVOMR0PNYJ9se2EBFXN7krbrFXN
kJ/famdQJRnZKMw1Wd9na3Rcb1hLtHUe9ASErq4PKl41Cn0C4edwI9dBQcJJ13xJ
1uIg31IOZmZsakLoXw5V+l+BYYD3vSPJfGEw5EMDAtW6vKo5+NZFYmw3jABxRG5X
lm83qBXAaJsg1IV1J4ZzDUVfepE5djXIHpzlWeCLupdMnQx86WK1DwwmW8jLe29l
kkvQ3nThBUbOGSZ4ITfkZqNbxwQx3rWLlCysRvQzaEljt+fMilVqCC60MuWfTtTs
0mnu/Ednm/+aifaD3TQnWXDHAGNUvBnkMvffJ/qOH/2G8tyBuuTkFdXRbwW6ykU9
GV2+18E6jeTTjm3jDLASA1WhqrL1q7MdfR5giyML71JBkhr2ZupJmiUEwKHI1xqT
SCuP00bYXRUH5O5xP2s30E1tWXgUw954ghOSMfKexSxlky4IDvdTWborYKZ+p0s4
rtc1SNmBBrzYhYeALJl+vv2NefuqZJ1zGPl8tc2orINHlLiLaZNW8xti+YTaGh0Q
Wroam+2hy2Hmepy3omL37ivIuAgrOLYAF7iYgONFvGXtAlMgBHDDaNI18gT7qCdx
zf0brDL/LfNVzojNdvIA
=kTCc
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Mar_2013_11_57_43_+1100_Nsh5HxZ5UA=__njk--
