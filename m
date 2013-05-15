Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3EOCt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 22:49:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40979 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab3EOCtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 22:49:08 -0400
Date: Wed, 15 May 2013 12:48:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Tony Breeds <tony@bakeyournoodle.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Build regressions/improvements in v3.10-rc1 (um)
Message-Id: <20130515124853.6c8ef25177a1f15a0fc01142@canb.auug.org.au>
In-Reply-To: <CAFLxGvxRK4E1VHpPYjs3Jg1oNWAFsBAuvjSq=xYn-gPO9GyiZQ@mail.gmail.com>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
	<alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
	<alpine.DEB.2.00.1305122247320.5463@ayla.of.borg>
	<CAFLxGvzA5nzpQjOKWgz0nBKG2s3gPspted-25uduqkr7_ySj6A@mail.gmail.com>
	<CAMuHMdWt0i6Q+i9Qh+tMs910a388NoddhHmq2LGr50f1=dJPvQ@mail.gmail.com>
	<38896893-83c7-4eb4-848a-bb35663d945b@email.android.com>
	<CAFLxGvyKANuy_vezO+E1aL3FzvdjiNgCD3j-BVGSyL_ne015Xw@mail.gmail.com>
	<CAMuHMdVnbbJDq0vcc4e-NCWFUqgAzv3YU470B3jGFDN0xR+E=A@mail.gmail.com>
	<CAFLxGvxRK4E1VHpPYjs3Jg1oNWAFsBAuvjSq=xYn-gPO9GyiZQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_May_2013_12_48_53_+1000_PL5YcTZEYhu__=pX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_May_2013_12_48_53_+1000_PL5YcTZEYhu__=pX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 13 May 2013 12:20:24 +0200 richard -rw- weinberger <richard.weinber=
ger@gmail.com> wrote:
>
> On Mon, May 13, 2013 at 12:18 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Mon, May 13, 2013 at 12:07 PM, richard -rw- weinberger
> > <richard.weinberger@gmail.com> wrote:
> >> On Mon, May 13, 2013 at 11:54 AM, Michael Ellerman
> >> <michael@ellerman.id.au> wrote:
> >
> >>> Possibly. We're cross compiling these on powerpc so perhaps we need t=
o update the cross compiler.
> >>
> >> Looks like you are the first man on planet earth who tries do build
> >> UML/x86 on powerpc. :D
> >
> > Well, it used to work: http://kisskb.ellerman.id.au/kisskb/target/2974/
>=20
> Cool!

We started getting these PTRACE_ errors on Nov 4, 2011.  Just before
that, we have commit 966e803ab125 ("um: unify ptrace_user.h") which seems
to have lost the include of linux/ptrace.h and now only includes
sys/ptrace.h ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__15_May_2013_12_48_53_+1000_PL5YcTZEYhu__=pX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkveVAAoJEECxmPOUX5FEMboP/20KbM9n4ix1rzYbAm2QhqfL
TH+q1UNDzKH79Yr8yJABlJLJfcUMdzoe8x8inezxPGfzgW//kPmtgcAWESjjaPEA
f0+Pzu4E1T1HLez5x56BWN9/PSUp6nbPPSPOvb7Pde686ULHjaEGGA4WYOS/wb+z
3Bf5RZGjK9TtbrR8zGp3Qvh6X9cCgS+cIsPORMlm1X3o+XjwaaVTLteFKB3MQOoI
d5cQ+3wY3lcviapFozbi9lNMkosFncaug0Ui+9/wGgbpvOpVkfcdBwPjoaX9E19c
3EKz1P0uziDIEXLT4uQhvDshEIv/17/EtFX+BcMtqzBJST0hyNBF4mXpW/VSRGPC
dojbm974u3gZ8QpbIeERHEYG493M95fNsFMDJMeIh2Qytc9WYwehZsFxsX8a6o0S
sq77IteEbFO7xNi5t5NQwCJF9c/xIVET5dmQEeo7VNAwjyuatGnZnuIhpLNW2AYF
4a+kRS71NX6AZ9Os5uXEEzGhAMXGK/30EkYYcr45LxtrTsgdm2ZgMYu/+15QScFZ
T8YQIHSGYyh77z24hYw3JEHxl0NAhJqXn2hjiv1cJeO8yYJj//H28M3TA8xIIQ1n
3xJNF/9mGTz2uskD4i1K59VWKSKZZqKT/0UXrMEHKmbW+vuwEXlhxqIPt++EdqrL
S93j6YumJNusxB+RIal+
=s9iT
-----END PGP SIGNATURE-----

--Signature=_Wed__15_May_2013_12_48_53_+1000_PL5YcTZEYhu__=pX--
