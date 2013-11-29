Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab3K2AyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:54:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36502 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab3K2AyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:54:15 -0500
Date: Fri, 29 Nov 2013 11:54:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Austin <brian.austin@cirrus.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20131129115407.53b288138930db24718cac49@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Nov_2013_11_54_07_+1100_MsFQr_7cZ8m8EKB8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Nov_2013_11_54_07_+1100_MsFQr_7cZ8m8EKB8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/cs42l52.c: In function 'cs42l52_i2c_probe':
sound/soc/codecs/cs42l52.c:1235:10: error: 'struct cs42l52_platform_data' h=
as no member named 'chgfreq_divisor'
     pdata->chgfreq_divisor =3D val32;
          ^

Caused by commit 391fc59db876 ("ASoC: cs42l52: Add devicetree support for
CS42L52").

I have used the sound-asoc tree from next-20131128 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Nov_2013_11_54_07_+1100_MsFQr_7cZ8m8EKB8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSl+WzAAoJEMDTa8Ir7ZwV9KcP/i/VZIqkOYYv3+jn0Sd6fH1A
qnsyZwv7Hiwty20ZijKo14jH8yvl95egcY+Su3lhcxW4c+MMs+6/C5bOQ6jINDhQ
16pg0vaoNr4tfyP5L9h6pWuRZJB9/nRJ3Q9QJWIqIRSn7ztn+lF4rp7lCZRS1Mzq
BlQDiXghMp2K3R/f3YvQy5S0QOXrsXU8senAUp1pVp3ZY8/AB9ZoFSNAjUMdcgb/
lsB9K0I8xj4QBW9hapTlCtILn5+y1Vh+x6R3OtheptXsecBhcplalqB+JXuF9Ctu
92smfGVH4eccbA6s8EvoeM6PQHoj4bXWafIUroSIcTZFaZAjxjJvo14PjmLRPy/f
i2yKAlzVpg3Y3K9wmc9SHcwU7jjDsfqX9FAXzBSfYk3vRL0QL2X6hw8sYmAj1pO8
UP8er6DqQRzTy4ntU9YmCCNn4cM5hTRyXxz2Q7CsGOQFJ/hRheuLsxGx8yuOle6D
NmMpw7z7qGYJKokKvkkaBOGdOKrt9ToC/8vL9Vx3TJ/xNGh5DgH6QlNeRY2KZDGm
H40z2jzQDUEiSKgIopHrwzHcMj7vfIRtlx06Ji5KVtYM28kuF8wbzZFz6IsNz3OA
BpWsDNwv/42WpJv8/IhmAiT9TpF3FRLdyRcHfD1NnbIQ1OXBtCWkRYN/m4z+Yjge
UYLq5N3MuOe1QQ+2Dos2
=xSSo
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Nov_2013_11_54_07_+1100_MsFQr_7cZ8m8EKB8--
