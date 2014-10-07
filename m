Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaJGFco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:32:44 -0400
Received: from ozlabs.org ([103.22.144.67]:55499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbaJGFb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:31:27 -0400
Date: Tue, 7 Oct 2014 16:31:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the percpu tree with the s390 tree
Message-ID: <20141007163118.1cdb9544@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/pj9=OBN6xnIzbR7=EN5kQ4y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pj9=OBN6xnIzbR7=EN5kQ4y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/s390/include/asm/cputime.h between commit 201b275f0459
("s390/nohz: use a per-cpu flag for arch_needs_cpu") from the s390 tree
and commit eb7e7d766326 ("s390: Replace __get_cpu_var uses") from the
percpu tree.

I fixed it up (the former removed the code updated by the latter) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/pj9=OBN6xnIzbR7=EN5kQ4y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUM3qqAAoJEMDTa8Ir7ZwVFTgP/2mYsB0CTE0jUcokfi+JKMat
3GswSlXciZdRjU/IuswnOTlJ76RMHnIHvHcRvNCbjz5gUlh2LQTegGifNbjhSeI+
N4bkZ0WngA0gz/ItZRYup+cRoRymelf+6JYV+ypP+i9wybcgORBWVxByl3dHo2dQ
bqIzHO70M71N8wJiEZOnrBIFc6u4hrNNl7sveu0gvWpLibYhxl5Ha4ABAPtMxLZI
FpFijcghKrFBN/dZIANcs1yWDY0775SEFmqQ3Gyi/WZok8fQzxyWct2HmhQxPY9H
WqjB/IIzZTfPmTEUrZb5LXcMJWTanZyZSurUeD4v/j0bM5jYZFsy+rd8qs1ZyEw4
zK1JlCrVpdrHcAwfVLvk6FPhvWBKF4ogOO6g4IRTkF4n1S0EOkQ2bfN6CswgGLzi
ZJm0L6llHkF3X+3tKkRONCSmnyfBZX0pdP6HnVE37tXfameePCXM0AwZrxyZTZEJ
MXyMCnjMoGVicBEXA3FVErRU0utYw813WI9C4VhhqgZ7J5iy1ADQViLcmR0LrY7m
UP5Yi5pXZrIspE55jnVBf/F7tuGarErtE+Xl03YH2/zkuUyh5C+F75Sae7xuJ9kS
wtUk5rKiSCSzgLMj/vcuE9/E33bOWYhUSMpXB3Unwaxpc6/5bhcQ1WCOOudERjSI
vrJkjbuSXZGzJzin/BmF
=sIi/
-----END PGP SIGNATURE-----

--Sig_/pj9=OBN6xnIzbR7=EN5kQ4y--
