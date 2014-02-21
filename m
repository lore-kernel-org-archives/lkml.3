Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaBUGmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:42:47 -0500
Received: from ozlabs.org ([203.10.76.45]:58648 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaBUGmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:42:45 -0500
Date: Fri, 21 Feb 2014 17:42:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the akpm-current tree with the sparc
 tree
Message-Id: <20140221174238.acefa05c8a5e71b06155d32d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Feb_2014_17_42_38_+1100_yzsTBUhy9Lf7rqfi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Feb_2014_17_42_38_+1100_yzsTBUhy9Lf7rqfi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
drivers/sbus/char/jsflash.c between commit 967f038e491b ("Sparc:
sparc_cpu_model isn't in asm/system.h any more [ver #2]") from the sparc
tree and commit 695f43eb1721 ("asm/system.h: sparc: sparc_cpu_model isn't
in asm/system.h any more") from the akpm-current tree.

I fixed it up (I used the version from the sparc tree) and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Feb_2014_17_42_38_+1100_yzsTBUhy9Lf7rqfi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBvViAAoJEMDTa8Ir7ZwVSekP/1sjt7ciNsvozzB96Tzthqb7
OPRxuIZCKLYFAnckRes01mk4VoN2UqDfKS093fr+pTIGZK1I1eQlMy3J++EvAUv2
RTRK/Hx3lS+qQ3maGwetv7mh/Xnx876ik/i65814J92mB3mwl0+/d45fCZsLykRJ
BpzKv2iN9Z5osrccXFawzvUl9agNxK5yqPgXKfCWAT3mhdxb9CqkPagWd2Q8gQHf
qQzgDxKUK8TFBsQBiA6Nva8NxdQ5NSfx8eCL7OuI93AdUdGf7y7lXetkxMBPl1eq
oaJVF0CNcIYyn0yWFdM9rnquwWxOM8cHo5dYhyXKU2Br8EFkKHxSyevRqsil9IIZ
g3eOokewFmkmAeJodLnDMKfsZtlHKdCzzWyHk8snLmoPqL5gH/wtfIEejr8kDo3x
bNqVgIEUdU37RrJp6Sej7x/3muQALlzpXAjzEekJUe5iuGV3vVO2G9WSsiKMvNiS
1zQtCVZl3VksFwnQ+llvrNmTH5F0aCoG7jndG9/vvFciStgNiCym01v51cVUVdWd
aeN24kLc/DvX2u8V8X3tc6eLYQ9Pt2nNHgjCVUTx4yDU46XldaEvFkG8viPmkmQ9
nt97i4BAmNAoZrseVnGfQEbU1rTtnUvmPWFnFrqThF+BKCQS9G1aQAZfDrl8VYgU
d0gcdQ3Pg/kXnqh/DTIT
=d3q7
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Feb_2014_17_42_38_+1100_yzsTBUhy9Lf7rqfi--
