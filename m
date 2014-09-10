Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaIJGCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:02:37 -0400
Received: from ozlabs.org ([103.22.144.67]:51851 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaIJGCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:02:36 -0400
Date: Wed, 10 Sep 2014 16:02:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>,
        Joe Lawrence <joe.lawrence@stratus.com>
Subject: linux-next: manual merge of the trivial tree with the block tree
Message-ID: <20140910160225.4f41985f@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nQYNWgMnDcwvCu3qW5fb3g7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nQYNWgMnDcwvCu3qW5fb3g7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
block/blk-core.c between commit a492f075450f ("block,scsi: fixup
blk_get_request dead queue scenarios") from the block tree and commit
da3dae54e4ff ("Documentation: Docbook: Fix generated
DocBook/kernel-api.xml") from the trivial tree.

I fixed it up (the former also fixed a few places that were fixed in
the latter) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/nQYNWgMnDcwvCu3qW5fb3g7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBCAAGBQJUD+l2AAoJEMDTa8Ir7ZwVvD0P+Nr7lNR3x87CJERIw1BSubUh
MFcvqx7EmItpesDfB3XAa6qm+3OE238skfgff4w8LbRFRTJ6QF7FYYqVNOA3jSzY
C+7yxRy6+o5QqeWpDUgJWL/oFM3KA4kNJmPRxkScFMrQGEQif4V4dUlB9qRq9lOj
Uq55BJkgMzxsNaLq6w3cTLQZD46isgpsnWKhO9aIz+GueLIKi2Aro4EHmrMgUOPD
PN00LmCXzViXitQOpvM+hhqP/mc5qBp2UFqIzM9dwn2WJAHGnfhbKMkSxiDqpU26
F21xyeEXyfspVmjjgAftg1W5ZARw5v3p/CkH6WgCRLpvlV8rB4CDesTouz5Cwrkx
b6MdelWoJIFKJtdcaPjZwMJq0oCkYDYkVquV495N6IHVOOxTEBv4lfAK6/YNozYc
KMbA4rhf17nf49lfgccWVoMJPdWIjHOsMU8j/CfTubekrEO+6k74RuTw95nNHIuH
UMJl/9WWqq0MLxLxeasEmz9A3cVPlKyTtmKvQbjtPjcD1XRzVbnUwNB9FdVf2X5l
SC31U9WoZVIeY4jowC91lJGza3vQvcyCQt4eLiHiLXXlDh5pJgZwJkx/0TT/5a74
yjSR+ttSTmKLD+Gs6uNWKf5uJj/ldYV4BNWQgkTm0v8Xeu+wU7/MSGDDhlUluNxZ
KSqglTHm2vtgd/UnEuw=
=vc/q
-----END PGP SIGNATURE-----

--Sig_/nQYNWgMnDcwvCu3qW5fb3g7--
