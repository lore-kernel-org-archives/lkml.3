Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaGQBr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:47:28 -0400
Received: from ozlabs.org ([103.22.144.67]:44552 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbaGQBr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:47:26 -0400
Date: Thu, 17 Jul 2014 11:47:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Jul 16
Message-ID: <20140717114718.3895d851@canb.auug.org.au>
In-Reply-To: <CAPDOMVh5_JXKwPQ9EwtXHLYnqNRhEMedF5F5K7H+PEqMuCZa8Q@mail.gmail.com>
References: <20140716184550.18b6da3f@canb.auug.org.au>
	<CAPDOMViywcY=cYFT9EM3N3wESXQUX7uWa3jLLLKpv=QGF-Dtmw@mail.gmail.com>
	<20140717105144.2cb29989@canb.auug.org.au>
	<CAPDOMVh5_JXKwPQ9EwtXHLYnqNRhEMedF5F5K7H+PEqMuCZa8Q@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/CVPgom+r5bv=gRV=+YvZf+s"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CVPgom+r5bv=gRV=+YvZf+s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nick,

On Wed, 16 Jul 2014 21:16:16 -0400 Nick Krause <xerofoify@gmail.com> wrote:
>
> > On Wed, 16 Jul 2014 20:45:25 -0400 Nick Krause <xerofoify@gmail.com> wr=
ote:
> >>
> >> On Wed, Jul 16, 2014 at 4:45 AM, Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:
> >> >
> >> > Status of my local build tests will be at
> >> > http://kisskb.ellerman.id.au/linux-next .
> >
> >> I am trying to get the maintainers to clean up still failing builds.
> >> When you get time I wondering
> >> if you can send me a list  of still failing builds and warnings of
> >> interest in the kernel that is'
> >> up to date for me to help clean up these outstanding issues with the
> >> maintainers support as needed.
> >
> > See above ...
>=20
> There seems to be a few that are still succeeding for me that aren't for.
> Would you mind testing some of them again to see if they are succeeding
> with a gcc compiler that is newer then version 4.7.

Please tell us exactly what you are testing: what kernel version, what
compiler/binutils version.  The kernel is meant to be able to be built
with gcc 4.7 (and some earlier) - barring compiler bugs, of course.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/CVPgom+r5bv=gRV=+YvZf+s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxysqAAoJEMDTa8Ir7ZwVqTQP/AhmEzSR2qcD7qr69Z1Jq0W9
Ek1uSlrar8yFM0rK8bvwkE4pl7vwtuhP2r4ltoI5/xCPgbqUOPqPNUO3GrvxgzN3
9DL9SzyqxXNzhOZKKIJWrmzRxnx9l1Hs8COmV12vuTRN5vqeMGUoMiM/7eBrXKUZ
GvXaQgaxa0C15wrA0J6puzig3UIaF15Ajoaq91Ycpgnffjz5Ed47hGq6DPqrOC9y
9v5DDoZpsh+K/sKxtbOKqyRd9RHn5UgO64oEejmxJnkREizWoduPSJ2AK/48e6sQ
oTySxb4pP3PStT/tKtbAXctoYYpBG541LA+aKvBW0NaQ1oFBHIzNdz9wCSteesyy
F2QdCvme83VWojZMJjd7dUzapNrBjl0YGRYCqHUGPAWhp/HjRqLT4BCNvr6b7yf4
nzqNORX0WPJJP8rMZJ56qpEHqo8vx/SaF/34wfQtHSlRywmJr0e1jjnJIzR+bNNU
4aVLJJ0JdgIAhKaNB8gOH/viXxT5j7wD1Bulb2AOf1nsrSNpHpHTFAf0Bk+iUQ/c
GaQC/SlckJPGAz1s5GHyWTnyteKs51i6PnBKLHusW8lwyWm5VexbTaLquQchvvsF
0DKkaKgbI/qOmPC2+N7Q1Xyrnbfn60cfatd85O/zRIYjqsj5UNDIUkXqKCq7jv50
FTnd04e2OCM8Fnm1qCyW
=6oCx
-----END PGP SIGNATURE-----

--Sig_/CVPgom+r5bv=gRV=+YvZf+s--
