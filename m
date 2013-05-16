Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab3EPDXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 23:23:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35579 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3EPDXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 23:23:08 -0400
Date: Thu, 16 May 2013 13:22:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm@opensource.se>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the renesas tree with Linus' tree
Message-Id: <20130516132253.8865ca7b6503bd6fe9e6b05a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_May_2013_13_22_53_+1000_/w5v36AORU/wlVZt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_May_2013_13_22_53_+1000_/w5v36AORU/wlVZt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
arch/arm/mach-shmobile/board-lager.c between commit 65be2de17aae ("ARM:
shmobile: use r8a7790 timer setup code on Lager") from Linus' tree and
commit 993340a1390d ("ARM: shmobile: use r8a7790 timer setup code on
Lager") from the renesas tree.

These are the same patch but different commits :-( and there are further
commits touching this file in the renesas tree.  Please clean up your
tree and remove anything that has already gone upstream as different
patches.  I used the renesas tree version of this file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_May_2013_13_22_53_+1000_/w5v36AORU/wlVZt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRlFENAAoJEECxmPOUX5FEcu8P/iNUEHp91h85VpCgFfT5yaVO
MA5m1zJTeWquC8iYN4iL9n6pqf0TTA5dj8MhuNP+ISk7UUaW9BaIkzM3y79zrlI+
Y4jJAZXuCQBjj8qy+D8rQ8nCimSzacSoyEldj5gOCHljWROW8rRRblzVsb5UjJJY
n0E4yl6TNL624VtnHdKgCuF/t+Bbf4MbYG9pwOevBV9xEaFOD1DVuRNRJWu5twbq
M13HNHT1HfS7iy/EqOASA4DVyMdQ6FOpzm67kb7Z1SJFetBKKMXGnUYWDsXQibO+
gX8KrVbqtVfcdK49211l9HR6CaWfSyjfeyK7FIYL4I5bEE53qU0GxKOgnSem+pEJ
7BTcg5oun6Cf9cKuZcrYopjR9Zceifd2Mq1xNKDFTeSiEkaxvBm6dyK+qNl5/w40
yNAoVHPo1S1j2avyoyNkGyJyqT0zkI6haNBJQfxRBb9QSwMUf1hWqlJtegvc8Hol
4h1OkfHcgTJhq1cRukc81iDmAsH3xg68Y1BplyMR+L2dwGcgJtcSJraNhDtZQWwQ
Mb7pLo1jfKHOmOo2BsMj4Hs1ltIlY0++Vz60G8IwzR9AcjfLOj9r7o11+/MNtc87
rQtfi+k8lqjXfqb7Ho+ST2j4FcM1AeRpFdnHQuDcoREAUaQTqxy6Fz1w36fnsNG2
bbgDS0GDuUfYlCRZ7Pnv
=fVlR
-----END PGP SIGNATURE-----

--Signature=_Thu__16_May_2013_13_22_53_+1000_/w5v36AORU/wlVZt--
