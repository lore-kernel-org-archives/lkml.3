Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaJWDJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 23:09:13 -0400
Received: from ozlabs.org ([103.22.144.67]:59224 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670AbaJWDJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 23:09:12 -0400
Date: Thu, 23 Oct 2014 14:09:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>
Subject: linux-next: manual merge of the akpm-current tree with the pm tree
Message-ID: <20141023140905.3bd78e51@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tCQaOA1OOlj2PI2JJwJUTWW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tCQaOA1OOlj2PI2JJwJUTWW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
include/linux/oom.h, kernel/power/process.c and mm/oom_kill.c between
commit 5695be142e20 ("OOM, PM: OOM killed task shouldn't escape PM
suspend") from the pm tree and commit e039ae202d34 ("OOM, PM: OOM
killed task cannot escape PM suspend") from the akpm-current tree.

I fixed it up (the pm tree version seems to be newer, so I used that)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/tCQaOA1OOlj2PI2JJwJUTWW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUSHFVAAoJEMDTa8Ir7ZwV+eIP/2G50kHXiJZhVtIQrTPm6o/g
HieqCiRzLYam0Gcv6FSr1t1mWIYnJwSEtXvYCrOMqz0FixDuBx85aEafPkSrHsY9
5Jej7pAMKY5qVF9Jz8RBAmYIRQFMSGLtOxG7VctYwCZzoDZdN9O3qwXMwT08fakv
6BfcAWTCKuvDFigtKjyHeTtZzF6DH8btl+jDvzc2rQwOSeAuqKh0R9MDlkrSpc+S
4GWL/J3rHYJB4nTTZFrhepdkzx1JWnwUCAa7HNRSjVDP/Kp2jHfxIxTlLpTQAyrr
lJzfi9yo1+noeJj2MsdmIRba3n7WK9T+9OSiWZXXJqQHnSEiy9fBJB8MveDRxIAd
rTYXijnQsNPR1l5onUKw+njx6FXE+YNPRvpY3l+9MP0rnpRxxeRpdSe4SZAAVX1u
T4+3s4sy7oF4zZHw7M1iTJN1NfNFVI5Z93hW3DN4R4nT6qtj0v9VqqgL8y5NYOeG
KG7y648sIMsBkKpWRKSGAtiNVvp3Ij2AtzjxIgTL5I1+RdsG69EIhMEtbW5lpmyF
nSes76+/98bsvEp4MxiESdpkFrfZuRuw+usmODoBwowUwxeWg3EMs0l1QF0zy81v
wU8nNdCoewFTaXVks6PWxeP3UNcIcsRvts4urRuYoSFNgprEHzMADQAhkQVvraxZ
cO/Nx/0SvzMcq20VNvzv
=UlAh
-----END PGP SIGNATURE-----

--Sig_/tCQaOA1OOlj2PI2JJwJUTWW--
