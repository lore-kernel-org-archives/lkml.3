Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3KGCVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:21:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55506 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3KGCVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:21:13 -0500
Date: Thu, 7 Nov 2013 13:21:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20131107132102.17d5f340fdf80dc0faa80c4c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Nov_2013_13_21_02_+1100_dqOA/LMkTNZ1gD2J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Nov_2013_13_21_02_+1100_dqOA/LMkTNZ1gD2J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/radeon_connectors.c between commit 108dc8e8b44a
("drm/radeon: rework audio option") from Linus' tree and commit
ad41550666f8 ("drm/radeon: enable hdmi audio by default") from the drm
tree.

I fixed it up (I used the latter version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Nov_2013_13_21_02_+1100_dqOA/LMkTNZ1gD2J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSevkTAAoJEMDTa8Ir7ZwVt3sQAIHLsZiiMcz5CTjUfUCaCPDQ
/A5jywTGrsa8hhgMqtoquzEkOd0BoRZb7DAwG3OSX49Rv3g5WJeAtVOFmdDPQg0U
01iWGyBnLCnJwi3hItYTSQchhoRiInDQEL6vxqqJZkxDVXz7NQ50ngw6QS5XFcVO
P2UBy8L5oYkHRlMvqKP/kD8pTehdc6WVzBIPagp2bkaKwJy9guX2L8TfgULYoDQW
O2WJqQHP8qWzt6nZ5QuPonHSi12L1BT84zVHCgwW2567WmCkCNuSX1m3JvluHUHM
GM7fZSlTHvCaZ6op0JQtjB9LvesUopCMI2AqlTo2S/LvL/OUhqqljrOAvBI4J7cZ
MSupzQdaSXnaNIweXSKG/ae6ZnzV7+Cs4Z3yvN9EHxcf5oD2ybNB/MzOF8PcRjEd
5wJ+YXkRdrUQ31yczUafJlo2i4niV0dJI6ORWk4HvoeVzmOkZgtAcNUEdkj9GNAC
48AgkG7mzFoTNF0/FPWp9e0BhTohkL5HIGcU4fCJi6K9jVSqAZkIQM1+J3RRd8nH
XG07ReIgsleYiGFPuWFpW7Xxw0IPZlCMdXpTAzwfIRcg0xyxwg9klzEc67yAm21R
2NveU++e0nfX2+Atx9ULomQshRkM05xyB/y+QcaeIzxBzzWFXDR4lL7ArbcXQdmB
2pXKePaIY5oYX6w9Ind/
=U+Gv
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Nov_2013_13_21_02_+1100_dqOA/LMkTNZ1gD2J--
