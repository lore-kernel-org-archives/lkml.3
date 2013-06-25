Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3FYHmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:42:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34868 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3FYHmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:42:05 -0400
Date: Tue, 25 Jun 2013 17:41:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Brown <davidb@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: linux-next: manual merge of the msm tree with the arm-soc tree
Message-Id: <20130625174152.d776ac051f6f19dfbf876634@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Jun_2013_17_41_52_+1000_Suul0g1m2A08o__k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Jun_2013_17_41_52_+1000_Suul0g1m2A08o__k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the msm tree got a conflict in
arch/arm/mach-msm/clock-debug.c between commit ad8c373c9aa3 ("arch: arm:
mach-msm: using strlcpy instead of strncpy") from the arm-soc tree and
commit 8cc7f5338e72 ("ARM: msm: Migrate to common clock framework") from
the msm tree.

The latter removed the file, so I did that, and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Jun_2013_17_41_52_+1000_Suul0g1m2A08o__k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRyUnFAAoJEECxmPOUX5FE6voP/3R6JCI8pjfgnqmqbGy67m+p
OS3h36Mk5lQWpMjj7s65Ub2EP3BW5Y9OuWkU5uofx02kFuTb7X0zzpGFRp5FWOo4
PhC5Qya4ni57XLjnZHI/l91mjt6HDV8vx5wIEEJXFn3mBE/UNVZ2/5b3q9ObH/iw
9To+dBriirfQeDZdr2PCmsF09KVP7wrEHNJiXHyI72wK/LhvyodZ9Nsey83frTVb
Z023V5oBDIWoTuSwc1iQTwrvKtVfcqN7mfo735ebDzcjyl58wvNE4GEjMlI8LvtO
FqppGxzn4BL6dKQwQ0087GHkiixZ5Z3G8hlyPfSX2GR35d/gzzV5ael8VxwdNsTH
6lCXKZvS/7tHPgUM1x+g6sfaOWqFafmY4uTomRVqhJ93O/T/ft5QQZzb3t6ygBoR
iY1DiHuhsCWKMMA+6RCelME/jC1upA5FpQAnxkKONwW2bZNWPNVCtHl0tMHDqNuh
TR8wdGhx6I791Dw4kArWW9GM+kxRjYH2AtX/+78QaGnts3woJdJrA924af9/3xfr
iuD+iS3UcAlxgRTr9Yzja5OOsQYo8yyrG/W+Yzm+XmnKAdanFT+3SQfo0FC5pbf+
oWjJ7PFEXw3bkhiVu6/Z24KqsLZM0AlmzCcUQdsDeyMZo/NUx5Mh9EuXM/FSbZx+
W01HWshSUrz91RlC24kq
=p5Ex
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Jun_2013_17_41_52_+1000_Suul0g1m2A08o__k--
