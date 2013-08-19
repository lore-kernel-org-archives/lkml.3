Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850Ab3HSGFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:05:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35081 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3HSGFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:05:50 -0400
Date: Mon, 19 Aug 2013 16:05:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the mvebu tree with the arm-soc tree
Message-Id: <20130819160537.1eeb0a9ebc269def138e016b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Aug_2013_16_05_37_+1000_/xmyB5cbSM1eyhf3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Aug_2013_16_05_37_+1000_/xmyB5cbSM1eyhf3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got conflicts in various files
between merges and commits in the arm-soc tree and merges in the mvebu
tree.

These merges/commits in the mvebu tree appear to be from a previous
version of the arm-soc tree that the mvebu tree has been rebased upon.
Please don't do that - the arm-soc tree as a whole is not stable.

I fixed it up (I used the version from the current arm-soc tree) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Aug_2013_16_05_37_+1000_/xmyB5cbSM1eyhf3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSEbW1AAoJEECxmPOUX5FErskQAJhoI9Ye/dqY0RwUFF6aEWb6
DPkmFARs1lw5m9V+v8pE1aBrehWKqV1MrX8GfT8N4QfFXxfMubS6oeT+8+5nf94s
lK8VDagAq1fAGDUwkH1PfNqGLfY4U/iQVDJ+EViAuuYlDMZ0m/8HibzjItLkSjLb
igsQhJzqvK639VlyPGxcEGoc/asiCMRtmO4yJlyh7tdXF2DM4OjyJ7mKCy5uhnb1
hhEk7JD4f/4p/tMc17sY2K5dPJz4EWUeFyJVzPPzGPSjy7/ZF86ujmnuQ2jbGQBk
0lSLfV/bvKXXdCDZMj25UVkwSG7Y60k/CN2tXhtKOv7l4N2+8du+w89WsT6qoS40
tAm3EI6hmHwfb54D2Aap4b2FXPxQt/NbEIMvI2nzNh2AyKjr9Fy0zyZ7zTrZiu+g
hmrm7MxsKlRp7RlOPWvwPVmhuNPn89QpYwUXb0xJ5NZQj1AsmTiOqkWFhpf1Apa9
A+Jp4S2jHZO1jPHyaXJpoyDy5Do9m4NtilXcNKnnk1X4avKAh4s1c3TIXXLI5HfI
CJDDx0IrnE2GHk6QNCcQibsnKo57xf2HSmMbAFljw4OCnlIzY7v0I5zhVKLGEdp5
HWfTkwpIWOuWSB4+ZVP3xr0Tf2exj+bGe4EoIGThm9ZmLringZRqtkQd4eESNY4V
nRHGo7oAJa+tRKKO9wYx
=GwiS
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Aug_2013_16_05_37_+1000_/xmyB5cbSM1eyhf3--
