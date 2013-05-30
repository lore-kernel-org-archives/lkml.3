Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967592Ab3E3GSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:18:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40811 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967549Ab3E3GSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:18:08 -0400
Date: Thu, 30 May 2013 16:17:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: linux-next: build warning after merge of the final tree (net-next
 tree related)
Message-Id: <20130530161757.e04eaefc2f3cf64c1135aac1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__30_May_2013_16_17_57_+1000_E9/C7EQt/PK3Omnd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_May_2013_16_17_57_+1000_E9/C7EQt/PK3Omnd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
produced this warning:

net/netfilter/nf_nat_helper.c: In function 'mangle_contents':
net/netfilter/nf_nat_helper.c:108:9: warning: passing argument 3 of 'memmov=
e' makes integer from pointer without a cast [enabled by default]
arch/x86/include/asm/string_32.h:200:7: note: expected 'size_t' but argumen=
t is of type 'sk_buff_data_t'

Presumably introduced by commit 1a37e412a022 ("net: Use 16bits for
*_headers fields of struct skbuff").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__30_May_2013_16_17_57_+1000_E9/C7EQt/PK3Omnd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRpu8ZAAoJEECxmPOUX5FEJ60P/R8KFMA3VEnTM3ohDCdWkNUN
PmWKdbiXSsP426MqYobDVIYltUPjYtpGNdu9dbbtl+wzwwO8UXC4eEdwAYRjX2+Q
+hZC1/UyCnKrjMANaenCXbCh91EyD3l4wxkm07r1/+wug6XeaKPti8QBrunFuJdT
ml9KWrYyEWW4Nkz6mjlfpkiDCAK7u3BGfC+ZUzpDOWmc/kBgLxnoP2zi4e4VdMbR
CD6hKT49ILU0WrP0u2vJiFVOdWWscpCgb3GFKbLn/9Bcl5SnTGMkYF0aqttrYIBP
PKOg8GNKAqMVDDZ9Gb3YA5nXq4gRMHnQfr5drhkbHybIAOSxsJmNaWoGgZ9jX9gt
J84/e6WRpZw+Lu2T26r48oDXjnmBFAuPQyt9Q47VHfTspFJz6pM+9yb6cLpt/7hg
ocdcQWAiuXrvVVqn3sGIXJOwWLgqpydoBWORnUL4iBZi3z7TOhe9vv0J4C790seQ
4vj6a6Hm5gRtLh27NCr+eY9NE3TzyaVWUnJIEfOE+TrVH3yZY6lH6rPjS4iqujaA
FbqayP2VSdmd0fRTmdXt+qbxapUp+IAqA6ADHsnBbw5VUvFgedJMvVNmbjh1bhEY
8PXJ5yAPWfA46hqaklFb6dficLlcTPuSpA+Gbc54YRswT/n46sWVt7NloYltYVXN
dXzVDMp+z4tcrh7Lsb7V
=Z5Zh
-----END PGP SIGNATURE-----

--Signature=_Thu__30_May_2013_16_17_57_+1000_E9/C7EQt/PK3Omnd--
