Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaHMCHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 22:07:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54866 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071AbaHMCHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 22:07:12 -0400
Message-ID: <1407895613.3017.138.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [Ksummit-discuss] 2038 Kernel Summit Discussion Fodder
From: Ben Hutchings <ben@decadent.org.uk>
To: John Stultz <john.stultz@linaro.org>
Cc: ksummit-discuss@lists.linuxfoundation.org,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Wed, 13 Aug 2014 03:06:53 +0100
In-Reply-To: <CALAqxLUcfaJnxdmkn6mucepNk3QaCQdcSPLRjjeKsk_OTp=uLA@mail.gmail.com>
References: <CALAqxLUcfaJnxdmkn6mucepNk3QaCQdcSPLRjjeKsk_OTp=uLA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-buHD25CnbrD/lOAnp9pq"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-buHD25CnbrD/lOAnp9pq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-08-12 at 17:01 -0700, John Stultz wrote:
[...]
> The downsides here are many. The distros will probably hate this idea,

I certainly hate the idea of adding another 32-bit port to Debian.
I think that it's OK for traditional distros to say 'just upgrade to
64bit' while you solve the problem for 32-bit embedded systems where
there's probably little demand for supporting multiple ABIs at once.

>  as it requires rebuilding the world, and maintaining another legacy
> architecture support. I=E2=80=99m also not completely sure how robust
> multi-arch packaging is in the face of having to handle 3-4
> architectures on one system.

dpkg multiarch covers this just fine, while I believe RPM is limited to
biarch.

> On the kernel side, it also adds more complexity, where we have to add
> even more complex compat support for 64bit systems to handle all the
> various 32bit applications possible.
[...]

Didn't we need to do this already to support x32?  Have compat ioctls
involving time been botched?

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-buHD25CnbrD/lOAnp9pq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU+rIQue/yOyVhhEJAQprlw//QGjxutIPavrjD0F/rXIM7PHpdnijdTHO
RbBGTwYCFfyMvUWmXh1DNOjlCOkiNE5MvzzPTQvGKwH8t4vvmBqVOdOuB91AUrAs
lOmrgg9Gmmy5zQf2JpBw2qPSyzjSXpNZfz4oENsudTqTvDNpGo82V7LCW2MwEBrV
ut8dZUBdJhiiHhK9F3W8OlYoN1a6Q1Dq1YDM5x1VndD6Dt/4wV8dSl7Jjus7Rxif
wIXyTIRrtFShlJmpBJP41tM8I9epIwQKUhm31pSLpNjOlAufXKZjgf3COu5DeMXO
4NUoUDAcH0vKhhxjndq3GWX6Q6eH0mGj8q5ojXQZWFsmTaNMMANTS82mXcCtWMLd
kuXY4pF5tauv1htPymsE9pV3Uto46F+CkqQGV94xwwPtYhjAuGYd0pgaHOf8lN/c
XmiljNH7v/XvsN2wAmiXP2tM7x2fuiqF3yMqLG8FRhV/dKleoUbipVGXljEwLyrt
wD6Gh3cA6lUZ3AbUOynrFdstEI5neHXS8ovFsyUddoOh8tYe6mzhfmzjk8Rntand
y9Dp+fegaT/LaAU8J8JAFnFHz2uKIRvByEZcuUdJVlkriUOpgdhmHmtpac/D3bW2
OU9Lypk1N1vnsXERN+Aa5NgyNEDNpD3EKsyCheb0G0pkbg7MEFotyi7EZeKjo9gj
DPj3GJuE3T8=
=wYoB
-----END PGP SIGNATURE-----

--=-buHD25CnbrD/lOAnp9pq--
