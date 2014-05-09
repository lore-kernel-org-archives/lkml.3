Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaEICBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:01:52 -0400
Received: from ozlabs.org ([103.22.144.67]:37208 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242AbaEICBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:01:50 -0400
Date: Fri, 9 May 2014 12:01:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horia Geanta <horia.geanta@freescale.com>, Marek Vasut <marex@denx.de>
Subject: linux-next: manual merge of the crypto tree with the crypto-current
 tree
Message-ID: <20140509120140.4314dd63@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VF0+P0jYvATIQqIIpfvkk3F"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VF0+P0jYvATIQqIIpfvkk3F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next merge of the crypto tree got a conflict in
drivers/crypto/caam/error.c between commit 27c5fb7a8424 ("crypto: caam
- add allocation failure handling in SPRINTFCAT macro") from the
crypto-current tree and commit e22cdcfa13d9 ("crypto: caam - Kill
SPRINTFCAT() with fire") from the crypto tree.

I fixed it up (I removed the SPRINTFCAT macro) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/VF0+P0jYvATIQqIIpfvkk3F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTbDcIAAoJEMDTa8Ir7ZwVz9oP/iXaNgc2N2shIz1mq76gduVK
fiNHn0Cm7bptv7NkfvaBzaNttbY17nNSItm3bnQKvZm4Tv9JmdfSsXEjB6qiB7Le
xYCDqOAFKFzHYMMQ4g0Q2G2/MME9paXmxdb4PcFKwVL8z/bMWrWE7ZO9O24+C/JU
1e5XUzUpnKilSbDIgRhDd/KKlQ8OkR7au0i/4sARk/Indpzc6j9hFvR6G7kSqTbT
fVgsBxMsofq8ocmwLCO1RPmpCoQcl9AUgHvt2NPx+F6FHACXyNymxDahRDvVe79k
lKC204T/PWHlNm+FAhxt7NKxAZT9VF4tt5HjDUpLbT1Gmsys7gUa6633gl+O8qTm
c6UUFrt13m2Kue22hVKkO7F1lbUbn9a8QaP/+AL7lUCNuY89D+ZUmw6vPJaBf044
bf/GwA6XXEf/+jWa/A0TlNYxMrM1ASdtA8qUrPAafkf6sBlNtjqrhAczD8xaWAh3
OX0dhrqT+v4i2wNxevTNA7frxxrU+kZE87OypFqJc8bMEm1izsz6nSRe/b5exqga
S87/IueIIVp5nh4WmDnr4JdUsW8xpSXnWX0e/fAoFHBVWv1DPIdFPKSlTnmVYPk0
JFr3rUmve61AsYhTf98wIlYQGzwyedVYapd/VuPBe4bA/il0OtPgfk+Hi6dsl9b0
igEF+l9ntvnDwFELQhwv
=CVsV
-----END PGP SIGNATURE-----

--Sig_/VF0+P0jYvATIQqIIpfvkk3F--
