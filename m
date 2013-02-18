Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3BRGA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:00:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50486 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3BRGAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:00:25 -0500
Date: Mon, 18 Feb 2013 17:00:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>
Subject: linux-next: build warning after merge of the net-next tree
Message-Id: <20130218170022.88661ff2f442490a21f79145@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Feb_2013_17_00_22_+1100_xCUT.7Pv3yrr/gkz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2013_17_00_22_+1100_xCUT.7Pv3yrr/gkz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc44x_defconfig) produced this warning:

net/ipv6/xfrm6_mode_tunnel.c: In function 'xfrm6_mode_tunnel_input':
net/ipv6/xfrm6_mode_tunnel.c:72:2: warning: suggest parentheses around assi=
gnment used as truth value [-Wparentheses]

Introduced by commit 14bbd6a565e1 ("net: Add skb_unclone() helper
function").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Feb_2013_17_00_22_+1100_xCUT.7Pv3yrr/gkz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIcN2AAoJEECxmPOUX5FEmEsQAIYpx8Wb/Xaq/+npEXHZxTuE
9GxVV0S1LkVOfh3I2L2jN2LGtALi9cMdItX1p7oblRxD/1OaUVNoVQiZrHgqXVMk
SLOOIcFCjPLfu9cMFMoxSfkBsx+Rpt9JWU2fCc05bC3Ba5tsOtPCjDQLLluOwATb
eB4Gdij1PQZgvJsEXWDNMzZIqnVNtWf+jtE4fLsmPttPjmkCc1BlTOZ+R05AMfOS
E7czHN9TyEhMalCvSDJ3/6DJeR8eJ/6T0jQh/wUusY5K/8+zQacCl8mbTZV7Cbhm
Y2BGVt3gLP4S3QAx8Bh6KIouF2FNBd0vAdXmPpa50l/6wIn4xf5ochjyMBYSuZzE
dpyb/HyBB/qs02INpooyfKddWmUIwjH46PVS9wx4FjRd+KBzNvBu+sn+7YCDkhy9
6SxkBkqCwGkLKkz98Z+ZPfM1OcoOb6vhP3BvrXnJRCGThMSisotwJsZkgp3ZjVFR
/oa/N7cWDb6Ub/eykJR/b0+ExNHKqQz8ueCMRQqTTaA4AmxINWKi/ynL9WuSMg7d
adSkF8SOqFYIFhtGOi51ekxThQvedOOGXkL1dc7JyGv76PC7/fTFQQzfykxKAXyf
g07w6bOSjNiXI7BHXwpWZw96Mq8oc7Jqpz0FHOm1bA/sccmdveI9c1wDtvlrHf1g
TPF79qCOnwdjW1EvB4HP
=8o3g
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2013_17_00_22_+1100_xCUT.7Pv3yrr/gkz--
