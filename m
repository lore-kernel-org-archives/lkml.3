Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbbAUHOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:14:53 -0500
Received: from ozlabs.org ([103.22.144.67]:49760 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbbAUHOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:14:52 -0500
Date: Wed, 21 Jan 2015 18:14:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Konstantin Khebnikov <khlebnikov@yandex-team.ru>
Subject: linux-next: manual merge of the akpm-current tree with the block
 tree
Message-ID: <20150121181450.743c625b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/lomBaDQFP2YStwEchUnlYRk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lomBaDQFP2YStwEchUnlYRk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got conflicts in
mm/filemap.c and mm/truncate.c between commit de1414a654e6 ("fs: export
inode_to_bdi and use it in favor of mapping->backing_dev_info") from
the  tree and commit d475bc581640 ("page_writeback: cleanup mess around
cancel_dirty_page()") from the akpm-current tree.

I fixed it up (the latter removed the code modified by the former) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/lomBaDQFP2YStwEchUnlYRk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUv1HqAAoJEMDTa8Ir7ZwVGgUP/RxXzfRqZ/ya0olDDGWo3IZC
zuUdbxKh+Rb+8735RUh+Qdtjyh0SrVgVVKCloOvljPlEnQZ/ZAoDWuWciujjmRIW
arXbGp7UBvVUNQDYLDBHOkyvEHvWWa6y70pfLSW27Qq2YCxHM2nma+D9j57qEGKG
rBU9P2ePoq/ei/j1FeS7C/eIaPbB2hNNjKAwVZtB+NfZBmvF/m2Ra79zOcM3BN3R
leD6q45hdHg6kOggpWkKx9ReCU8xbOBJM8r2NoDyyCgL3bYsp4p/RWNSRy5+q5je
YPeR/I3PIF74OnCShdaBZYltGGUIYzZLQfZaREIMqKOzcjSaZmLSzvEtTL70YMPf
7EG7gVOdky/F8jW1O8yfhFHclcC6tqAF68Ity0wS+0KO/uk0lpWbpaL4LDrCr5hr
IvRRpvk0UFHrfDUzH2pVZeuDO44jN6jJYHtdCtbRjR/E6mRVYq+j70TWd+LhM+a4
bfsr0de1HaXV8V0iuL5xFwDEqRWfyjilEMpeVX9fJ3Gc5GeIK2FffKSOhKp97tjQ
xuxRQCX5nGY1CSzmTOIw1i/LoJCTlr6tqECtsvyczCgsOhE/HEiK0tif/NU/8jr8
2cvze2ZNRYJqNySDUtXbC0/bwAQjRVDbiGmgMsIgLdyjZXdK2mLGimoWAl2d7zbt
nUuF+cUX5QqMscgxO6e/
=RRzh
-----END PGP SIGNATURE-----

--Sig_/lomBaDQFP2YStwEchUnlYRk--
