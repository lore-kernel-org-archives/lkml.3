Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3GBFp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:45:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41046 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3GBFp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:45:26 -0400
Date: Tue, 2 Jul 2013 15:45:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk@arm.linux.org.uk>, Magnus Damm <damm@opensource.se>
Subject: linux-next: manual merge of the renesas tree with the arm tree
Message-Id: <20130702154514.89bffccc662256004f301552@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Jul_2013_15_45_14_+1000_Z45NDYOD_QvtL7X/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Jul_2013_15_45_14_+1000_Z45NDYOD_QvtL7X/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
arch/arm/mach-shmobile/Kconfig between commit fb521a0da155 ("arm: fix up
ARM_ARCH_TIMER selects") from the arm tree and commits 462972da5f18
("ARM: shmobile: Make r8a7790 Arch timer optional") and 39d97587d6cb
("ARM: shmobile: Make r8a73a4 Arch timer optional") from the renesas tree.

I fixed it up (the latter patches removed the "select"s that the former
modified) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Jul_2013_15_45_14_+1000_Z45NDYOD_QvtL7X/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR0mjuAAoJEECxmPOUX5FEBbQP/0EbEIYekFwYtsL4HzC7MdiX
xCMDs26FqnU1ULGIVN5EDHXxc0XY7uyRORCXcsgMhJgws2DZKpTEbZkdqaQDSGZe
akXzir/ju/lX1oquUsP3P1l8grMpNnsohLWqNpjO4N37DRjiG5XZxKrRQAQUdbcZ
8blk/Q5q3SlwiRAFeLlm7aOpLixCnIQ5VUPHYFZaFUvEiA8C7ZKDkkwHmHnI+0bm
7oAjOiinnKCfxZYmyQC3/JfltpgAc6sgenWghBD3CA7jpBSRM7G3WipD/HbjxitX
PmgrFhkfkque9zH5bHCrGy73y+5zsOQWsfolstZtdd1dUt2PRiTieEV93lcI4tk9
vVIUDOYbwbCegaHi4twK7b+Ks3oJRgjwyoGdY85mwPI0dNRI4XCd+koLgaKoDAYl
tmMiRn6WS2qnQ4NIN7evGYXJD1BUn1/trnsHVQFe3tgvmjLxLUfxoEQ4xa0CIJh1
PCrd7CUa3KrB6qe6kp0wALz+eSaWkggsps+Two6cBkNmTvnSIddvpIy5kktZhs0X
a5QJTrQ/xMDvv4XkZdK8D2Aj2uLp+TgmiY7XsyJ/knbDgOQCjtdcPaI3PDoorAYo
UOYFLrEEQ52nPHedEhOp/XIqPB4PqOi6M+xjAaJH2dv8nEWOPL72mP2mw+ghzThH
vg6Cv7EUFQzJvx1LDe8T
=Ch90
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Jul_2013_15_45_14_+1000_Z45NDYOD_QvtL7X/--
