Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3CUEYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 00:24:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33559 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab3CUEYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 00:24:24 -0400
Date: Thu, 21 Mar 2013 15:24:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20130321152421.94d213e7b520c5affb1acd19@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_15_24_21_+1100_shKXq8YxKs_IjKRY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_15_24_21_+1100_shKXq8YxKs_IjKRY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/ehci-timer.c between commit d714aaf64946 ("USB: EHCI:
fix regression in QH unlinking") from the usb.current tree and commit
60fd4aa742a0 ("USB: EHCI: reorganize ehci_iaa_watchdog()") from the usb
tree.

I assume that the latter fixed the problem fixed by the former, so just
used the latter and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Mar_2013_15_24_21_+1100_shKXq8YxKs_IjKRY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSot1AAoJEECxmPOUX5FEO6cQAKkl2j3TwuC6kIt+FHDzFFyB
r747eSfDJGuYmJeEM8kpFkUu56gfpBwLDoRHJwDYg1z1CGHBS4KDbSQNVzDxlQAy
0Byx1bHfgnXuccFDATgk3wpYW0kID49nKb+uH5WXXQLtWMVA2DzRw5G2MmV0oMy1
cjr4Obozto+fvQFQCil4XTnhJCEcjH4xqProB+x2r8VHNbK823T8Oo0GQC4TJyVr
oRLFuH+V5MEeVX3YE6MnZXrbZ73X9PzdbamXVmB5wo2cCdiicNqMfGirfbtgFtfQ
/N/KKSdnubWTBGYQ4pCJ4KF0z2fNJ9HN0F+p2JzqvO7L1LinMMyUfC5flcLI1LG+
g9Z113fGU94YAgxUkTTmnVV+7P++LjJaYkNu4Zqna4NeWk6yvGrsAato0+M27Aii
hi58OTX8txYv0BF9H1AtfYih+aqxRnNEBx84/SyFNL5d70pE6D6yqJvQhNY/PqIn
AbSvqHI2DMZpZlgApgLM30+o7VaODcTzJQWbYhiKvOlpSUE9Hnv0F+4t4D+AKkDl
XMpl1kg5SRJERkkGkKPt2Y4R0dQ29jkq/P4wvtDYCPgfWSk8I+TO8FxB5j7Ws+Lf
KadRX5HNo/FrL8EM805F+ABf6u7fAvyZi00c9vzgEPujIWBpG+UA3X5s8yelCRSx
7rq1iBo3bltl8V1L2184
=kvjt
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_15_24_21_+1100_shKXq8YxKs_IjKRY--
