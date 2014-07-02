Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaGBGGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:06:39 -0400
Received: from ozlabs.org ([103.22.144.67]:60693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaGBGGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:06:38 -0400
Date: Wed, 2 Jul 2014 16:06:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maurizio Lombardi <mlombard@redhat.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: linux-next: manual merge of the akpm-current tree with the block
 tree
Message-ID: <20140702160631.240b44d0@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/60pHM+ZYKRbJJu32FruTFNC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/60pHM+ZYKRbJJu32FruTFNC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
block/bio.c between commit 254c4407cb84 ("bio: modify __bio_add_page()
to accept pages that don't start a new segment") from the block tree
and commit b5e51c564fb2 ("bio: modify __bio_add_page() to accept pages
that don't start a new segment") from the akpm-current tree.

I fixed it up (I used the version from the block tree) and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/60pHM+ZYKRbJJu32FruTFNC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTs6FsAAoJEMDTa8Ir7ZwV1psP/2XeXTXviVegPR52LaIStYZx
bUidzEdmL7vO6ihcO1XmE09mSlH/7e79iJcFxl1uqc50q2oLotf9XYKFuPtcL3f1
XgY8/Tw7O4DF9P6rX28GrIB8FAJG9+SR1+V0embHV5TbbuAjYTl84J5XcbY/WeDz
LD7pE6lFquixJVm7QEVkmGiy7rg3KQxxFm9+U42ZYImlFfNbktcsyXARmhrlcpI2
0gyOynRJlzbpqm9shbN7gr6Xqzh9cKGi3zPc83yT4UmzhWc1ddRiREonPIEFol39
x9QXY56z58koj+kE8gtsX3RvKY17QIh1ixA2w9fOgIERN9xRGhU9HgyWDibbh6Mk
c+wtPiKLTwUeXY1bhsBTi+vy4BlNiRfaiD+y2Xb5gKuSFCtSoaElvvRPp+4KUmJZ
Se6ZZRPrCRmJSW4O1I46jSjVGTWigtswI5UO7UX/MUpB0kfVkiFI8RPifbJ4SFnZ
syhvfwNvUA5oNE81nJg2BQ9YlLhKOhMCASzBJBBkV/ywvIsv/cdb5frX4RytLHsD
AOYt3mAB+5TOsQEbHLvBCVNIc/QX4H4pVgOZat7w81YZcLTJymARAXCFQNRcI5U4
BV02jgX/Lkv5EGQtFaIo0IwM7oirtkMzKnhlHow5f2rYRfnVBwIP1f1VCruC6ppA
qr+jNUyos3TpGVGy0Xto
=5riL
-----END PGP SIGNATURE-----

--Sig_/60pHM+ZYKRbJJu32FruTFNC--
