Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3FQDqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:46:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56342 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3FQDqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:46:42 -0400
Date: Mon, 17 Jun 2013 13:46:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20130617134631.fd1f6107b353c2e331ff06df@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_13_46_31_+1000_vKz2wqzP2gcVCPYz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_13_46_31_+1000_vKz2wqzP2gcVCPYz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

make[4]: *** No rule to make target `sound/soc/spear/spear_evb.o', needed b=
y `sound/soc/spear/built-in.o'.  Stop.

Caused by commit e58070ee4fdf ("ASoC: Add Kconfig and Makefile to support
SPEAr audio driver").

I have used the version of the sound-asoc -tree from next-20130607 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Jun_2013_13_46_31_+1000_vKz2wqzP2gcVCPYz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvoacAAoJEECxmPOUX5FEhe4P+QG8ZGRX8IpRZPxH6UFrxy1m
mZNugtKQNoU+pVbeZNW6eam32OWsMU4XFBk7Xi41ObxB+/i8QdUYw1B3weMuxznM
i4rwSuXI8gzsThGEASVCPjF7R/ewayugFkzUnDs1gbMSpLaX4QTgKsBIIBozbJZ2
M+s4i0e1Nl11hLt6UBP6dL0JTqg5WLifEEY+PDTD5W1ZVGLLj/ykDNlbNF7CijhI
Ujp2yro0ZnKds9QZOyyGBJoCV69qb7DYzSFW0bGn7ha2+O0O6cHWtM7ZaAKDWRE0
2cWmbTRzmeKv9sfKbVsbakO7/sfmZRCDSyzCkAEKSXw3JUqhMEKzMgLkvxUgDo2i
GBPC8/la5rdQG+7zKYm5sbDyNnwi1DUVUpILIngXoI9wMVL68WoqhPGRENX1vTKy
uEUalumLvLKTrIYBVCOvrTzExgujSn/mihoKoyL0D2lNxeVuZ3vm6fXKRxESxMPg
ONvNhj2BWwFEXmMcoN1w9+iynD3zkTENc8JpCsIIjH0Q31uYO0+j3Ll0XBYhUZgP
U8pBmwXuoYOc3suKDV5orYHYXrY3NVcejw0F4y4jx++Barkr/GtZJzovA9M0lhyX
FZnOzOg9gtR57b9tlA3TXxvfye8EkcF/bQ4Byjcv8Cp/fvAKecUFIeWvYHKpY8IE
aozDpgNxt0xtc7LzRcQO
=JoJZ
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_13_46_31_+1000_vKz2wqzP2gcVCPYz--
