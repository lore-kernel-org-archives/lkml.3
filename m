Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaGJG16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:27:58 -0400
Received: from ozlabs.org ([103.22.144.67]:46167 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaGJG15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:27:57 -0400
Date: Thu, 10 Jul 2014 16:27:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@samsung.com>
Subject: linux-next: manual merge of the akpm tree with the staging tree
Message-ID: <20140710162750.60496f52@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Zh9BAejo8AA0lgYjanvu7T5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Zh9BAejo8AA0lgYjanvu7T5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/staging/emxx_udc/emxx_udc.c between commit 6de2a1a7b9e2
("staging: emxx_udc: Fix build error") from the staging tree and commit
"drivers/staging/emxx_udc/emxx_udc.c: replace strict_strto() with
kstrto()" from the akpm tree.

I fixed it up (I just used the version from the staging tree) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Zh9BAejo8AA0lgYjanvu7T5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTvjJrAAoJEMDTa8Ir7ZwVcboP/2fPBVT5qVjQdY4x7GxR8QyK
W1ML4ihwrXjsUN+B9EPrC00kB/1LdazhjTwaM7/FeVWqDes+lOLioBAVkLwiBHU8
qcyLc51uAyeqlDjQohw+IoP184MmPXcm53Muuw1zI9zZ+BrVTRxRUOLH7dKQQ88J
AXr7zoKjAnXOnx+ubFWrYbqP9Rca313LX0Y/QE4Ggn95FpVets6vrk0eL8xb+iiZ
zpXd/f5o1ZcZQxYjLcKlVVgArLaounw9uOD0zi3hIJtY0h1LVvpGFJ/cyliT7OYm
BHPtipllF5x3LFraxl0t4mIcMyLR4PVROYoohd7QdZU28H6WNeYeIuoSVMlnBE0b
5rOFWsju4/JsFKVIFBNDjKcab7MM3k9iUggacxgBq50NH43b6F1Vy4EokeI1lN6d
8EPxMdIUxheoKo1dhx7l6+SiGtroRL9Q05PzwXVfxGif6RcYiwKpySn0vYTCgEqU
JnU7C+M3TJ+4oZ2ZvHYNngC87mPsOEqAwiIrhsmiy3D94XLl6/B1VXRtFohXnn3Y
7qCuLNyJfAwEacicUMrmQfKfKhn9D9+OsOawr/UYtMKkxhEg5/fKmdFgzdOPkRpj
PqK5l7X2trShUn0LWIq9z9KcGIsUcyVFVgJEZlTmn6+qPdun77HQp+/KCSQCswMu
LGcnNJ+FU+Y3Eb003raw
=ps0t
-----END PGP SIGNATURE-----

--Sig_/Zh9BAejo8AA0lgYjanvu7T5--
