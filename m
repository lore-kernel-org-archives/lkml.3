Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaAQNIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:08:49 -0500
Received: from ozlabs.org ([203.10.76.45]:45316 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaAQNIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:08:46 -0500
Date: Sat, 18 Jan 2014 00:08:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ipc] 5769cf63: LTP semget02 TFAILs
Message-Id: <20140118000830.6df3531aaaf85fc284313b13@canb.auug.org.au>
In-Reply-To: <20140117102428.GC8751@localhost>
References: <20140117102428.GC8751@localhost>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__18_Jan_2014_00_08_30_+1100_km/OCfkBUkh7D9WG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__18_Jan_2014_00_08_30_+1100_km/OCfkBUkh7D9WG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[ Just adding Andrew to the cc list ]

On Fri, 17 Jan 2014 18:24:28 +0800 Fengguang Wu <fengguang.wu@intel.com> wr=
ote:
>
> Hi Davidlohr,
>=20
> We noticed LTP test failures
>=20
>         ltp.msgget02.1.TFAIL
>         ltp.semget02.2.TFAIL
>         ltp.semget02.3.TFAIL
>=20
> and the first bad commit is
>=20
> commit 5769cf6355d87f63906b3e51887eff7017c39217
> Author:     Davidlohr Bueso <davidlohr@hp.com>
> AuthorDate: Wed Jan 15 16:56:01 2014 +1100
> Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
> CommitDate: Wed Jan 15 16:56:01 2014 +1100
>=20
>     ipc: share ids rwsem when possible in ipcget_public
>    =20
>     ...  and rewrite the function.  For scenarios where the key is found =
and
>     we end up just doing different routinary checks, we can downgrade the
>     ids->rwsem and share it among concurrent readers.  These checks inclu=
de
>     the following, which are all safe to share the lock:
>    =20
>     ops->more_checks() >>  sem_more_checks(), shm_more_checks()
>     ipc_check_perms()  >>  ipcperms(),ops->associate() >> [lsm]_[ipctype]=
_associate()
>    =20
>     Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
>     Cc: Aswin Chandramouleeswaran <aswin@hp.com>
>     Cc: Rik van Riel <riel@redhat.com>
>     Cc: Manfred Spraul <manfred@colorfullife.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>=20
>  ipc/util.c | 60 +++++++++++++++++++++++++++++++++-----------------------=
----
>  1 file changed, 33 insertions(+), 27 deletions(-)
>=20
> Thanks,
> Fengguang
>=20


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__18_Jan_2014_00_08_30_+1100_km/OCfkBUkh7D9WG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2StbAAoJEMDTa8Ir7ZwVvEEP/08zs7p7gCaPe7SH0Mdlrrff
RHNy/EETVO4cx+rwgZdXJPefMw7HNDBMRHBnZhIitACaBJnTeiWSqD/vA5AvmpFZ
/GywKU7Hj88cCFZwYXC+RMqup8yYlNblRbAPot+B12i71jPmbfSeGWTTUtaq3R5R
tcaqTNv5cpiP9re2W0qTejJ1tXlSFfXVP/oP3jjz9iY2ljCl2bN5g0AC9ZiowtyJ
CdRszer1blCyHPlaGAfrc3yPoDVEXe2lrc5YA0Jk9J/bMlHfA9uv4To0KA0nfqtb
l9PlQPoz3Gx71rHk1D87k+V+GEJ1JHH4VLRQ8W85Q4CtEGj9gll9z1AIk4FMmoP6
yJUUozKHGV5/bW+Ob5UOve6XPp+KMasE21+8/MH/cXee/KyPmbQiMx1qnEh6VEYp
hgcEq/vs5rSSESLv59HcvB50tG7aehe6sbsfa2ktzcqfP3HmuR5Za+EsKyUivUq2
AiAtcZA0JM7Wn7LMweH+zs0Ge2QCjklFP298hSc3qcdy/HS+zyu/x7fsWFUngYy+
pIGAxBHn8ecs+q0FldEa2JHcrWEC1yQ1gXcgTyN16ldvvNAGkQuUm7Rof+x2yglB
K5w4YlVie7/o2F38hNCOJ7GcfCrpHcH418TMZE1raPBgabCobMCp09Q8zq9ILB5Q
blTaUa/EOgQsycDbHVsL
=BS2Y
-----END PGP SIGNATURE-----

--Signature=_Sat__18_Jan_2014_00_08_30_+1100_km/OCfkBUkh7D9WG--
