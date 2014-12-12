Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934843AbaLLKFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:05:01 -0500
Received: from ozlabs.org ([103.22.144.67]:33553 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934608AbaLLKE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:04:58 -0500
Date: Fri, 12 Dec 2014 21:04:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Dec 12
Message-ID: <20141212210449.7f460bb1@canb.auug.org.au>
In-Reply-To: <1418377757.5756.24.camel@x220>
References: <20141212183518.06e3803d@canb.auug.org.au>
	<1418377757.5756.24.camel@x220>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/DpMCRYw8Qn2+7AYGZPCsv0M"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DpMCRYw8Qn2+7AYGZPCsv0M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Fri, 12 Dec 2014 10:49:17 +0100 Paul Bolle <pebolle@tiscali.nl> wrote:
>
> > $ git checkout master
> > $ git reset --hard stable
> > [...]
> > Merging akpm-current/current (35ac317b788c shmdt: use i_size_read() ins=
tead of ->i_size)
> > CONFLICT (content): Merge conflict in tools/testing/selftests/Makefile
> > CONFLICT (content): Merge conflict in mm/page_alloc.c
> > CONFLICT (content): Merge conflict in mm/memcontrol.c
> > CONFLICT (content): Merge conflict in mm/hugetlb.c
> > CONFLICT (content): Merge conflict in kernel/printk/printk.c
> > CONFLICT (content): Merge conflict in kernel/exit.c
> > CONFLICT (content): Merge conflict in init/main.c
>=20
> I think the conflict resolution here can be found in your merge commit
> bcab756e1d32 ("Merge branch 'akpm-current/current'").
>=20
> For some reason it removes the only check for CONFIG_INIT_FALLBACK. I
> only noticed because that makes the Kconfig entry INIT_FALLBACK a nop.
> That check and Kconfig entry were added in commit 6ef4536e2f19 ("init:
> allow CONFIG_INIT_FALLBACK=3Dn to disable defaults if init=3D fails"). Th=
at
> commit debuted in today's linux-next.

That patch has been in linux-next since Dec 3 as commit 77a4494388ab in
Andrew's patch set (and maybe earlier).  However, also in Adnrew's
patch set is another patch ("init: remove CONFIG_INIT_FALLBACK") that
then removes CONFIG_INIT_FALLBACK.  There is a conflict because the
first has gone into Linus' tree today (as commit 6ef4536e2f19), but the
second has not (I don't know why not).

Hmmm, I would have expected the Kconfig entry to be removed as well,
but either I missed that, or git is not as clever as I expect it to be.

> Anyhow, I'm sure this all will be sorted out in due time.

I hope so.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/DpMCRYw8Qn2+7AYGZPCsv0M
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUir3HAAoJEMDTa8Ir7ZwV/BUP/2V1ldh942V9MWz8u4jeJpZ+
4SMbxNFYqx8Cc7JUeJiIBKABmj2aiIhUPgrW2ig+MVmKQu97ByPSV6HN8zddacHE
GKy/YbbPeyHCeHdzSpvigtBUwVP2UFnq5jwlKce2Fikyoo7LB9jKtY78h4zUgTb3
DRkljIt6jHQfOwango3+XcQbmC+dfCTlasysD62eNdpjnlSfVwNsohZO2dj6+MBY
ayvF8zKXJqMpEaZxrNnET5woksA8x4eI6bbkytHgzZPnJ02D84d2GKY5Ox56l9y+
5RSiBWPYP4013l4FaUyUvYZ8uBkurnGwmyJVOKM6h0BnlHhdujl9RVspxNhN9kTp
VpUzdp0jlndOWpScNkvNrXPc0Ylg56AvakisB74po0NadOT/dM61AMX68xjUZ3RA
WbFtiqv9iCh3hmH/+ikhHWXdZFw+3xXUXFDpbj9gURKUPT+7Mjra0EbsaOmJdu1X
YM7UFjxOvdmlBB4DU+kQwecAShS9xtN/Gi8xTEGR8oPsKbf54Q7xTAE/pADsuW73
lOR2KpbS8IVGaERA3rKkp2MIzpB5iq8/LDtBhJOwieHetRWoNFyK8xBazsx4ABFl
Bvk+uV1oL0fuMtMIzgWLid60ttaH7mIq6Fqf0EpS79UQI934uwzVHF2xvaEoRbzV
Y2O0lLVUM/IcC2jgS6aQ
=bdDE
-----END PGP SIGNATURE-----

--Sig_/DpMCRYw8Qn2+7AYGZPCsv0M--
