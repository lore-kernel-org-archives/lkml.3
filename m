Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaEZBSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 21:18:25 -0400
Received: from ozlabs.org ([103.22.144.67]:33935 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbaEZBSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 21:18:24 -0400
Date: Mon, 26 May 2014 11:18:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the nfsd tree
Message-ID: <20140526111815.25153c0c@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kOHIW.gRG1Y3L4DprM9YWcU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kOHIW.gRG1Y3L4DprM9YWcU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bruce,

After merging the nfsd tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/nfsd/nfs4proc.c: In function 'warn_on_nonidempotent_op':
fs/nfsd/nfs4proc.c:1861:3: error: implicit declaration of function 'nfsd4_o=
p_name' [-Werror=3Dimplicit-function-declaration]
   pr_err("unable to encode reply to nonidempotent op %d (%s)\n",
   ^

Caused by commit 4d332a993e64 ("nfsd4: fix encoding of out-of-space replies=
").

I have used the nfsd tree from next-20140523 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/kOHIW.gRG1Y3L4DprM9YWcU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTgpZcAAoJEMDTa8Ir7ZwVuGgP/A51PJKKkDx/UDlVMF1Z+iIG
p3P5qBPgRBrDRPu+VWvVaezIiiAFFvoAC+KVN+1Q33TbdePbyKRdmwqOdyC+7I59
2rByBRKvRRUoUQaqGMMherOAwhLluLLBSvC6pcdRVexBT7FNKgI6YCQLROtPsVjz
+UPopAUwsqSZJC/FDCFrekKrpkxSCZKL92F2/MWr3Net/0s/l9SBceRoEg28JdMh
Nq1W9J14qnxFGH7QWQ6olTlUwhsOA6f9Qs+KMHsx2id1VFVBqC/34qKdAGLrpXZP
I2pgjokfjw3KLD6lNGQ2dYz0EbZr1FbFeRVHR+uRA/1MEclUebGhvcZwKLkc6PCx
lt7C//nRaPDluXhgXKq349FI8IXe+OJpcZbYQ1VGFaH9JCWy389hohAeYyQLG/fi
kVaCyFriNBHZgYDKwjutdg6RTA1cKNQGf5lC+BfbNCYyzTcUoF8DZyabVdmkjfbA
X2ZqPpg59aAdGnnuSrFNf9/giDEBO+27RjZO1pHky1D9T9/KUJz+TWOIAz7i/rOo
broZ9QBC1EPQDKsPavg9qZTcQhDhouj7WHsOZNRi2gIf0CBBylNPboxFGDnLkGXs
Py8B0PI/8bIgAiKi0oyvcjsZEwZUWXH6/uRckolD+VpMomJTjP9qh64i9JtELG01
aEQZ3kTEpDSk009bo1TL
=zxuV
-----END PGP SIGNATURE-----

--Sig_/kOHIW.gRG1Y3L4DprM9YWcU--
