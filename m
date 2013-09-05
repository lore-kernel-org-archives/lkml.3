Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3IEBAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 21:00:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49122 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3IEBAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 21:00:53 -0400
Date: Thu, 5 Sep 2013 11:00:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the h8300-remove tree with the net tree
Message-Id: <20130905110043.cbea8acff9a1b1b3b199e0ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Sep_2013_11_00_43_+1000_IHydXZVq+vLqSmnL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Sep_2013_11_00_43_+1000_IHydXZVq+vLqSmnL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

Today's linux-next merge of the h8300-remove tree got a conflict in
drivers/net/ethernet/8390/Kconfig between commit 061ba049abc6 ("drivers:
net: ethernet: 8390: Kconfig: add H8300H_AKI3068NET and H8300H_H8MAX
dependancy for NE_H8300") from the net tree and commit d5bfa4f18b55
("net/ethernet: Drop H8/300 Ethernet driver") from the h8300-remove tree.

I fixed it up (The latter removes the entry that is updated by the
former, so I did that) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Sep_2013_11_00_43_+1000_IHydXZVq+vLqSmnL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSJ9e/AAoJEECxmPOUX5FEISoQAKDBbioVwzCmYemsRpkyhI96
frpiPKK0UPofJIfDjZcMWg35XjjJQzCfNTfMaTCitzpRvnqwoYRB/RlVABVjnb9y
QIVnL/OSVcLCYaTuG/3W2dnIjL/jhbDSdplyYQMZtLAs6Zzj6GJUbhitVPvjSgjH
5cgdCRgbji7jWXOZiNWfWXQyf9HaBmJYHhpcdodkWwMqBz1xwwLZMskap7sWQuhI
Hu8Xvh6KYhuoeVKcXaBA6arGMlcNdoef/9svj2iA3r3Ek4yq0O6D7darUVpdg6of
bWtpt7kDxYPL3BvtVGhYrGlrwoEJ6b6X8cRz3NNI/xkFVNM75QY0jAEMSg1jPzs/
+2xLexAOPJEL23z4jbEy46Q5nlazTZdCe5s8PRopZcb8eKM3/UeQj2TZOh87ccg+
1ykIWYkqzzfvJofp75YklM49UzMTEYAMOV9SOSmwJxGj7QFVy4ywsUHloTcNLeQ8
9Ymg2aYrzSP2QW7GDryiPOnRiG8RM0wx4rqQNajrfwBw1Tus7BOqkRURJZTBx3Dy
C1Vv/uq2aCEzSmaORZ25Yeb/SJEsUge6+hu58902rgmPOBNb0vbOmIteS9AEu7uq
eLfFiJhCFMWUOcMnwdzJQfzruWAtc/9lYxcA0DFvcC3wFfXXuRRzVAgjMiEQhVMG
7tBGnLWk8dVLOaAGChQ5
=KW3T
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Sep_2013_11_00_43_+1000_IHydXZVq+vLqSmnL--
