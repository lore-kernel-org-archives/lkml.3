Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762971Ab3DDEnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 00:43:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41689 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab3DDEna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 00:43:30 -0400
Date: Thu, 4 Apr 2013 15:43:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the staging tree with the vfs tree
Message-Id: <20130404154329.d0c983568da9650d5dcb31bd@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_15_43_29_+1100_zPYyW3.SRIQbcM7A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_15_43_29_+1100_zPYyW3.SRIQbcM7A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got conflicts in
drivers/staging/ccg/f_fs.c and drivers/staging/ccg/rndis.c between
commits 465bced2e3ed ("ccg: don't bother with fops->owner") and
4dfac87dca02 ("procfs: new helper - PDE_DATA(inode)") from the vfs tree
and commit 515e6dd20b3f ("Staging: ccg: delete it from the tree") from
the staging tree.

The latter just deletes the files, so I did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_15_43_29_+1100_zPYyW3.SRIQbcM7A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXQTxAAoJEECxmPOUX5FEilEP/0I1/q/DOqiM4g5IUkCsth1w
q+pvU+DLSYv5Yk5+Hl9EMk9QemDWEXkOsdgt9yWvbHRd+0O78o4KX+Gjc0EFIfud
wi6QYjUindxcARPJTlemZly+AXIzVjghrUP+gZ7RdtxCIpOkJvvJerqzR6pNuLaF
Lhajo8Rcl1GUX8aDq2C4dqE57+UsyKwsRGWONJBKRAi84VjZEVTkYI2yMGaRA/36
67ft0JTr7HetvtQJnxDtHFLJiR6CRO5rB7+Ed9urz9aj7+kVC4UfN8Bor7IYArV7
gt5NjzaArmxEP//9UkxDnsYtkCQXEYdYp/a6NYkK9g408ukr6963c59YOZFehSQ5
6rjbvqMxFFgWJXN5sEupz3JW9U4TS+8Fo2aXsjPcGRKm8omei7hOCsyQpCF9chXI
79KyVeIfIgesk961wDXnUZ5EghIl9Bur1eSJvHnMmnFACKT4mFZ2YsbMuHiCswQ3
1gUMXZ7HgstF32f3SHXAWzXfu0W7keRk0L2zeHAQ7YIPwYtmgrreVieOHMdPezOr
yGuyV4HYcQ0EA19AV9KHIV6Gy/wakKdjXEZN5PQlDq71ebRcnZXG2eYBQnLoPvcz
PJ7J+9DDiNOOSMuVMnDWPwfe7RCKiVbmQo2fTJuGP5tZTloJD3iNBu4Y7cdpvPbF
nzYvwBwCEEuA8+8gNP+r
=3JQC
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_15_43_29_+1100_zPYyW3.SRIQbcM7A--
