Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaHGA2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 20:28:34 -0400
Received: from ozlabs.org ([103.22.144.67]:49263 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbaHGA2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 20:28:32 -0400
Date: Thu, 7 Aug 2014 10:28:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Weinberger <richard@nod.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [GIT PULL] Global signal cleanup
Message-ID: <20140807102823.7a743bdf@canb.auug.org.au>
In-Reply-To: <53E21186.3000702@nod.at>
References: <53E20F1E.2080606@nod.at>
	<20140806212720.66dbd58b@canb.auug.org.au>
	<53E21186.3000702@nod.at>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Nv1vUrpHWTkFQU0vb4I.MsY"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Nv1vUrpHWTkFQU0vb4I.MsY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Wed, 06 Aug 2014 13:29:10 +0200 Richard Weinberger <richard@nod.at> wrot=
e:
>
> Am 06.08.2014 13:27, schrieb Stephen Rothwell:
> >=20
> > On Wed, 06 Aug 2014 13:18:54 +0200 Richard Weinberger <richard@nod.at> =
wrote:
> >>
> >> the following changes since commit 19583ca584d6f574384e17fe7613dfaeadc=
dc4a6:
> >>
> >>   Linux 3.16 (2014-08-03 15:25:02 -0700)
> >>
> >> are available in the git repository at:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal-cle=
anup
> >=20
> > This has all been rebased onto v3.16 but none of the patches changed.
>=20
> This was my indention. Also I've added some acks.
> Did I screw something up?

We discourage people from rebasing their trees just before asking Linus
to pull them unless they have a good reason.  Adding Acks is not
necessarily a good reason.  It may be a different thing if you rewrite
your tree (without changing it base) and, given that none of your
actual patches changed, that would have worked for you.

In your case, since you haven't updated the branch (signal_v4) that I
fetch for linux-next, its doubly bad as, after Linus' pulls your tree,
I will have two copies of all those patches in my tree - which could
easily lead to conflicts that I really don't need to have.

Also, note that the fact that the actual patches did not change at all
means that either you missed some change that coudl have justified the
rebase, or the rebase was unnecessary (since the things you are
patching did not change).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Nv1vUrpHWTkFQU0vb4I.MsY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4sgsAAoJEMDTa8Ir7ZwVIksP/A4ihaJNYEJMfI2QbroS7phD
aw9mnnyWOkiACxi5yFKeZLgbri4QQ2Nquuffd7dQU0p3HE4FXUZRIRKrnx0lE4HZ
ISWHRa/avlYy+mSgQKjPAbVc2mFSWhlHkBaaYqEQAz/Y4zGCPb4f5txeHtU87LQx
aNwnPRz3VHUvrVsgljtSR7NoDnjFFBmOtLutA8irvYq9l4VZtBxlhMUxee9s3nku
dvW7Rfqfrm3FOVXZWLaopCuU/FF7kZt2G74475TIyFiV5U1cc6M+h3qH6PyRjzL1
IQgCl+SAOY5KQApkBljEj7W635X/UejsO42STmZPudZKPjpmaCglYsCj6VvwiJts
dSNR34jLVkIfy9cY4EXdoLrUCcjaa4ib9itdIaGICvHaXeKEI4pE/oHBzZmtfqfO
kgk1vzxCmikJss8BCta4qGDUHYuDUJlP0vJsosEtFyY9uvfJfvYxnAkWGmoOFuDN
zDBlE6pDpU2nB4sZd2CHWZPSBu1uchcuRmgJDmKP9O9Hbibg9L4ESqlvSdZU4exJ
DLFrcghkZBzYifZ4Q3KVCsdhFMtC0C6haQZcWYyj8qVIBxuQJEt6jDW0quy8AjbF
louensC5enCCPZw260q0Nq6TCnSRnYfnjaqvNJlLkk0OcLyN7ZOb8ErhIrhcJ/Hk
4ZeQrFal2ZUirjSnee7T
=ev1y
-----END PGP SIGNATURE-----

--Sig_/Nv1vUrpHWTkFQU0vb4I.MsY--
