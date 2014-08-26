Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbaHZFsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:48:31 -0400
Received: from ozlabs.org ([103.22.144.67]:57255 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaHZFsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:48:30 -0400
Date: Tue, 26 Aug 2014 15:48:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>,
        Christoph Lameter <cl@linux.com>
Subject: linux-next: manual merge of the rd-docs tree with the trivial tree
Message-ID: <20140826154823.086bed75@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/16cjYLbg74fXzyuVHgepO4f"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/16cjYLbg74fXzyuVHgepO4f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Randy,

Today's linux-next merge of the rd-docs tree got a conflict in
Documentation/this_cpu_ops.txt between commit 0c3ed93c1c2c ("doc: fix
acronym for read-modify-write") from the trivial tree and commit
1a62db155b94 ("doc: this_cpu_ops.txt: Update description of
this_cpu_ops") from the rd-docs tree.

I fixed it up (the latter is a superset of the former) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/16cjYLbg74fXzyuVHgepO4f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/B+rAAoJEMDTa8Ir7ZwVBnEP/AkwEVEeV9WDHrF+vSXzWoJR
yPLkRe/uxj3a5xEU0T8wqIfFBneGMkZcvxcnBq46QUtD7yIkp1YxHCP8P1keffAs
+02QMZYamOFuz/SJ4Jc+KxMRlhE4U24/K6fPrw/QzwfeNbnvBiV2YPQfg1cqeN22
yW8sRc2axhMiNp7/hmQyKtc0y+jgAL6AMiI8h/+m030ScE7YCoBCWo/afUe831NK
6sM5Um6hnQPnYYalVGT1xLm3zluh/LYiMoT24m9iVQo89DWwLpO/vI94i4/PUlVx
HBalA6zuZ4j/agUWJIPIJOJdNIpnAVs5/1Tbz+btMKvnxzK6q6eTXqxFkQ+217+r
IwSgS5fcxWz13CgCueB7hckarkoeiJ1x7AKdiXGPbR2mnxWBqXrS9QWHeDXZLYDf
TvhpRN7PErS5YvhY88VkJ5PXfGc36vsEIWoqfYbujtmn3hCBqn5swtZ5kHBk2h+p
fxfNJnK108N+YHTQa7zzxCoa9NQywAUIBVHJA24GIJ/uGGIKlOcCzR9TzxW4sNF7
egihjiRA8tblD9wSyvGdPQhpoiUCQO3PKZ+1kFXvNkSx+MQjvxKNHC02cClp7t0V
oXJE9vfvuRgNBY5yejUxyQ7kh2cJ3YQ7ycuqL1Y9G7ZvmV4qpdfa4xh653Gy6z3K
zOV5Z4QrTJwKeCnNxlbE
=bSgW
-----END PGP SIGNATURE-----

--Sig_/16cjYLbg74fXzyuVHgepO4f--
