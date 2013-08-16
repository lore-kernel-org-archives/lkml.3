Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3HPBlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 21:41:02 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47827 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3HPBlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 21:41:00 -0400
Date: Fri, 16 Aug 2013 11:40:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Teigland <teigland@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: linux-next: manual merge of the dlm tree with Linus' tree
Message-Id: <20130816114050.5f4bf4b21f1bde305235ac42@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Aug_2013_11_40_50_+1000_TVXQ7m1BQV6xtwgH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Aug_2013_11_40_50_+1000_TVXQ7m1BQV6xtwgH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the dlm tree got a conflict in fs/dlm/user.c
between commit 201d3dfa4da1 ("dlm: kill the unnecessary and wrong
device_close()->recalc_sigpending()") from Linus' tree and commit
c6ca7bc91d51 ("dlm: remove signal blocking") from the dlm tree.

I fixed it up (the latter is a superset of the former, so I just used it)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__16_Aug_2013_11_40_50_+1000_TVXQ7m1BQV6xtwgH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSDYMlAAoJEECxmPOUX5FEp1gP/3YSFFpysXCG8R2qI9iGoFTn
5AsuwXbmqwXNyq/dQCIseN7I/F62DtmdzG/TsexoaMkQKAvwGsGUMzEOQSCUpkrJ
JJV61tDkolmEIdG0bnBhuSR2Bxx8jaab0WhLCvnUYaB2XHKJpedYKhCOfkZbGpY6
VYtQQgjPKPb6EAuVezfyqTey8oOS7U41GT4JySM+I07dogPwO4HyuQsjGGJVVGBl
H5f0fOVrmYkX2p35QHIQDYTip73AAz2hw7+yRCIrZ9s3doQEyp/Cw1JX4BP1oFO6
NJY8GiewRVBSE53pdUsjQhaTNv1nrFCJ8qnD/cpD5oC0fBzIE8SHSP6A5nOfq78B
4yMC9ivVcimYmwa/YZl1zEHG5xCCwiKU9sBwLaJRmIJtOYob1rTDFX+WQfgXrsG4
MSK3fz0ijJuE16rK73KYNGDgNQ8GsetXF7vuogTxAq5FYFjq1AV/sEdpvv1ajWNm
4nsabNwP79BSyNmy4fePMEqI9IXqHSqMwnwRqy69C8c0w52Qp+7+OEM6fTH1Wido
FxRCaWdvA+3DVbNNl+gTP3tFuC3tDLlIYz01jkLnzuCG1BBrVZnmA/ZsaX4+QVOD
CB0CEqnn/sJ3m3wcjLnaqwVKpzdRFT0L/U/suZ03ABCtB4pxcd+fqqN3L5ISTZ25
Q7gOYqYw7ad2SkSda01Q
=0tUI
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Aug_2013_11_40_50_+1000_TVXQ7m1BQV6xtwgH--
