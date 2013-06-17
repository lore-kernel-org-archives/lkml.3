Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3FQI3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:29:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54410 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3FQI3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:29:43 -0400
Date: Mon, 17 Jun 2013 18:29:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the ceph tree
Message-Id: <20130617182934.8aab7e40dc01c91702b564b1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_18_29_34_+1000_bN=qlaK0tL8_JO3I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_18_29_34_+1000_bN=qlaK0tL8_JO3I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

After merging the ceph tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/block/rbd.c: In function 'rbd_release':
drivers/block/rbd.c:510:2: warning: 'return' with a value, in function retu=
rning void [enabled by default]
  return 0;
  ^

Caused by commit f28d6bf9ef4d ("Merge remote-tracking branch
'linus/master' into testing").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Jun_2013_18_29_34_+1000_bN=qlaK0tL8_JO3I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvsjyAAoJEECxmPOUX5FEhsgP/1Tqc9s8pTvy/HJNFOrhmmvL
fHwNvRpFYt2Z6gli5l7vmQt5mTgWqt5T9MgP1uiXQM2OVTsazsfwid/Qx1Paq0lG
53RyRK9zAIhIHcX2etQy5PBuBg3XfZsXeKyZdpHNiYhKH0tG/USbs+dfl5Tmh4BL
Cx+IPCCI5wHn5mDGsjuYFwCTvAT/YuaRw4A9pcCeBDylZ5c0RALwecaoseW98gwi
VX0AJSWee107gFXvyTNtdEi5TKArAViLCxR5TqaFqverRtcgHZs9UG6JE8t3yxzA
BNb3Rx67EDFr6UefClzhaNI1R185JEoqxKEGSjjoNwROsmj7MBDNqaijrucfpnkn
639ZjI5TOTl1Dh26/KS6i4vkr6//yamvtXTNroN9KsttInxtN+sIR2Ma225MOtiE
Wm8cFmn0Ya3/1uGMRZqzsNg8ZSS6whFj1pXoT48X0Hd0ZfKUYH3XYw2oVAh866Dg
iPGzkieajKVQsJU4sA1FDoZZfYVLLE3l+K72+NaIL41k2NbWQrfEVnzaNgnlbc6b
FsUrXGobzL4qCAXw06KRrkQH4R3PagTOCAJTqH9l1lEFx9HhfctQxUZ1x0vV1GhH
UdeVhy172LYuxyiklMuHm/uT5hqhgUD8zkFrZHNtJK9h6W6hT2gebZYLHR50P7NG
bMrrYnEjGaTcGxnCAfui
=SIFx
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_18_29_34_+1000_bN=qlaK0tL8_JO3I--
