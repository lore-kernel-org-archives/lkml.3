Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbaHaAMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 20:12:37 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:39801 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaHaAMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 20:12:35 -0400
Date: Sat, 30 Aug 2014 20:12:24 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull file locking changes for v3.17 (pile #3)
Message-ID: <20140830201224.2543b95a@synchrony.poochiereds.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=H+1VIM4WqwB6VNXCR3q22F"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=H+1VIM4WqwB6VNXCR3q22F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 5317821c08533e5f42f974e4e68e092beaf099b1:

  Merge branch 'for-3.17-fixes' of git://git.kernel.org/pub/scm/linux/kerne=
l/git/tj/libata (2014-08-21 14:26:27 -0700)

are available in the git repository at:


  git://git.samba.org/jlayton/linux.git tags/locks-v3.17-3

for you to fetch changes up to e0b760ff71be168d4e623f7c3612e98902ab93e9:

  locks: pass correct "before" pointer to locks_unlink_lock in generic_add_=
lease (2014-08-22 09:58:22 -0400)

----------------------------------------------------------------

Just a bugfix for a bug that crept in to v3.15. It's in a rather rare
error path, and I'm not aware of anyone having hit it, but it's worth
fixing for v3.17.

----------------------------------------------------------------
Jeff Layton (1):
      locks: pass correct "before" pointer to locks_unlink_lock in generic_=
add_lease

 fs/locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--=20
Jeff Layton <jlayton@poochiereds.net>

--Sig_/=H+1VIM4WqwB6VNXCR3q22F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAmhtAAoJEAAOaEEZVoIVhqoP/15f4pV5c2utl1zuu9YnB+nX
qcJqhRBlN4ir9UW89UwOioxOybqGmi4yn8qte8d/hFyEj4Iv3JSSWg0+v59158KY
ur3k8powmLiub1nYPxajQyjPT2uNVwglNHU5r7zkkagVAMZ9bn2fWxSpaC/j0+b7
4cqLEgvczSYsdbaAYZXzZYOCUEyICoUMCxUw+SNJ3Ktx+cxKm8eRE3pzoWXlG/ov
5ikt2iuaohOuDdrj8jyAS6wpAJ2fOFCOGsVaTC1lsw1/RXp6viDsLBlnF1mZhzsb
2YEI8zrOds7071MtDKKxHvqEnpvlhlobiMG1wApMhgqeuFx52Mepm6jH9WD7mz1r
qZU/ICRako4q4wufZVcTosOmp//RL8r9G5qh4JCtgj7U2Z9LdERrpJyg0U6T2rLD
oc+/BEqNrL0HBUpTzVBSeaHYhI8JfVbbJiYfI/T7Ff5t1NhJOKepGUKL7iiR+Rxt
ddSFiVBArhNPx9SAZs4BuyR/jyQ0pVujhqpFRbFuLNotSgygZdwkRVw6Z2Q+FKKE
dHQ/esJYRit5omyZDMVtcWBBf+7QRhtIbqKsqFwlTRkMUFPSTwG7/woOrca+CDUm
WERreIFoN+ImJtiJns6mE9FZJfZMmRs7+fzdVNfsYowKw9IfQf4gUZR+q5IMabVL
X3rasemvtE9/71b0yMKU
=EEmI
-----END PGP SIGNATURE-----

--Sig_/=H+1VIM4WqwB6VNXCR3q22F--
