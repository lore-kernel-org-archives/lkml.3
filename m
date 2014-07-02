Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaGBFP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:15:58 -0400
Received: from ozlabs.org ([103.22.144.67]:35124 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbaGBFP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:15:57 -0400
Date: Wed, 2 Jul 2014 15:15:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the scsi tree with the  tree
Message-ID: <20140702151549.00183ad4@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/pKl.Yquj8Y7IzFc+f02=P2i"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pKl.Yquj8Y7IzFc+f02=P2i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the scsi tree got a conflict in
include/scsi/sg.h between commit d15156138dad ("block SG_IO: add
SG_FLAG_Q_AT_HEAD flag") from the block tree and commit b15b9fab9f32
("sg: add SG_FLAG_Q_AT_TAIL flag") from the scsi tree.

I fixed it up (I used the version from the block tree) and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/pKl.Yquj8Y7IzFc+f02=P2i
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTs5WKAAoJEMDTa8Ir7ZwV67sP/0+iYRvDm3owjoe7+gFNNJOe
TOPdo1QFa0dYuQBU3tM+UwHR/9Avt3qvrAg+TfairRKHFu8Kubp2L7JXOh7RYNcp
CCmHenivaCpg5z7iVUQy6RYPjYDlisuUmpyRHbcmi9om4aEhD1NOgVPkWz8x+Hzt
9SCLrvNmRXUlBH+Tzxu8rxynyuetIHv254fo1EG6EtByZYcdkCVlRM9W+FsF7vIL
aHszgckkErQ9rzz4w9s2i/3Vo9e04CqIQm1luD2cfUlIyC3iVn8MLyh4LjhCodAc
nR7bSe5CZGIzwE5/bLzOJglHe8NgW9rkcGCUMPJsPxWzYjyLn/JSIsrMDr2bsSwZ
RAfoPw018Ww065sXwP9XKeN1SZZ3iuRQ0c1PaKhJzORMtHSv0vKxm1mykAGqc3UQ
C8s4/E7+H1+O2v8Hqmpb8AC/CRFyWNfNd/EP5tAgAGSwd4UqvNUWpVTBQ/bbn4md
uC9EG+ZnktVPKzu8R6tEznTnM25JpBRfyBjdYFlYu1sAM+P0M/07UNb41LGTozZK
/SAGk8bFoKyL5EGIJImeEfKiI36psY5ePS5QEiGOFpFJ2WEHssC/knD+z/NaRzQI
Cg5YOLeCimr96gAa2FDds+nSKPf4q/jlMPNzyB0sVepDQUi5U9Eq22D9LQUSsaVX
xkRN73H8kZb85CQJb1rv
=bTsv
-----END PGP SIGNATURE-----

--Sig_/pKl.Yquj8Y7IzFc+f02=P2i--
