Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab3EMBpD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 21:45:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34507 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3EMBpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 21:45:00 -0400
Date: Mon, 13 May 2013 11:44:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org
Subject: linux-next: clean up time
Message-Id: <20130513114453.52bc4aa54b1ae565eb836aaa@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_May_2013_11_44_53_+1000_m+uz3zap86AetYOH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_May_2013_11_44_53_+1000_m+uz3zap86AetYOH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Its good to see that many trees have been fast forwarded to v3.10-rc1.
For the others, it would be good to see some clean up (especially those
that now just consist of merge commits and those that contain versions of
patches different to those that were integrated upstream).

So for the "good" trees :-), this just means a fast forward.  For the
rest, a rebase (if there was leftovers) or a reset to you upstream.

Thanks for your cooperation.  ;-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__13_May_2013_11_44_53_+1000_m+uz3zap86AetYOH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkEWVAAoJEECxmPOUX5FEA1UP/RMf0A1TTLVxliZfSas2MjYR
mt0zadKOL7k0J+klqR8Cv4wKoudEURzWgJfDbkGaNK2xOaI5sEKyVzdCIJWs9J/U
+Pl55TBqO+pyaCYeh3zGkZulcRf/ap/m1EHpi39qtn+d9WXLy2x8lAYcNOWbqPoY
sOfRschNK51Il9QlbC7EJbXg41SczXPxsNa8xpmhKJnoHh/17/Ayf7vWUol6DpG4
Exx9KCgcNl7FFAMiONPwqiSof1J87iKsaC1UPTuSr9OG+Fnu4JZ0cMdw9HFy0hf5
4wdUpm25tyZH3p2vnz43zcunRWIyLs0xFe3Z2SV7sos7icMK4PhLfQRJyE9a7Z/0
dtxJL1x2l94DXsUxG64trfas95UWLDMqapQIdnDqqzO4mVn6eDCE72AoUurMMk2v
EPSVTCz5V2iaqDejbn+tI77C/tLezzmiocyWSuJjZwYVArXHgcEL9vv8u48tpr/p
nia18Rno7i/4GDAS2cQtL2CqqDp7V6+mzewnqivilFK8kCwhYqLbi6khv6vmZWE7
DSW31NKjiOuSLCv9A0Ln+ncd/6ulJY6fG2/JAAumu0ZUzP1dDZZUfdiY6Fi8Ifmj
Fc6DJzlC/CQFhC7WNSsDd44XNnjjMJl78GPnXuQTwww5X8gr+2/qO6pc5DAvetGm
6yh+u7rZCjTdS6iRmYHs
=TjCY
-----END PGP SIGNATURE-----

--Signature=_Mon__13_May_2013_11_44_53_+1000_m+uz3zap86AetYOH--
