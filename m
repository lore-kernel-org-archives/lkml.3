Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaKXIKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:10:13 -0500
Received: from ozlabs.org ([103.22.144.67]:43125 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbaKXIKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:10:11 -0500
Date: Mon, 24 Nov 2014 19:10:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-ID: <20141124191009.7f4fbf31@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/T59SINr8PJLDH0N0N98i1hs"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/T59SINr8PJLDH0N0N98i1hs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/media/omap24xx/tcm825x.c between commit db85a0403be4
("[media] omap24xx/tcm825x: remove deprecated omap2 camera drivers")
from the v4l-dvb tree and commit 1002a240ed72 ("staging: media:
omap24xx: Use min_t instead of min") from the staging tree.

I fixed it up (the former removed the file, so I did that) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/T59SINr8PJLDH0N0N98i1hs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUcufhAAoJEMDTa8Ir7ZwV8fUP/2cYEtL96S4VJez+vxH7Obpt
L1OQz+STG7awcX+LZksPZ/fLrzecRSrmPYusiL/OgeXJa2Y1rMSZE5VlbPmsU9nl
oP1zabOWeOUU8hrsfJuNFecvdwQPzSWpIUoP/16iDsnM/HbwEKarS8dTKusGWt5n
N/2+wV119d6RcOI9gJLYATfz1SEoV4owF9OagawM82X+1KXBuUS7ryKnLfQMfzoi
v+R3UKULDnnEJ8Qjn1fVvTfr15s31SX8jFpzd+a3PuS36jvgXSQyglnhmpOPz63+
Ku6zBc7N173CYekGo9Bw7F6pSIUCkKLqobckl9SjdFK9Sx1OCiasS+aJ/7gr70S+
ZD7iJWjJJL9MSL4++baSfvc/0tMMvDOQpLsiqA4voGbiemd/UpVEe6GzCQa5pLDy
vRKdsLUQ86fLRJ1LWTDHOMEBhOS3+sRAip8r2l0Q2ihhhlryZVKfx7N9wZU9ebD1
RRGB8pRNKFn2rhOhqysTJHSz863JWjqZB3bsyX31Jf7ApzW+PFUIwc05b0iTcK+0
o5I27in5vbEyvBG0AFvwh1XIp8gwIJdcW3hhpqPzH7YRGhilBssjvHtVkRNdX6D2
yBR/l+4WhSh1P6kkiUrCBhWvppD/3jeqMN7KNvYIKOK7E6JbaGv5cbbOvx40ETME
1fZdRYMs8KQy2Av5AQ5R
=l1B2
-----END PGP SIGNATURE-----

--Sig_/T59SINr8PJLDH0N0N98i1hs--
