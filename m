Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab3DBCeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:34:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43840 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab3DBCeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:34:10 -0400
Date: Tue, 2 Apr 2013 13:34:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20130402133400.017b4ec5cd37725b32aa8079@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_13_34_00_+1100_OA2HZUjxFOSoNE_w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_13_34_00_+1100_OA2HZUjxFOSoNE_w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/wireless/rtlwifi/rtl8188ee/dm.c:30:18: fatal error: wifi.h: No =
such file or directory

Caused by commit f0eb856e0b6c ("rtlwifi: rtl8188ee: Add new driver").
Forgot a file?

I have used the wireless-next tree from next-20130328 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Apr_2013_13_34_00_+1100_OA2HZUjxFOSoNE_w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWkOYAAoJEECxmPOUX5FEAPIP/R8IVe2YhYk52CcrgoZjx5WT
KxCkF+78C6m/F8Tr7d3ucWkUzGFg5gFZCTo8fVsRRv8WLVk1t6OentE0MlpVFKfY
C0N1jLPpXSckGHvHIqbdVZIVRKDWEBFtUrgdzStX8RwaStjnHYJscXraqnOttYiB
275W6UKqnLOwlUpc1IDtwZfWMKthSbKI+gaMrnvIyCr7jiPEQXphk2h/MdM7i5op
C5rN+oUKVdUQKf0+WtQrWZtV+rGVzwCmU2RtSPxO4bhho+XlnEIOVXSaqcWGIZGk
M+8hxRmitB9w3jkCJwuzJGf9S8XwDZ4Z9F3sTVs0/8D1w2yOjho/+4A3MFCbXPZA
aT7KKUSftIVkJSqyuNgPRwSUt6KGjSZAZAtebbsZ8ItNFE64kBTW1mBSWID4WDfA
QsLJCZR7HZM+6R0gmy2vRSJAtQMjAeIQuTaeRJDGf6y80dqLRzD2HCas2/gkjloJ
PvEV7uqh6ZJViJZfmC96CfQRM0ZY1nrSSKXdNWFba2YivIlznb8APPRkT/7KuAP4
xCwMRn8Jn4Dqjhtmn+ODq4akgmBtZpzvCrgWIWkLc7TW9lf0tjRr4lfuFUU2utzn
mvLPiOBItAT1CxGHCpGo72Yz7jehn9SYxshLIqKD3V2bMzf6fyVy8rObjkkdKyDd
8xkIevo9eB7H8FvlKOow
=w3K+
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_13_34_00_+1100_OA2HZUjxFOSoNE_w--
