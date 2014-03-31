Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaCaNbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:31:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbaCaNbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:31:31 -0400
Date: Mon, 31 Mar 2014 09:31:20 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, bfields@fieldses.org, matthew@wil.cx
Subject: [GIT PULL] please pull file locking changes for 3.15
Message-ID: <20140331093120.10aeaba6@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Ha=+CRBN3swNDl2EaxsJLz3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ha=+CRBN3swNDl2EaxsJLz3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 29723adee11804b548903ddb1db666cf4a60f60e:

  locks: make locks_mandatory_area check for file-private locks (2014-03-31=
 08:24:43 -0400)

are available in the git repository at:

  git://git.samba.org/jlayton/linux.git locks-3.15

for you to fetch changes up to 29723adee11804b548903ddb1db666cf4a60f60e:

  locks: make locks_mandatory_area check for file-private locks (2014-03-31=
 08:24:43 -0400)

----------------------------------------------------------------
(from the branch description for locks-3.15 local branch)

file locking patches for 3.15

----------------------------------------------------------------
Highlights:

- maintainership change for fs/locks.c. Willy's not interested in
  maintaining it these days, and is OK with Bruce and I taking it.
- fix for open vs. setlease race that Al ID'ed
- cleanup and consolidation of file locking code
- eliminate unneeded BUG() call
- merge of file-private lock implementation

--=20
Jeff Layton <jlayton@redhat.com>

--Sig_/Ha=+CRBN3swNDl2EaxsJLz3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOW4pAAoJEAAOaEEZVoIVTDAQALLpq4yFuvqteW3DGYjAEm0i
jWCmqC9rpNhmt0UaX0TuF22pW+AyuXsL5/eQ1haa7IUKRCZlqzENYbzho1ByNqZF
dDMp2GskUv1eh3MuEtoQHWw+lTIygF6xmmAnfSB7h60Chv6u4qDOYz7D2HlynPOZ
4ALdTJHGzwIm5FnHSXkiAJTAwJUYRrz0iwGn4L6vCnlTX88JyOeFmJFTdsrqQPEF
XEZvdIKEXeWU/QCl3KaknDG0hq3LRHB2XVZxs3GoHOjBfYzv6RrCwWydy9PCCaVk
O8dhIWzvf83jNJj/+kpTfT5fZP6yI48RuA40RDit4CUAsC38aB24uEDe9YqS+27h
dNGdhdbzJC1W5S1A+VKzDW2NCL9nAd8DmLyr6oJHxeYrA5AkW5YgyUymfXGn+63M
RlulXccG9ttuIFZIyByFnkLn1BQKwr6ZpbnsVmpIWgVJ1u4l/TpCIEv85Kv9e/78
09xaYXwnyywxkz92Tt9QpZCk6dBZ0JTHgt9dXJT6XaFGoMe+XlfcDQn09RYXuxYl
nIr+EauqZKu2osIUz0mqnA7s/gzvpndQh4Gs6pRvR7M0JnCVaFCVaDUQS0ui3MRO
U/jlzPMYnJBMgVTaf/2FNPsG3cxa10+lgki3bmKgOuCoQN8ck4SOjedlEmRe0yQk
zxeL6LKpRzayEI0OrGNB
=PMIe
-----END PGP SIGNATURE-----

--Sig_/Ha=+CRBN3swNDl2EaxsJLz3--
