Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab3JTMAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 08:00:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36881 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326Ab3JTMAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 08:00:17 -0400
Message-ID: <1382270174.2794.96.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [000/121] 3.2.51-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
In-Reply-To: <522CAB38.2010909@roeck-us.net>
References: <lsq.1378608720.401499712@decadent.org.uk>
	 <522C22DB.9080008@roeck-us.net>
	 <CAMuHMdW6TGdfi+FH=hRWY_hhs5Cb5N9xV1OL0O9Dcs+PfXm2xA@mail.gmail.com>
	 <522CAB38.2010909@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-LYxmelbr38wHD5b/t77S"
Date: Sun, 20 Oct 2013 12:56:53 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.8.5-2 
X-SA-Exim-Connect-IP: 82.132.234.81
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LYxmelbr38wHD5b/t77S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-09-08 at 09:52 -0700, Guenter Roeck wrote:
> On 09/08/2013 01:18 AM, Geert Uytterhoeven wrote:
> > On Sun, Sep 8, 2013 at 9:10 AM, Guenter Roeck <linux@roeck-us.net> wrot=
e:
> >> m68k-linux-ld: error: no memory region specified for loadable section
> >> `.note.gnu.build-id'
> >
> > I can't seem to find an explicit fix for that since v3.2.
> > Perhaps the fix is a side effect of f84f52a5c15db7d14a534815f27253b0017=
35183
> > ("m68knommu: clean up linker script").
> >
>=20
> Kind of. Turns out it requires the following patches.
>=20
> 40c1b9cf (m68k: consolidate the vmlinux.lds linker scripts)
> ed865e31 (m68k: use non-MMU linker script for ColdFire MMU builds)
> f84f52a5 (m68knommu: clean up linker script)
>=20
> With those patches applied, all my m68k builds (mmu and nommu) pass with =
3.2.

I've queued these up for 3.2.  The first looks quite a big change in
terms of lines, but most of that is just renaming a file so I think it's
within the spirit of the stable rules.  The third is also pretty big as
m68knommu seems so broken in 3.2 that I suppose it is OK.

Ben.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-LYxmelbr38wHD5b/t77S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUmPE3ue/yOyVhhEJAQoMEg/9FgfIV64GqP93g3jr8Zy/owOAe8E74sgJ
uDXMm+7INkdrRSxsmlp/YdkFagpOrc1iUbMoUKD+HVzLDv9oQWx5KGUSmX73tbsw
DY4F6x71OCT3V/5irqbKGzmMlJNPIcJKBzjuezGi2RiAcyjrMyyC11hqKfNkcGcp
/3HGgYAQcOfvpamjxHFEsDerrAP2x6o/oY8UCBhyeWoLxJK27cvXg6bEem1ts8EP
ogH5Wk/5HEGNKHDKcio62ik2yiq57aKsitlv7K/nUfAETGsHkZfEu46MZIG5vgyF
VnYqBD68cyBzXNu+7S7pP4Ah+1GfmjgjcyNXgdzCjgOCx8WNXk/XAMM2U6yQVdqr
O9vY0DL+aTa3YQzwEoiG78qEGsEKPju5t38wIo/zkGCYuPBm+rPQ836nN9i/drC3
tPL8j+0pp/b2RDIRv0nbr785DuH3OWlCK/8Bbxwu/Y+lM1/uHGQiTLuw7hyJc3fT
yuh5aMFKJtoQ8NnVfLqW/kx6AIQmVVmCrjlf+Yur/DMSFHSkfyUUN1jpzM8C1Q2V
JIeX5MU40s8V/O8r4/tDmb2ehB05w6twtzf2IvNlvoIm4Ys1NrH8RE7XCKfmEgf0
Ok2gVCM1zp8IPuEq8GcRdg81K5l6WG2M1ifkxrsUkI4VsIi3kyVa1M4sPnwg/6Ev
AbmiHurcwpI=
=Na25
-----END PGP SIGNATURE-----

--=-LYxmelbr38wHD5b/t77S--
