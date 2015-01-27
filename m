Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbbA0CAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 21:00:25 -0500
Received: from ozlabs.org ([103.22.144.67]:39292 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbbA0CAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 21:00:23 -0500
Date: Tue, 27 Jan 2015 13:00:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nimrod Andy <B38611@freescale.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20150127130017.57c7cf12@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/b6k_Xb_7rb63W3WQa7K0Apj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b6k_Xb_7rb63W3WQa7K0Apj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
arch/arm/boot/dts/imx6sx-sdb.dts between commit 9143e398a443 ("ARM:
dts: imx6sx: correct i.MX6sx sdb board enet phy address") from the net
tree and commit fc8347778017 ("ARM: dts: imx6sx: correct i.MX6sx sdb
board enet phy address") from the net-next tree.

I fixed it up (according to the commit comments, the version from the
net tree is newer, so I used that) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/b6k_Xb_7rb63W3WQa7K0Apj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUxvE1AAoJEMDTa8Ir7ZwVSCcP/iCkyXK0QN7h0Jih7SE6Xtax
A+UPQeEVIZbsSAh/79UQJ0UttZh+1VXJ0qP6N7HU+WFtlajVEvm3yw298xzUvhON
WDPNk4U7MjHlXjmkhtEyYdd2Q2eI5MxosCR8JA5fmLNybndvJqicXsdewWlJyIdM
G+QOyKxtYRU7sxoxpoYeXyrcuEIwaatudwpbaivHh53/R9rZA+htmGXmVVGABekx
g2rSdf7OyfNmKpXxKk5va/Cxmk+An6wZLbyjA51XK0AQ6n1VvqwYUMMR1TUct6Zw
9FQumGm9ci/wj08P4PVU/rdpvwbNtaB0Es/3Q46yb45nbKtAaCEuwk3mUoKCsx80
bireX8vuUmK2R5E+GSyQGzJ2/cKp+DW+Djk3m5Foq0OEwgtNK6/+HlT4u9ngF9nT
6Dgn1IldlxYvmZd/5Fgyq+nla+aDIS6UlO0TUblD8350DGmkyz7gVfyr35uZHnGk
B7bZ4YRYIOAI6wPeqrFCM9sPJGNrDVxdaoXMKdlk7A4Ijo2ez2PwxKfd3GkrPcu4
w+5C/nWAiKaZmekL+lCDZGkOth+5ubMUy7Xhof3G1VupT7kYl3m/9waUfJVIMPQ3
4tSz1gukt9stiuW108bMGFArFmE7sJa3m/ZBp7GQjO7wWAzePKx8LRUfHTi7KUz9
ehX9Acw0JpPFEtiWyHIV
=fwyF
-----END PGP SIGNATURE-----

--Sig_/b6k_Xb_7rb63W3WQa7K0Apj--
