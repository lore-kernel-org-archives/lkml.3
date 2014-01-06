Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaAFBN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:13:26 -0500
Received: from ozlabs.org ([203.10.76.45]:33234 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbaAFBNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:13:25 -0500
Date: Mon, 6 Jan 2014 12:13:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bastian Hecht <hechtb@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: linux-next: manual merge of the sh tree with the  tree
Message-Id: <20140106121317.bada4233ec3fec40f79735cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_12_13_17_+1100_SGsrsE/AfAwa8sY1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_12_13_17_+1100_SGsrsE/AfAwa8sY1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the sh tree got conflicts in
drivers/tty/serial/sh-sci.c and include/linux/serial_sci.h between
commits 8fb9631c517b ("serial: sh-sci: Sort headers alphabetically"),
20bdcab8268c ("serial: sh-sci: Add OF support") and probably others from
the arm-soc tree and commits ada80ee7fa60 ("serial: sh-sci: Add OF
support") and b19ef75c56e9 ("serial: sh-sci: OF definitions need
linux/of.h") from the sh tree.

The arm-soc tree version is dated much more recently than
the sh tree version and conflicts badly, so for today I have just dropped
the sh tree (everything in there was committed before April 2013).  Please
figure this out.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_Jan_2014_12_13_17_+1100_SGsrsE/AfAwa8sY1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSygMyAAoJEMDTa8Ir7ZwVikkP+wdSxBZ+oTWuZIkr1qabm69b
HYjk97O0HvXr/bgppF3CFzHWm1g7vqtK3UwXjp0Z8H+VpmaoTc0IVn99+wQKZ9/d
yBenqdPSMAlYDUZD68RfOCmBIQIf9sHIvtLiXN2Q49sDu5syiaA6Xt+WDHhxYIdq
dIhpktSptG8LbT3H/2EtqTibzIqA5UmaNnou9Y5D2xFJYHXFOAkPWgJXQyeBmrAD
HJPaNiWQXWkQqs8vyCuHuI3QM8jW6BHFqnXMbJGGr8rZ/Olim+IqCuMAFhVL9M+B
Cnzyo4g2S1n7RIZXRl4ig+SxN2Fr8EMa1ulp9yH7U7qFIMEeYO9KL5HTLUv+M1TA
sS486GihwjStbYeXjwNBUduqw6MuCMdUPK0Gmvgtoc+mfbaN8A3vPBJ4n3J3DY35
to9kG9imBDhiKjHcs5qQeqhaRr417olMiOoFzCTBWQ8GLzw1GUqOS/CdPwYoLj8v
JyOoHjpbcrEyk5Smq1Rfc46jX7wOVk0kVn7R6RLfZrRDc9TeDPMUp4T6N1XxVwE0
VqnBPBrdJsDVyR9NGkQaGVaLV/OYUCqE5JgLYPm5w8y6ofnE3Go27XiN0Vsk+WYh
JoMsEwPEmiC7aqDwInztBX9OYiGJ8T2lEFE/bU0wfWOHjHkf4MHpcbZiMjwIJSOJ
QIUP7tc8LTBEBQesF7JK
=11Oh
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_12_13_17_+1100_SGsrsE/AfAwa8sY1--
