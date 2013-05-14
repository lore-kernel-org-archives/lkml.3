Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab3ENXZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 19:25:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55040 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab3ENXZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 19:25:17 -0400
Date: Wed, 15 May 2013 09:25:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: comment on the kbuild tree
Message-Id: <20130515092505.294f3a8865c77e8420d27491@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_May_2013_09_25_05_+1000_xSiZecf4YOkDhSwu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_May_2013_09_25_05_+1000_xSiZecf4YOkDhSwu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Since the kbuild tree now consists only of merge commits (relative to
v3.10-rc1), you might as well just reset it to v3.10-rc1 and have a nice
clean tree to start from.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__15_May_2013_09_25_05_+1000_xSiZecf4YOkDhSwu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRksfRAAoJEECxmPOUX5FEPswP/3u4BsvwxyykepvBOVI+1wWm
D9rlgfHhApHl3/IrD1/uUZrM56NpYJ0tLxJ5a2gIpjxM1/cCB8PeXUucV1456tDt
yPfjJm6PdcvxgfhMWnIElDWcG+9Ac/P7bgWcU0j8LmNHNHsD/6HQkOeG62pY9DBA
tyeWltbtWK2DJURrEsz0IHyxeG2Qg+CPng+MHYonMc/fBX/lhBHUzb3pGBsW46zI
LTt1XUc52/W+Wn7fH1C1tyFqo56Ff1abRyOmm+0ZndqLIwQigg4xKgRPPqQ3EUee
lFyKqVqLd5bBQ5aOmQ6ABbY6wOFUBuZGZpFsnC7F+7qz/HwsU3LFfR8c2AoPHZ2T
LLgGH8gCl4wkOYo4iHojZmKWynCLX2PomFBKrx95Odec+S6Mag7ErfmuT/hX6KXP
BOFD8/rFcQKTkBcQ2s3n9jiaHgrzu678ieTD4X9mqHyWmKvLJ0k+B/jrFPghjhVV
5XJTWih5ZQ492nxx91sgUVdKx2jYbMwFNbaqLH0Vrdrno0KwUmyO7ZRT2+Y4mA87
gQo1ZSl13D1lSdMPoqnN3QPDYKQnBDYrOJYm4PPD2EdiLOTlG9U5FNwKdFHbO52b
2o8LCmjoh1f3Sinkn3ueFegFkDV1guU7MXlfv4fAptRCnIC2WZcYtXIsn0R0kVsq
hWtvnIOj7KHJVOBqzSqj
=OrrJ
-----END PGP SIGNATURE-----

--Signature=_Wed__15_May_2013_09_25_05_+1000_xSiZecf4YOkDhSwu--
