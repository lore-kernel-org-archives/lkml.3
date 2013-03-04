Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3CDEWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:22:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57513 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3CDEWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 23:22:38 -0500
Date: Mon, 4 Mar 2013 15:22:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next stats (Was: Linux 3.9-rc1)
Message-Id: <20130304152222.c0a3d97a4d6e4c5b0e343865@canb.auug.org.au>
In-Reply-To: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Mar_2013_15_22_22_+1100_mcDwM2B.cl6mSznY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Mar_2013_15_22_22_+1100_mcDwM2B.cl6mSznY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Mar 2013 16:28:25 -0800 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> It's been two weeks (ok, thirteen days, but close enough), and the
> merge window is closed, and I've cut the 3.9-rc1 release.
>=20
> I don't know if it's just me, but this merge window had more "Uhhuh"
> moments than I'm used to. I stopped merging a couple of times, because
> we had bugs that looked really scary, but thankfully each time people
> were on them like paparazzi on Justin Bieber. Special thanks to Peter,
> Ted and Rafael (and the people who reported the bugs too!) for being
> so responsive. It could have been so much worse.

Well here are this merge windows' stats:

(No merge commits counted, next-20130220 is the linux-next based exactly
on v3.8)

Commits in v3.9-rc1 (relative to v3.8): 10265
Commits in next-20130220:		 9903
Commits with the same SHA1:		 8493
Commits with the same patch_id:		  727	(1)
Commits with the same subject line:	   80	(1)

(1) not counting those in the lines above.

So commits in -rc1 that were "in" next-20130220:	9300	90.6%
						(down from 90.0% last time)
Commits in -rc1 that were not in next-20120722:		 965	9.4%

Pretty good, but it would be still nice to figure out where the last lot
came from.  I have the "git log --oneline --no-walk" list if someone wants =
them.

Some break down of the onelines list:

	grep for drm gives 134
		 btrfs gives 118
		 mips gives 85
		 ceph gives 41

Quite a few of the rest appear to be bug fixes.

As of today, there are 752 commits left in linux-next ... .  There are
161 commits in the akpm tree, 135 in the xen-two tree, 78 in the renesas
tree and everything else is in the noise.

There are also ~550 merge commits in there (not counting mine), so some
trees could definitely do with some cleaning up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Mar_2013_15_22_22_+1100_mcDwM2B.cl6mSznY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRNCF+AAoJEECxmPOUX5FEc7AP/RMOh5p81BAjQk3TdJUuH2q7
dyhx/zOxqyMNGxR1ax/6riYKJCNzC6QdGeu4YtXOeicWJm78COxTprZsNl116lYL
q7QDnCsfsUduM5PGZ+XfyFkgVua4mjOkGF1MzzrmR45bgFr+8YTIXONsI9nRfNqF
Kqo1UPHCH5Utv22DVjD7BlniKWsi2HjDXlNcCgZE4QQ7vcO3SabbOtx5vKnjivFi
rtpHGnPBNCMns2oguW+QUkoYX4e3XPK0RuvqBubT/5LuS/EGT8HJOcb9S/TRRVvQ
Wzq7pRLpYAq+TYN4H6GFNAGW3BNnrR98CIUr498m4OdceElFCl8czZ/xltF+qd9z
gwA8VeQYqud29RvusOWH3j1Sb1Ktv50I3wMJ/yDJcs0eugfAsig7G4lc1xmtJp5y
bDptT9qxHgpPnAikbgjoYL62mZTZOnO53LUPuniO06xPtaqUonjdMIEIp1kIPH/e
vCsRML8o34z6vVFtcRsZhKRlHFbk81IyzUg2whgRuCyqo4tK0ULmz8rmNnJBbz58
jMtEcSv8th/uWsi/g5rq4csMnXXwIpusTAIua3ueesvhn0BzvRcj7q9rmt390AAz
2eGLF19EpR40wwPL7+WYzRB7ZtiufQ8aSc+0k1ZQSYfsf35yMBmGLgMVDnyfBCV3
WjELa6shn09M5Wh22bXL
=H07u
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Mar_2013_15_22_22_+1100_mcDwM2B.cl6mSznY--
