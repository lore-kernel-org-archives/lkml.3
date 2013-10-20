Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab3JTSGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 14:06:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37617 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654Ab3JTSGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 14:06:34 -0400
Message-ID: <1382292356.2794.116.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [000/121] 3.2.51-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Date: Sun, 20 Oct 2013 19:05:56 +0100
In-Reply-To: <52640379.8070609@roeck-us.net>
References: <lsq.1378608720.401499712@decadent.org.uk>
		 <522C22DB.9080008@roeck-us.net>
		 <CAMuHMdW6TGdfi+FH=hRWY_hhs5Cb5N9xV1OL0O9Dcs+PfXm2xA@mail.gmail.com>
		 <522CAB38.2010909@roeck-us.net>
	 <1382270174.2794.96.camel@deadeye.wl.decadent.org.uk>
	 <52640379.8070609@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-qUAKE/hW1Q6tWs8Wa7xd"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 82.132.212.222
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qUAKE/hW1Q6tWs8Wa7xd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-10-20 at 09:23 -0700, Guenter Roeck wrote:
> On 10/20/2013 04:56 AM, Ben Hutchings wrote:
> > On Sun, 2013-09-08 at 09:52 -0700, Guenter Roeck wrote:
> >> On 09/08/2013 01:18 AM, Geert Uytterhoeven wrote:
> >>> On Sun, Sep 8, 2013 at 9:10 AM, Guenter Roeck <linux@roeck-us.net> wr=
ote:
> >>>> m68k-linux-ld: error: no memory region specified for loadable sectio=
n
> >>>> `.note.gnu.build-id'
> >>>
> >>> I can't seem to find an explicit fix for that since v3.2.
> >>> Perhaps the fix is a side effect of f84f52a5c15db7d14a534815f27253b00=
1735183
> >>> ("m68knommu: clean up linker script").
> >>>
> >>
> >> Kind of. Turns out it requires the following patches.
> >>
> >> 40c1b9cf (m68k: consolidate the vmlinux.lds linker scripts)
> >> ed865e31 (m68k: use non-MMU linker script for ColdFire MMU builds)
> >> f84f52a5 (m68knommu: clean up linker script)
> >>
> >> With those patches applied, all my m68k builds (mmu and nommu) pass wi=
th 3.2.
> >
> > I've queued these up for 3.2.  The first looks quite a big change in
> > terms of lines, but most of that is just renaming a file so I think it'=
s
> > within the spirit of the stable rules.  The third is also pretty big as
> > m68knommu seems so broken in 3.2 that I suppose it is OK.
> >
> > Ben.
> >
> Hi Ben,
>=20
> is that in your patch list yet ? Just wondering, because the latest nommu=
 build still failed.

I've only just pushed them.

Ben.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-qUAKE/hW1Q6tWs8Wa7xd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUmQbhOe/yOyVhhEJAQoq/A/5AXCWVWnmaiKVgX0z0JHXvAqJUFJHzTEu
8f7+7Nt7gz4eIHGSwTo0oPpvugikH+HlUNRXagA7+C2y6xX1aw4aq78hmcYAu77K
tB1xioNRnn7nP0Sfh/k4msVWR6dV/REOIkY+gUGwMkfSpMPrs/urOqmMWKf7RsqF
kVR38oONNCkvu2O5cmNqMJe8g2W2dm4gl9u5+X+Em9aeRG03/bkzRBU/J4NbC7AO
RLclqfJQFj0NDTJ8+vQmCk0qW0HspwzNP1j6Ur6fjz8qp8vrmXdXEtI/JA8q1JOE
bkVcpiivN6xygCV1V8OpFwS3qYPJ22CyhhzBRHyTdTdHHJH+m/+e67VuRHoElA2r
vfDgVgvkIZFamfNsCp4jdIEG8rYznREdIErI6iWBabtJdO9VJwk6BHnvGl2TK/sA
lWQjM5hWMhCh7JjrOQ/Rti6iGCzP9pTgdS0OGlLFf7tNOv2/xzXXp9AFLdP02RJC
4ujGd/WPepVSqsNorqfYDFFgdwNdAz02EX2RgBr7lsWiVwSIswWbnJS3tjDdVuut
0uVZfRpU/35U062GqFPu6t+n+785Y4OigMih9hNOwKm+Aws7gkeVP8glD43RTY5t
Fb3jj6qFfIXX39nswzI3r7HYCmHKKe+R86UDBX6E073g/7k7qQIzHoBvo3V2BX6E
OhSuGoR8Pow=
=VAhW
-----END PGP SIGNATURE-----

--=-qUAKE/hW1Q6tWs8Wa7xd--
