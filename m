Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3FYHuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:50:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43137 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3FYHuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:50:10 -0400
Date: Tue, 25 Jun 2013 17:50:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: linux-next: manual merge of the samsung tree with the tip tree
Message-Id: <20130625175006.f3f3801f20c2d9dd9ff97842@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Jun_2013_17_50_06_+1000_1b5AvJdYsb_oAy9C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Jun_2013_17_50_06_+1000_1b5AvJdYsb_oAy9C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/plat-samsung/samsung-time.c between commit 38ff87f77af0
("sched_clock: Make ARM's sched_clock generic for all architectures")
from the tip tree and commit 5b8eaaab1668 ("ARM: SAMSUNG: Remove old
samsung-time driver") from the samsung tree.

The latter removed the file, so I did that, and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Jun_2013_17_50_06_+1000_1b5AvJdYsb_oAy9C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRyUuuAAoJEECxmPOUX5FEyWgQAJsIKd4qM2mzCtvgocColy8v
slnOprxgxSodt72qCm8bXF07dfepxyZLq+QHPxWuAIZTNAzC4XzvAQPwZk60RAQH
Zj9y431z/vd2A0PjUkJrOFzWEwH9OGASjcXVj9iQQA9RRFTbyJQQmKzp96WArxEg
E2eHwlEF9qMcPLkECUrCuFXJYJlzsjkluHr0p7kL8pEX2FTn0N7X65PR+cr/nsQZ
IhlZF9CQyldum6hKjYmlFIrPiSaujKQBukq9iBqTGb2LbLnNfnomGnJceAzr92sd
rhaMwVfx5b+Kf2ykQ5kfbMFSpiKHsmuKLsWmECFMBTak+x9CMyOVDxut24eTsfV6
89gITtqhqDLohB0GpDpSyDDTiIld80/nGrSuT745d4oC/9wo/kVGE/nCbWrE/tjq
DszN1dNjzahRL5bi/ABe+HsM9F2L5K29z+yj/BAyU/pjxioVRrP1G+7+LsH2PZ02
JvJ1m4kp35QSrJihk5G0+gLWX6ONj30bIdGkeJPrhKisdwo3k66OmLWAwsF3f/sL
C8H63icCYsmwjG8ynxW1+mxE0EF6hJJzc1ss5Eg6S0Awl7yqyvv8QSHxtL8dmc+E
HyxQnMJsNvZvI7FkEPXN0ZIDIAHwUFUnu/jcRCotMHdRriEDqKqaV/CB15Y/jnEm
9wXb0QVyGSCk8N05n0rm
=4FBP
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Jun_2013_17_50_06_+1000_1b5AvJdYsb_oAy9C--
