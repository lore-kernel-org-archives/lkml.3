Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab3CZBSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 21:18:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42477 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024Ab3CZBSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 21:18:46 -0400
Date: Tue, 26 Mar 2013 12:18:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-Id: <20130326121836.bb1c6ab0cbc8dfd4ad39b0c3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_12_18_36_+1100_k24oGMSb_RbzhQ6."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_12_18_36_+1100_k24oGMSb_RbzhQ6.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
net/mac80211/sta_info.c between commit 27a737ff7cb0 ("mac80211: always
synchronize_net() during station removal") from the wireless tree and
commits 3b8d9c290364 ("mac80211: remove underscores from some key
functions") and 6d10e46be5ac ("mac80211: batch key free synchronize_net()")
from the wireless-next tree.

The latter seems to supercede the former, so I just used the latter and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Mar_2013_12_18_36_+1100_k24oGMSb_RbzhQ6.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUPdsAAoJEECxmPOUX5FED60P/2Qlo5UktIALmoOmaA2t8J4m
jvVmURddUK6Lh7OiWX1VZs9MW709jkpckLUkpxEFzZJ0i6ZSXDlvQx642xWN7ALc
j0rC/cFJCvuI7QzlmUSs9K+0Dz88Y+MmEAMUocHbts7SojvexgVV7I9ZFm0duz+e
AMgkq64nh6Jcq/ZzmQwXTsmox7WFEWC8krJyeA2T6qeKUbljhFl2Ga5aXavb3o7A
CfiUMQWqbbkYJez7T2VvMm0FXoDSAjfQNvVP79jC5Ms7dcpqOBTHr3z+nLznKeUV
kQjt48h0QuHH2rhvyNFQxLXiuLCY6ovxgU2110J0ivfuGAQXbNxoho1CNj1dO0cR
GNzou+DbrI2JeRQ6WkIQKffSoMvEJhz44AjlzlYhkgeetQLq796UKW8H0Qvoe3f8
Fd6u472ot+rGfLjyJWfrLbMYbh9aKI3E7keSbaiiR0jWGCJlN04YaFNFa4vze3gJ
nSuSZBeO29uxLLq033EhPqcuEw+AhaBSlRYmTa+rhK9ZpLOQqugUd/U3jloADCY7
ETCQQtT4NzY91eS96XUtq4W702Eyvcb6UnBs1mP8OqnatZS6zBWHzTyMouUaEqOV
4z9WnSTx+SSKUxXxYKBLE4Jk4TsVWiIPT9d7hLr3Xh03gBpJl1W5JjJ1YSdHfCXS
oCW5YoZXUJWJFPTTJRqi
=b6aL
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_12_18_36_+1100_k24oGMSb_RbzhQ6.--
