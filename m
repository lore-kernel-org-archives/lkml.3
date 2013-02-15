Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab3BOF1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:27:24 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52712 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3BOF1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:27:23 -0500
Date: Fri, 15 Feb 2013 16:26:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Stevenson <david@avoncliff.com>
Subject: linux-next: build warning after merge of the char-misc tree
Message-Id: <20130215162657.6dd03d27e8cfed0c134b5dd3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Feb_2013_16_26_57_+1100_xPUy.XfF2RJRzw+y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2013_16_26_57_+1100_xPUy.XfF2RJRzw+y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the char-misc tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/w1/slaves/w1_therm.c: In function 'w1_therm_read':
drivers/w1/slaves/w1_therm.c:245:15: warning: 'crc' may be used uninitializ=
ed in this function [-Wuninitialized]

Its a false positive, but it was introduced by commit 867ff9880d5d
("w1_therm: Retries: remove old code add CRC")
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Feb_2013_16_26_57_+1100_xPUy.XfF2RJRzw+y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHcchAAoJEECxmPOUX5FEysMP/AnUIydr1FmO1inBdq9gL9U2
YKgMmnY50HioB8C9D8tnEgu3IDcBgKD5VqcCENH5PfvrrF566+IDlayuJyUfGRND
aEK+n6nGcDB8O0S7MYu5Cw1uiXM2JTQx+ih/dg/gfVscN4QYR/Dn4TmVPdjIYC8l
q9f8Riys7Ad0vo3UU6CYoFV+M0C5tF0i0kDDtGKOW+rU9P1Mty8n4x+9AfCwSBff
PP1CEjaNEBFvG2oGF/VHIZvHhEUxErg9AGNb6Hc7kOjtOYDW2fjSMD+Giv7WArPv
leTfgogx6V22EHvYHlXNjEIFP/TEotc4/usj5wohAleFyf/L4FoZhTZeRY3DlIH3
GlQFr7MeQVmWTCYkgj8SIeA/xjAPrSJ8+WXreAoNbe0r2UNctY1hhOZgVVUE3tUY
thA+2HRW5uIudjUOQR6MYeynlRsjfoajbra51jBcGKUyMWZw5jxCusDhjUhP/SA7
HBZTxJ1UQITneV0t9+WAhY189VsAsIuehP24Wa+m+ToQUTlZdJDEeOSICN37rvrC
Wezgj8fo2sji963XPtUZZt9kxsKH5rEygQxYssFF0ZmqPfPclMRHsmLdjakpoFs9
ur3XnRCmXVTrf19x2JsAuc9DpFGf4i+9+mqdBILC0EwOtgQQ2XTnYh4k1WmXQTCG
FA/LChaQAx5yMvwepMyn
=qeRR
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2013_16_26_57_+1100_xPUy.XfF2RJRzw+y--
