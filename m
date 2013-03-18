Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab3CRCMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:12:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57257 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3CRCMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:12:34 -0400
Date: Mon, 18 Mar 2013 13:12:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Jones <pjones@redhat.com>, David Howells <dhowells@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-Id: <20130318131224.43ebcf542e6dea358f546198@canb.auug.org.au>
In-Reply-To: <CA+55aFwX5AmMgEAZ8uSdH=8g00xVD3NfnvgBbgSytMGdcifKMg@mail.gmail.com>
References: <30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
	<567.1361470653@warthog.procyon.org.uk>
	<CA+55aFyJFrU2ea+y8BS2tOawYY1DeDzEr4dYO4j8enewd+KHNQ@mail.gmail.com>
	<20130221183445.GB20629@fenchurch.internal.datastacks.com>
	<CA+55aFwX5AmMgEAZ8uSdH=8g00xVD3NfnvgBbgSytMGdcifKMg@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Mar_2013_13_12_24_+1100_V=h2kYrUsE/Foxfl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Mar_2013_13_12_24_+1100_V=h2kYrUsE/Foxfl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, 21 Feb 2013 10:56:44 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Thu, Feb 21, 2013 at 10:34 AM, Peter Jones <pjones@redhat.com> wrote:
> > On Thu, Feb 21, 2013 at 10:25:47AM -0800, Linus Torvalds wrote:
> >>  - why do you bother with the MS keysigning of Linux kernel modules to
> >> begin with?
> >
> > This is not actually what the patchset implements.  All it's done here
> > is using PE files as envelopes for keys.  The usage this enables is to
> > allow for whoever makes a module (binary only or merely out of tree for
> > whatever reason) to sign it and vouch for it themselves.  That could
> > include, for example, a systemtap module.
>=20
> Umm. And which part of "We already support that, using standard X.509
> certificates" did we suddenly miss?
>=20
> So no. The PE file thing makes no sense what-so-ever. What you mention
> we can already do, and we already do it *better*.

So, is this enough close enough to "I will never take this" for me to
remove it from linux-next, or could further discussion persuade you?

David, if I do remove it, are there other patches in your pekey tree that
are still going forward?

I ask because the pekey tree is interacting with other trees and it does
not make sense to have those interactions in linux-next if the pekey work
is never going upstream.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Mar_2013_13_12_24_+1100_V=h2kYrUsE/Foxfl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRRngIAAoJEECxmPOUX5FEgO8P/07LUCpXQNlUY5Q/fLqraz7c
4/HLpjncbeX70CKciTREPEBFeAENOLzwBlTh0tYkq10vR1yoxhwdpxe4oDbtnumM
3LxgPM6k1lOSUh6k+h8LoZV6Wn/RHTiSTU8QsGjQtJhJuHLjUY06aLz6iEbprRsr
Sh7l8IyX0ymJfuqHx9Rv6Py7EnOLXy7Iye9Z6mgWRDE80OAU/B8AjGSCmwkAmxrA
f1AyDBZ+rel3aNFCeofSahbbtiwC/21j7+cgJ78JOBkvkYZgyL1NKH49gZCr6Q6g
z7RJC3t3xvWP3sioUxSdlR60MKeE2/JkF3wCGP11yU0s3HP1klUHwKwa+2DBWkxw
1yE1rBIz6z3ts9uoEWKT48A9ImXyk9Yj+SSvvfzDVFX6HEoU45lChMVtXFNtVcXD
VG0yKuox2Kvx64BsCTGvFT09l5pZv2gGvRSG2FoW+YRhlu8iDxUnoSkXqdMMt2vQ
vLgjzcuoWUtU2Za4xMaA+7w/Nn3cDra7pGLLDFxsOrPTkz76rdsykvIWljs5iRTL
rE1PYL9JaCbJ1D8qzHyi/JxeyqtXGbZ0ZfySGQFX+1ptkdeLI4Tf7o9X3fIJix8M
opR+CpHv+S82BjT8rT1gFg6sc/FP1Ylb5Z47q4cs5NYPMcUbtbuI/3OfO1ETan9h
N4iLlN9F2PJ1NhWQTuvf
=07E3
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Mar_2013_13_12_24_+1100_V=h2kYrUsE/Foxfl--
