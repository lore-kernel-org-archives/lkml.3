Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3EICEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 22:04:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54408 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3EICEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 22:04:42 -0400
Date: Thu, 9 May 2013 12:04:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the vhost tree with Linus' tree
Message-Id: <20130509120438.6112e2d5b559eb62ac0caa18@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_May_2013_12_04_38_+1000_lNev1U67mPI9FGl6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_May_2013_12_04_38_+1000_lNev1U67mPI9FGl6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Today's linux-next merge of the vhost tree got a conflict in
drivers/vhost/test.c between commit 73640c991e2f ("tools/virtio: fix
build for 3.8") from Linus' tree and commit 30954cbc5818 ("vhost-test:
fix up test module after API change") from the vhost tree.

I fixed it up (the former was a superset of the latter for the
conflicting area, so I used that) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__9_May_2013_12_04_38_+1000_lNev1U67mPI9FGl6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRiwQ2AAoJEECxmPOUX5FEqvUP/2t4zB7bdCz64vdAeny0XvjE
Vkjdilj8WO4Tf0jB5fExN64Ewc0GUo5cHR3HUThZmRs8AREy4i991SY4uJgMWpJG
NfehltZqg6xE45L33rzh6wGHHws6JAey+pB3tPhGG9j4HmvkjOhm70DxSntivqSr
rnfysYw+qKNsvN4tOCRgpW3eITC/HnaMavoi4OHnNbC5pZbp+B8xKdUubh/oqzTc
j5VjNnOQQBp4cs4jNdDXbGUJW7He+OyRnhrONE7YGRSxEtrYkLj5CBbchP/OGr06
162x2JsXO/Swn+Gt7Bn2mUX5ljfT6N5YBe8iw2j/7nTf2FCqbfp1hA/Fh4dtTZor
eMDN98aN75KJRnd6lDNL9sWk0MJ97JykuYarNF3IBXcrSALz61Pj+IRcvUD1O+NI
y1cA8F6Fet1M3/LUtsg6DIsAyAOKMmJw/bCobdS41HwKzECfD+XJR8jHjHQ6SVRq
QmunC8z9+pEMrDvetmUo8YEbhSJk7u+N/f0R1UwUUC5OakimIGnXIYZEozAO5vG0
bCiU7LyieQ1Wv1cVBbtfGVGteAjyFIrR2QZro8646mxksn+YcZz7VphbiTg9yWEt
DN1I9kVOD+4PI8Wk+9M3DzSxiZCsIPNE7bOAVbPYnp6l54uICxZnqUB6X5ZBewzq
ZeC147y+BaxDdSHL7nsb
=XOUO
-----END PGP SIGNATURE-----

--Signature=_Thu__9_May_2013_12_04_38_+1000_lNev1U67mPI9FGl6--
