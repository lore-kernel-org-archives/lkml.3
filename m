Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3CTX2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:28:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51466 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab3CTX2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:28:42 -0400
Date: Thu, 21 Mar 2013 10:28:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-Id: <20130321102829.5ab9584c8d7eeb05bc4a3909@canb.auug.org.au>
In-Reply-To: <2731.1363798359@warthog.procyon.org.uk>
References: <21286.1363716700@warthog.procyon.org.uk>
	<20130318131224.43ebcf542e6dea358f546198@canb.auug.org.au>
	<30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
	<567.1361470653@warthog.procyon.org.uk>
	<CA+55aFyJFrU2ea+y8BS2tOawYY1DeDzEr4dYO4j8enewd+KHNQ@mail.gmail.com>
	<20130221183445.GB20629@fenchurch.internal.datastacks.com>
	<CA+55aFwX5AmMgEAZ8uSdH=8g00xVD3NfnvgBbgSytMGdcifKMg@mail.gmail.com>
	<2731.1363798359@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_10_28_29_+1100_4AMY5_k3yQ=s4gA3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_10_28_29_+1100_4AMY5_k3yQ=s4gA3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, 20 Mar 2013 16:52:39 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
> David Howells <dhowells@redhat.com> wrote:
>=20
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >=20
> > > David, if I do remove it, are there other patches in your pekey tree =
that
> > > are still going forward?
> >=20
> > No.
>=20
> Well, maybe.  But feel free to drop it anyway for the moment.

OK, I have removed it for now, thanks.  Feel free to resubmit it if you
persuade Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Mar_2013_10_28_29_+1100_4AMY5_k3yQ=s4gA3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSkYdAAoJEECxmPOUX5FEnWAP/2B/P/lQoOqOW2FM6HevKVjy
ht+gPfK5CLzSmf87T4fxnjRiOmPKA3Ya4iBekxxWuSryjGDIgCt/2M/WW2g0yn1S
AsdaN47JE+IwuQENPbt6KrpwmebklCCLN9fT7VdT2Yb3aUErYPYOMFkKDVfEG1A8
oaHCxaun3WdIqeyDmAtyqE5lrCI7KaXsXRbK5SmWcNOr3Ldvk3tZ0Fi20Pr/hY27
OiwkUAeq3wHpn6zfRdjl/RgVwCyrND9KcQM4PSWgFKwSFtcOnGcMpu0xtpbFriXC
uZA/aItY5s/PbsV2lPCoWir6FckD6FgMshi230q63JMPaKKTxj3GnmmbVZyHxpR9
SKCLQxvPJN5z/BGGvVyOBTn4cDQFlzkBp0w2+SXJ4U8HANzY4HAGSXtYwbyvW/aB
DmA3SQKs3MK7ihKr+eYSiSSiHOMC42HvguG4kdoAW62n1LO7eWjCdtCJdEG2tlNA
3di228TQOYgBJQiqGpuivXlPHP8wrqWDvErtVyOvQl3hgAM8M3ILPzeZtHFR3e08
Y7v+xsmoiTIIwAeigx5XN4O+vac9jfW0gY/FvuRDKDZXhJD8xMXghYmWnv1dYL0Y
SnfBBwu8x2tEie05FHoOIPxDykXAEJQLeqJ5EU0ojqvKjdz2Ci2ZQLeyogXAUMZg
LAmxj34fqMmkYyYSHbg3
=x2A6
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_10_28_29_+1100_4AMY5_k3yQ=s4gA3--
