Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab3LEB4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:56:12 -0500
Received: from ozlabs.org ([203.10.76.45]:52573 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933424Ab3LEB4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:56:09 -0500
Date: Thu, 5 Dec 2013 12:56:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: linux-next: manual merge of the akpm-current tree with the modules
 tree
Message-Id: <20131205125601.5ecf1b2b6c0f3df14f6097fa@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Dec_2013_12_56_01_+1100_KwwGZyF7hT3QvA4b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Dec_2013_12_56_01_+1100_KwwGZyF7hT3QvA4b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
kernel/params.c between commit 88a88b320a90 ("params: improve standard
definitions") from the modules tree and commit b23eb499ed40
("kernel-paramsc-improve-standard-definitions-checkpatch-fixes") from the
akpm-current tree.

I fixed it up (using the akpm tree patch that just fixed the whitespace)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Dec_2013_12_56_01_+1100_KwwGZyF7hT3QvA4b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSn902AAoJEMDTa8Ir7ZwVB9EP/j0zDnzKnMBM3yRcGZoxQm/q
jwLi6BkPNXEHjrmhbCbIBppnECMj2zTdgOWYIw3kcBEPA6bgUXsWy1OTab1eds4R
YBMCGVtzTd4dtGcAv0EhseYz+DqZU11k6wOgC7aGwsInUTTAXiAcXZys6vv5SWzm
DZDEwcQiSjvz/02GELhW2xdhOH7sj2NzOhtLKWzXH/AIdVChJM1t0uXXhcERl1jo
RHii0f7kKw/r2kzDlDIM3Ik33Z7WZKY4N8g2fjoo2VR9Mhs6lgve8jRo4YvQ3Pov
xZCGu1s/D6HQnUSRZroYxUMh3T8/lksczHR/q2pFjU6q+GLPbLRvJZnniZvd1Wxx
lvEjR4gK1fzHVfZ0aVlhOBodUemlyhxY+7QLPs9H+kbF5EjIVPJ+D9xOde3sUXE9
GRXOV+OIbIMMF6zHkXMIZ7OWxF/mFzqKuRph8qXbNRccTyck5p4/KfvCKjnF9pRc
YgAm9DxSZF3D2me/PTnXXo/VXV+Y9QehmjJDy2K3Kq3Tj9PsMGnJV5Kp4YVMzwRr
WiKo/aAN+tCpsmZHUDAnUbXWHjglyHPswfTla5Ii/MAv9SeJhqLW4YPWLiv79VnJ
Z+nTGs1cr4VuNcfBldsaZu2rVZ7oOsICmebeJY4rzO8fEwGvDVva+qJetlv4sPPX
YE25dekPgX8Et8kPpioi
=ClX8
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Dec_2013_12_56_01_+1100_KwwGZyF7hT3QvA4b--
