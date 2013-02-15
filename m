Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882Ab3BOFBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:01:37 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58791 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3BOFBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:01:36 -0500
Date: Fri, 15 Feb 2013 16:01:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the driver-core tree with the  tree
Message-Id: <20130215160124.52d9bfb269ad1ffd390d4851@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Feb_2013_16_01_24_+1100_pVqz.AwYj1hIErXB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2013_16_01_24_+1100_pVqz.AwYj1hIErXB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/net/wireless/rtlwifi/Kconfig between commit 06e7cda3ce30
("rtlwifi: Rework Kconfig") from the wireless-next tree and commit
6cba014857f4 ("drivers/net/wireless/rtlwifi: remove depends on
CONFIG_EXPERIMENTAL") from the driver-core tree.

I fixed it up (the former is a superset of the latter, so I used that)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Feb_2013_16_01_24_+1100_pVqz.AwYj1hIErXB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHcEkAAoJEECxmPOUX5FEpzsP/Rvn8Ig+Dx9bzi5nVUmJ+xCA
IdC8FhP1rSZvvD6Mt3JwBPCQpamPoJq+Wlbclvnx/vvPV26kQeffhcZCeDeJiMHG
pjx0h4Sq2mZsCMsSUu3YnUXyZ1G9m5yW4pg+lnyvCYH1kuoSIDub2d/OyZykkYq/
CU29xMCUBklgoFUZa5f2k8G/HTVbRvtURQfz5itvY5VS0Qnk3g9e3NmaLZ5HKq75
KOPVt0NWHthFZa1YJIJFefBSN8G+tBNS2KLp5FBld31WZpg34q4CJHHvufpMHBDP
s3rD1js+ydknOu8SLOS2Z8/URV9RAiCBBa+iljfXW/sldbT8fJoCDV8yyiZjSgVF
Hut4ygTtw6hguaivjDCOu8ugas5q41kg9Zy1A7ktU5d32HPRisMZoOZPKZHdA6o5
FhTswLJaYThrmt6QJ8vvqesKzQ1oG/75cdlLfE5yZN7mj7l//u2Ab3vJbB97rRRq
KbkYN/4tf8Va/XYB22wi80F8aqbjySmh/o0Oh4toTgFyLab7R/CiXM/QeBPQOPjN
Wiwu0xnGkkAJR4HKjGaEVlf8VkHpW9vwhmn6V6IJJS2fthp+BBnpnGgHAvVPblKM
ybPiDxYcR9nnptOGW41m3I/zlGYm6Obhf+GvYRhySzC3nUKhQk1kocdlasD2F/qH
cr7ZXixMd7HHgWzSt0oa
=IXop
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2013_16_01_24_+1100_pVqz.AwYj1hIErXB--
