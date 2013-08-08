Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3HHFtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:49:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38911 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3HHFtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:49:12 -0400
Date: Thu, 8 Aug 2013 15:49:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: linux-next: manual merge of the renesas tree with the leds tree
Message-Id: <20130808154908.bf713709a9672dcd95b33a30@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Aug_2013_15_49_08_+1000_rd09.PUEmHLNj+V."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Aug_2013_15_49_08_+1000_rd09.PUEmHLNj+V.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
drivers/leds/leds-renesas-tpu.c between commit 33d693e59c42 ("leds: use
dev_get_platdata()") from the leds tree and commit ae3e4c277669 ("leds:
Remove leds-renesas-tpu driver") from the renesas tree.

I fixed it up (the latter removed the file, so I did that) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Aug_2013_15_49_08_+1000_rd09.PUEmHLNj+V.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSAzFUAAoJEECxmPOUX5FEvCUP/jiiXwlszVgbmE/XmUkNovZd
s0RG4Dt92jx+dS22KP95N3pB832z5c9O0DqCiQIS1ZXtsPaLlfYYeSKmhnE52Kbb
Z6jNz9CPaFaX2k/ueUktAl21b8sMfiFz4eXsDCjUymmjXuErJExOoyiL5dcoNEFQ
xMmitGoAAVdSPtwc4/CbcMSJwxyP4Mn0nP/n6V2uFERfrSFuQNCS2seZ7boN938q
qTrUnVGi7qxbSH4GJCxt+zCwv+oTkC8KjSlMR/sfhUfiIgSKb7PG/DAOMLagn259
qdaqzyTux1KRa8yz3WeEvvt7zNxjZaZ/iGlmbilv+FtfmLb/8XEpHywESRVBs1VB
G0u5ZzUermIaPz7JRRspbagUGucK7Uie2sx/k85Mhr848iuKsG3G95h8xpE4hifS
2Ea1203VXIrwIr1447vvhDV6ijsGpx1kK+jXoQeK0J3n2L9ZB0ugQQXIrehLBgau
2aNVpHdu8sHyiGthD+v2WUKQfSx5oQkrEJsFWfu/aaaFxJtPqhOH1mngH5JrM3Xo
8VwjmFcAZt05vEn5wQUcXa1w+55zLOFKj3eN4LqossYMbqwRVY4xTkVi6s+aC9Mf
P7hTXNsdsO4to5vU3RwJqbd5L4vP3JJetyJ0VVms5Cjzg+apen4m0xnJm1nQS/QN
F79aTv/HnKnhnaJh5N+E
=OYr2
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Aug_2013_15_49_08_+1000_rd09.PUEmHLNj+V.--
